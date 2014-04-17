%% Save a value with a user-specified name to file.mat
% If the file doesn't exist, create it. If exists, append to it.
% If the fileName doesn't have ".mat" extension, automatically add it
%
function [] = saveVar(fileName, varName, value)

if ~strcmp(fileName(end-3:end), '.mat')
    fileName = [fileName '.mat'];
end

eval([varName '=value;']);
if exist(fileName, 'file')
    eval(['save ' fileName ' ' varName ' -append']);
else
    eval(['save ' fileName ' ' varName]);
end
