%% Loads images from all folders, computes features and stores them
% option struct as specified in optionReader
%
function datamap = loadAllFeatures(option)

fName = @(folder) ['data\' folder];
folders = {'ref', 'si850', 'w12', 'om23'};
datamap = containers.Map(); % matlab hashmap

for folder = folders  
    folder = folder{1};
    fprintf('\nProcessing %s ...\n', folder);
    datamap(folder) = ...
        batchFeatureFolder(fName(folder), option);
end
save('AstroBase', datamap);
fprintf('\nDONE\n');
