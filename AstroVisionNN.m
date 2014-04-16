%%%% AstroVision Neural Network training (and testing)
% Jim Fan 2014
% Jarvis Initiative
%
%% Settable parameters
base_key = {'ref-ref', 'w12-ref'};
nBin = 256;
hidden_layer_size = 800; % if an array, we use multi-layer NN
iter = 400;  % gradient descent iterations, negative to use tolerance
lambda = 1;  % regularization coeff
pca_variance_thresh = 0.999; % how much variance we'd like to retain 
                    % when compressing training data by PCA
tol_NN = 0.11; % neural network error tolerance
preprocess = 1; % set to true to perform data set splitting and PCA, 
                % otherwise directly call pca_* and set_* from workspace
testing = 0; % set to true to perform testing (and cross-validation). 


%% ================== Training/Testing data =================
%
%% Decide whether we are using multi-layered NN or single-layered
MULTI_NN = numel(hidden_layer_size) > 1;

if MULTI_NN
    fprintf('\nMulti-layered NN\n')
else
    fprintf('\nSingle-layered NN\n')
end

% Split the data into training and testing sets
%
if preprocess
    disp('Splitting the database into training/validation/test.');
    % Load from featureMap
    featureMap = loadVar('AstroFeatures'); featureMap = featureMap{1};
    bases = cell(numel(base_key), 1);
    for i = 1:numel(bases)
        bases{i} = featureMap([base_key{i} '-' num2str(nBin)]);
    end
    
    [base_merged, base_label, set_train, set_test, set_valid] = splitBase(bases);
end

label_size = max(base_label);
labels = 1:label_size; % all possible label types

fprintf('Training set size: %d\n', numel(set_train));
fprintf('Validation set size: %d\n', numel(set_valid));
fprintf('Testing set size: %d\n', numel(set_test));
fprintf('Labels: %d\n', label_size);
fprintf('Hidden Layer: %d\n', hidden_layer_size);

X_train = base_merged(set_train, :);
y_train = base_label(set_train, :);

    % unroll y_train
    % Expand y to m-by-#label row vectors with only 0 and 1
    % then convert logicals to double 0/1
    % y = double(repmat(y, 1, label_size) == repmat(labels, m, 1));
    % Better: y = eye(label_size)(y, :); //only works in Octave
y_train = double(repmat(y_train, 1, label_size) ...
            == repmat(labels, size(X_train, 1), 1));

% Apply PCA compression to X_train
if preprocess
    disp('Apply PCA to training data');
    [X_train, pca_U, pca_k, pca_mu, pca_sigma] = trainPCA(X_train, pca_variance_thresh); 
else
    X_train = applyPCA(X_train, pca_mu, pca_sigma, pca_U); end

input_layer_size = pca_k;
fprintf('Dimension reduction: %d/%d',...
            pca_k, size(base_merged, 2));


%% ================= Initialization ===============
fprintf('\n\nInitializing Neural Network Parameters ...\n')

if MULTI_NN
    Layer_sizes = [input_layer_size hidden_layer_size label_size];

    % here Theta is a cell array that contains (number-of-hidden-layer + 1) Thetas.
    Theta = cell(numel(Layer_sizes)-1, 1);

    % Unroll parameters
    initial_nn_params = [];
    for i = 1:numel(Theta)
        thetai = randInitializeWeights(Layer_sizes(i), Layer_sizes(i+1));
        initial_nn_params = [initial_nn_params; thetai(:)];
    end

else % single layer

    initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
    initial_Theta2 = randInitializeWeights(hidden_layer_size, label_size);

    % Unroll parameters
    initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

end

fprintf('Theta dimension = %d', numel(initial_nn_params));

%% ============= Training Neural Network ===================
%
fprintf('\nTraining Neural Network... \n')

if iter < 1
    options = optimset('MaxIter', 1000, 'TolX', tol_NN);
else
    options = optimset('MaxIter', iter, 'TolX', tol_NN);
end


if MULTI_NN

    % curried function to be minimized: takes only 1 input
    costFunction = @(p) nnCostFunctionMulti(p, Layer_sizes, ...
                            X_train, y_train, lambda);

    % Advanced minimizer
    [nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

    % Obtain the Theta{} by unrolling the flattened nn_params
    startn = 1; lengn = 0;
    for i = 1:numel(Theta)
        lengn = Layer_sizes(i+1) * (Layer_sizes(i)+1);
        Theta{i} = reshape(nn_params(startn:startn+lengn-1), ...
            Layer_sizes(i+1), Layer_sizes(i)+1);
        startn = startn + lengn;
    end

else % single layer

    % curried function to be minimized: takes only 1 input
    costFunction = @(p) nnCostFunction(p, ...
                                       input_layer_size, ...
                                       hidden_layer_size, ...
                                       label_size, X_train, y_train, lambda);

    % Advanced minimizer
    [nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

    % Obtain Theta1 and Theta2 back from nn_params
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                     hidden_layer_size, (input_layer_size + 1));

    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                     label_size, (hidden_layer_size + 1));

end


%% ================= Testing and Cross Validation =================
%

if ~MULTI_NN
    Theta = {Theta1, Theta2}; end

%% Cross validation
testNN(Theta, 'Cross Validation', base_merged, base_label, set_valid, pca_mu, pca_sigma, pca_U);

%% Optionally testing
if testing
testNN(Theta, 'Testing', base_merged, base_label, set_test, pca_mu, pca_sigma, pca_U);
end


%% ================= Saving to disk =================
%
save AstroNN Theta base_names base_merged base_label set_train set_test set_valid hidden_layer_size pca_U pca_k pca_mu pca_sigma pca_variance_thresh;
