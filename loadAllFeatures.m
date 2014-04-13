%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
%
function datamap = loadAllFeatures()

folders = {'ref', 'si850', 'w12'};

fName = @(folder) ['data/' folder];
datamap = containers.Map(); % matlab hashmap

for folder = folders  
    folder = folder{1};
    fprintf('\n=========== %s ===========\n', folder);
    loaded = loadVar(['BIN_' folder]);
    opt.bincell = loaded{1};
    datamap(folder) = ...
        batchFeatureFolder(fName(folder), opt);
end
save('AstroBase', datamap);
fprintf('\nDONE\n');
