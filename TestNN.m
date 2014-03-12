%% ================= Testing =================
%
% The X_test is already transformed by PCA. 
% Otherwise we have to pass pca_* to predict()
labels = 1:max(base_label);
X_test = base_merged(set_test, :);
% We also apply the same PCA parameters to the test set
X_test = applyPCA(X_test, pca_mu, pca_sigma, pca_U);

y_test = base_label(set_test, :);

if numel(hidden_layer_size) > 1
    pred = predictMultiNN(Theta, labels, X_test);
else % single layer
    pred = predictNN(Theta1, Theta2, labels, X_test);
end

fprintf('\nError analysis\n');
[F1, prec, recl] = F1score(y_test, pred, labels);
for i = labels
    fprintf('Class %d\n', i);
    fprintf('\tF1 = %.2f%%\n\tPrecision = %.2f%%\n\tRecall = %.2f%%\n',...
                F1(i)*100, prec(i)*100, recl(i)*100);
end
fprintf('Accuracy = %.2f%%\n', sum(pred == y_test)/numel(y_test)*100);

