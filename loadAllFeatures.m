%% Loads all images from a dataset, computes features and stores them
% Store to either "Noise_*.mat" or "Pure_*.mat"
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
% Parameters:
% - datasets: cell array of datasets: {'ref', 'si850'}, default folder data/'dataset'
% - nBins: the bin level for each pyramid layer. Must be consistent with those stored in BIN_*.mat. If specified as an array, the same effect as calling loadAllFeatures() multiple times with different bin levels. 
% - method: how to specify the bins.
%   - "each": load from BIN_*.mat a different bin for each level
%   - "first": load from BIN_*.mat only the bin for the first level and apply the same bin to all the successive levels.
%   - "equal": equally spaced bins. If this method is invoked, the members in "datasets" will be considered separately
% - isNoisy: add noises to the images?
%
function [] = loadAllFeatures(datasets, nBins, method, isNoisy)

%% Precalculate the gaussian filters
isNoisy = exist('isNoisy', 'var') && isNoisy;
filters = genFilters(isNoisy);

% mat-feature file
if isNoisy, header = 'Noisy_'; else header = 'Pure_'; end
FILE = [header method '.mat'];
if ~iscell(datasets), datasets = {datasets}; end

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

%% Helper: save all feature vectors from a dataset to disk with a specified varName
function saveToDisk(dataset, bincell, varName)
    features = batchFeatureSet(dataset, filters, bincell, isNoisy);
    fprintf('\nSaving %s to disk ...\n', varName);
    saveVar(FILE, varName, features);
end

%% Helper: test if an entry already exists in the database. If yes, skip
function exists = existEntry(varName)
    fprintf('\n======== %s ========\n', varName);
    % featureMap = loadVar(FILE); % refresh the variable list
    exists = isKey(featureMap, varName);
    if exists
        fprintf('Entry already in database. Pass. \n');
    end
end

if isNoisy, header = 'BIN_noisy_'; else header = 'BIN_pure_'; end

for nBin = nBins
    for set1 = datasets  
        set1 = set1{1};

        if strcmp(method, 'equal')
            binMap = loadVar([header 'equal']);
            bincell = binMap(['bin_' num2str(nBin)]);
            varName = [set1 '_' num2str(nBin)];
            if existEntry(varName), continue, end
            saveToDisk(set1, bincell, varName);

        else % adaptive methods

            for set2 = datasets
                set2 = set2{1};
                varName = [set1 '_' set2 '_' num2str(nBin)];

                if existEntry(varName), continue, end

                % adaptive bins
                binMap = loadVar([header set2]);
                % adapt_each
                bincell = binMap(['bin_' set2 '_' num2str(nBin)]);
                if strcmp(method, 'first')
                    % All levels are the same
                    bincell = bincell{1};
                end

                % Save to disk frequently
                saveToDisk(set1, bincell, varName);
            end
        end
    end
end

fprintf('\nDONE\n');
end % end of loadAllFeatures
