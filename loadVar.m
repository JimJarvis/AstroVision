%% Load into a variable from a ".mat" file on disk
% Parameters:
% - fileName 
% - singlevar [optional], if this flag true, return value directly instead
% Returns:
% - a map that maps a var name to a value
% usage: c{m('varname')}
%
function map = loadVar(fileName, singlevar)

if ~strcmp(fileName(end-3:end), '.mat')
    fileName = [fileName '.mat'];
end

%% If not exist, return empty
if ~exist(fileName, 'file')
    map = containers.Map();
    return;
end

loaded = load(fileName);
fns = fieldnames(loaded);

%% c = variable's value and m = its name
if exist('singlevar', 'var')
    map = getfield(loaded, fns{1});
    return
end

map = containers.Map();
for i = 1:numel(fns)
    map(fns{i}) = getfield(loaded, fns{i});
end
