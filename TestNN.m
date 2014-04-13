%% Test the neural output. Report accuracies.
% Returns: predicted labels
%
function pred = testNN(Theta, Title, base_merged, base_label, set_test, pca_mu, pca_sigma, pca_U)

% The X_test is already transformed by PCA. 
% Otherwise we have to pass pca_* to predict()
labels = 1:max(base_label);
X_test = base_merged(set_test, :);
% We also apply the same PCA parameters to the test set
X_test = applyPCA(X_test, pca_mu, pca_sigma, pca_U);

y_test = base_label(set_test, :);

%% If single layer, {Theta1, Theta2}
pred = predictMultiNN(Theta, labels, X_test);

fprintf('\n%s\n', Title);
[F1, prec, recl] = F1score(y_test, pred, labels);
for i = labels
    fprintf('Class %d\n', i);
    fprintf('\tF1 = %.2f%%\n\tPrecision = %.2f%%\n\tRecall = %.2f%%\n',...
                F1(i)*100, prec(i)*100, recl(i)*100);
end
fprintf('Accuracy = %.2f%%\n', sum(pred == y_test)/numel(y_test)*100);

