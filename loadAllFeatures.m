%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
%
function featureMap = loadAllFeatures()

folders = {'ref', 'si850'};
nbin = 256;

%% Precalculate the gaussian filters
dummyopt.field = 0;
opt.filters = genGaussianPyramid([], dummyopt);

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
        keyname = [f1 '-' f2 '-' num2str(nbin)];
        fprintf('\n======== %s ========\n', keyname);
        if isKey(featureMap, keyname)
            fprintf('Already in database. Pass. \n');
            continue
        end
        [varcell varmap] = loadVar(['BIN_' f2]);
        opt.bincell = varcell{varmap(['bin_' f2 '_' num2str(nbin)])};
        featureMap(keyname) = ...
            batchFeatureFolder(fName(f1), opt);
    end
end

save('AstroFeatures', 'featureMap');
fprintf('\nDONE\n');
