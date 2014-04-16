%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
% Parameters:
% - folders: cell array of folders: {'ref', 'si850'}
% - nBin: the bin level for each pyramid layer. Must be consistent with those stored in BIN_*.mat
function featureMap = loadAllFeatures(folders, nBin)

% folders = {'ref', 'si850'};
% nBin = 128;

%% Precalculate the gaussian filters
opt.filters = genFilters([]);

fName = @(folder) ['data/' folder];

if exist('AstroFeatures.mat', 'file')
    featureMap = loadVar('AstroFeatures', true); % single var loading
    fprintf('AstroFeatures.mat exists on disk. Current key values:\n');
    for key = featureMap.keys
        fprintf('%s\n', key{1});
    end
    fprintf('Write new key-value pairs to ''featureMap''\n');
else
    fprintf('Create a new AstroFeatures.mat with ''featureMap'' hash map \n');
    featureMap = containers.Map(); % matlab hashmap
end

for f1 = folders  
    f1 = f1{1};
    for f2 = folders
        f2 = f2{1};
        keyname = [f1 '-' f2 '-' num2str(nBin)];
        fprintf('\n======== %s ========\n', keyname);
        if isKey(featureMap, keyname)
            fprintf('Already in database. Pass. \n');
            continue
        end
        [varcell varmap] = loadVar(['BIN_' f2]);
        opt.bincell = varcell{varmap(['bin_' f2 '_' num2str(nBin)])};
        featureMap(keyname) = ...
            batchFeatureFolder(fName(f1), opt);

       % Save to disk frequently
        fprintf('\nSaving %s to disk ...\n', keyname);
        save('AstroFeatures', 'featureMap');
    end
end

fprintf('\nDONE\n');
