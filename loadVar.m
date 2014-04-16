%% Load into a variable from a ".mat" file on disk
% Parameters:
% - matfile 
% - singlevar [optional], if this flag true, return [value, varname] instead
% Returns:
% - a cell array with each variable in sequence
% - a map that maps a var name to an int index in the cell array
% usage: c{m('varname')}
%
function [c m] = loadVar(matfile, singlevar)

loaded = load(matfile);
fns = fieldnames(loaded);

%% c = variable's value and m = its name
if exist('singlevar', 'var')
    m = fns{1};
    c = getfield(loaded, m);
    return
end

c = cell(numel(fns), 1);
m = containers.Map();
for i = 1:numel(fns)
    c{i} = getfield(loaded, fns{i});
    m(fns{i}) = i;
end
