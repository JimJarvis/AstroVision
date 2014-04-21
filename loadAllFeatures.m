%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
% Parameters:
% - folders: cell array of folders: {'ref', 'si850'}
% - nBin: the bin level for each pyramid layer. Must be consistent with those stored in BIN_*.mat
% - method: how to specify the bins.
%   - "adapt_each": load from BIN_*.mat a different bin for each level
%   - "adapt": load from BIN_*.mat only the bin for the first level and apply the same bin to all the successive levels.
%   - "equal": equally spaced bins.
%
function [] = loadAllFeatures(folders, nBin, method)

% mat-feature file
FILE = ['AstroFeatures_' method '.mat'];
fName = @(folder) ['data/' folder];

%% Precalculate the gaussian filters
opt.filters = genFilters([]);

featureMap = loadVar(FILE);
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

        featureMap = loadVar(FILE);
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
