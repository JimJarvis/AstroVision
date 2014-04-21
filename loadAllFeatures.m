%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
% Parameters:
% - folders: cell array of folders: {'ref', 'si850'}
% - NBin: the bin level for each pyramid layer. Must be consistent with those stored in BIN_*.mat. If specified as an array, the same effect as calling loadAllFeatures() multiple times with different bin levels. 
% - method: how to specify the bins.
%   - "adapt_each": load from BIN_*.mat a different bin for each level
%   - "adapt": load from BIN_*.mat only the bin for the first level and apply the same bin to all the successive levels.
%   - "equal": equally spaced bins. If this method is invoked, the members in "folder" will be considered separately
%
function [] = loadAllFeatures(folders, NBin, method)

% mat-feature file
FILE = ['AstroFeatures_' method '.mat'];
fName = @(folder) ['data/' folder];
if ~iscell(folders), folders = {folders}; end

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

%% Helper: test if an entry already exists in the database. If yes, skip
function exists = existEntry(varName)
    % featureMap = loadVar(FILE); % refresh the variable list
    exists = isKey(featureMap, varName);
    if exists
        fprintf('Entry already in database. Pass. \n');
    end
end

%% Helper: save a batch feature to disk with a specified varName
function saveToDisk(folder, opt, varName)
    features = batchFeatureFolder(fName(folder), opt);
    fprintf('\nSaving %s to disk ...\n', varName);
    saveVar(FILE, varName, features);
end


for nBin = NBin
    for f1 = folders  
        f1 = f1{1};

        if strcmp(method, 'equal')
            opt.bincell = linspace(0, 1, nBin + 1)';
            opt.bincell = opt.bincell(2:end-1);
            varName = [f1 '_' num2str(nBin)];
            if existEntry(varName), continue, end
            saveToDisk(f1, opt, varName);

        else % adaptive methods

            for f2 = folders
                f2 = f2{1};
                varName = [f1 '_' f2 '_' num2str(nBin)];
                fprintf('\n======== %s ========\n', varName);

                if existEntry(varName), continue, end

                % adaptive bins
                binMap = loadVar(['BIN_' f2]);
                % adapt_each
                opt.bincell = binMap(['bin_' f2 '_' num2str(nBin)]);
                if strcmp(method, 'adapt')
                    % All levels are the same
                    'good'
                    opt.bincell = opt.bincell{1};
                end

                % Save to disk frequently
                saveToDisk(f1, opt, varName);
            end
        end
    end
end

fprintf('\nDONE\n');
end % end of loadAllFeatures
