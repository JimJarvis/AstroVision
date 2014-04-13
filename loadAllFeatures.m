%% Loads images from all folders, computes features and stores them
% option struct as specified in optionReader
%
function datamap = loadAllFeatures()

fName = @(folder) ['data\' folder];
% folders = {'ref', 'si850', 'w12', 'om23'};
folders = {'ref', 'si850', 'w12'};
datamap = containers.Map(); % matlab hashmap

for folder = folders  
    folder = folder{1};
    fprintf('\n=========== %s ===========\n', folder);
    loaded = loadVar(['BIN_' folder]);
    opt.bincell = loaded{1}
    datamap(folder) = ...
        batchFeatureFolder(fName(folder), opt);
end
save('AstroBase', datamap);
fprintf('\nDONE\n');
