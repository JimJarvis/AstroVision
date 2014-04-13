%% Load into a variable from a ".mat" file on disk
% Returns:
% - a cell array with each variable in sequence
% - a map that maps a var name to an int index in the cell array
% usage: c{m('varname')}
%
function [c m] = loadVar(matfile)

loaded = load(matfile);
fns = fieldnames(loaded);

c = cell(numel(fns), 1);
m = containers.Map();
for i = 1:numel(fns)
    c{i} = getfield(loaded, fns{i});
    m(fns{i}) = i;
end
