%% Compare the prediction with the golden standard
% Returns the F1, precision and recall for each label
function [F1 precision recall] = F1score(golds, preds, labels)

N = numel(labels);
F1 = zeros(N, 1);
precision = zeros(N, 1);
recall = zeros(N, 1);

for i = 1:N
    label = labels(i); % current class analyzing
    pred = preds == label;
    gold = golds == label;
    true_pos = sum(gold & pred);
    % false_pos = sum(~gold & pred);
    % false_neg = sum(gold & ~pred);
    precision(i) = true_pos / sum(pred);
    recall(i) = true_pos / sum(gold);
    F1(i) = 2 * precision(i) * recall(i) / (precision(i) + recall(i));
end
