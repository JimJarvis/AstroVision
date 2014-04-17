%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
% Parameters:
% - folders: cell array of folders: {'ref', 'si850'}
% - nBin: the bin level for each pyramid layer. Must be consistent with those stored in BIN_*.mat
function [] = loadAllFeatures(folders, nBin)

% folders = {'ref', 'si850'};
% nBin = 128;
FILE = 'AstroFeatures.mat';

%% Precalculate the gaussian filters
opt.filters = genFilters([]);

fName = @(folder) ['data/' folder];

featureMap = loadVar('AstroFeatures');
if exist(FILE, 'file')
    fprintf('%s exists on disk. Current values:\n', FILE);
    for key = featureMap.keys
        fprintf('%s\n', key{1});
    end
    fprintf('Write new values to %s\n', FILE);
else
    fprintf('Create a new %s\n', FILE);
end

for f1 = folders  
    f1 = f1{1};
    for f2 = folders
        f2 = f2{1};
        varName = [f1 '_' f2 '_' num2str(nBin)];
        fprintf('\n======== %s ========\n', varName);

        featureMap = loadVar('AstroFeatures');
        if isKey(featureMap, varName)
            fprintf('Already in database. Pass. \n');
            continue
        end
        binMap = loadVar(['BIN_' f2]);
        opt.bincell = binMap(['bin_' f2 '_' num2str(nBin)]);
        features = batchFeatureFolder(fName(f1), opt);

       % Save to disk frequently
        fprintf('\nSaving %s to disk ...\n', varName);
        saveVar(FILE, varName, features);
    end
end

fprintf('\nDONE\n');
