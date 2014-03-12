%% Merge n bases (cell array) and then split into training and testing features
% for n-class classification
% Each base has row as feature vectors
% base_label: all the correct label to base_merged
% set how much percentage to be training (VS testing), default 80%
% set_train/test contains the indices of the samples
%
function [base_merged base_label set_train set_test] = splitBase(bases, percent)

if ~exist('percent', 'var') || isempty(percent)
    percent = 0.8;
end

N = numel(bases); % N-classification problem

% A simple concatenation. The set_* will indicate which are training and which are testing
base_merged = bases{1};
base_label = ones(size(bases{1}, 1), 1);
for i = 2:N
    base_merged = [base_merged; bases{i}];
    % label = #base (i)
    base_label = [base_label; ones(size(bases{i}, 1), 1) * i];
end

%{
label_func = @labelFunc;
    lengs = zeros(1, N+1);
    lengs(1) = 1;
    for i = 1:N
        lengs(i+1) = size(bases{i}, 1);
    end
    lengs = cumsum(lengs);
    function label = labelFunc(idx)
        [~, label] = histc([idx], lengs);
    end
%}

set_train = [];
set_test = [];

idx_start = 0;
for label = 1:N
    len = size(bases{label}, 1);
    split = ceil(len * percent);
    idxs = idx_start + (1:len);
    idxs = randpermA(idxs);
    set_train = [set_train idxs(1:split)];
    set_test = [set_test idxs(split+1:end)];

    idx_start = idx_start + len;
end

set_train = randpermA(set_train);
set_test = randpermA(set_test);

end
