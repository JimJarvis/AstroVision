%% Selects the database we want to use for training/testing
% base_names: stored in AstroBase.mat
% different pyramid level gives different feature databases
% level >= 2 (because they're difference vectors)
% returns a cell array that contains data for each class
%
function base_array = selectBase(base_names, pyramid_level)

base_array = cell(numel(base_names), 1);

for i = 1:numel(base_names)
    v = ['F_' base_names{i}];
    v = evalin('base', v);
    base_array{i} = concatFeatures(v, pyramid_level);
end
