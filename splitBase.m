%% Merge n bases (cell array) and then split into training and testing features
% for n-class classification
% Each base has row as feature vectors
% Parameters:
% - bases: cell array of bases
% - percent_test: how much percent of the dataset should be test data [15%]
% - percent_valid: how much percent of the dataset should be cross-validation [10%]
% Returns: 
% - base_merged
% - base_label: all the correct label to base_merged
% - set_train, set_test, set_valid: contains the indices for each sample set
%
function [base_merged base_label set_train set_test set_valid] = splitBase(bases, percent_test, percent_valid)

if ~exist('percent_test', 'var') || isempty(percent_test)
    percent_test = 0.15;
end
if ~exist('percent_valid', 'var') || isempty(percent_valid)
    percent_valid = 0.1;
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

% no splitting at all
if percent_test == 0 && percent_valid == 0, return, end

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
set_valid = [];

idx_start = 0;
for label = 1:N
    len = size(bases{label}, 1);
    split1 = ceil(len * (1 - percent_test - percent_valid));
    split2 = ceil(len * (1 - percent_valid));
    idxs = idx_start + (1:len);
    idxs = randpermA(idxs);
    set_train = [set_train idxs(1:split1)];
    set_test = [set_test idxs(split1+1:split2)];
    set_valid = [set_valid idxs(split2+1:end)];

    idx_start = idx_start + len;
end

set_train = randpermA(set_train);
set_test = randpermA(set_test);
set_valid = randpermA(set_valid);

end
