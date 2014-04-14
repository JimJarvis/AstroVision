%% Loads images from all folders, computes features and stores them
% Gaussian pyramid options must be consistent with how the BIN_*.mat are generated
%
function featureMap = loadAllFeatures()

folders = {'ref', 'w12'};
nbin = 256;

%% Precalculate the gaussian filters
dummyopt.field = 0;
opt.filters = genGaussianPyramid([], dummyopt);

fName = @(folder) ['data/' folder];
featureMap = containers.Map(); % matlab hashmap

for f1 = folders  
    f1 = f1{1};
    for f2 = folders
        f2 = f2{1};
        fprintf('\n======== %s - %s ========\n', f1, f2);
        [varcell varmap] = loadVar(['BIN_' f2]);
        opt.bincell = varcell{varmap(['bin_' f2 '_' num2str(nbin)])};
        featureMap([f1 '-' f2]) = ...
            batchFeatureFolder(fName(f1), opt);
    end
end

save('AstroFeatures', 'featureMap');
fprintf('\nDONE\n');
