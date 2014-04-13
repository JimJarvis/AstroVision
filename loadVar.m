%% Load into a variable from a ".mat" file on disk
% If the .mat file has more than 1 variable, return a cell array that holds each variable in sequence
%
function v = loadVar(matfile)

loaded = load(matfile);
fns = fieldnames(loaded);

v = cell(numel(fns), 1);
for i = 1:numel(fns)
    v{i} = getfield(loaded, fns{i});
end
