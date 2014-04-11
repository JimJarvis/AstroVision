%% Get a matrix of feature vectors from a folder of images
% Each row a feauture, each col a dimension in a feature
% <Subfolder name>, <levels of gaussian pyramid>
% max_pyramid_level: the maximum level to be stored in the database
%
function features = batchFeatureFolder(folder, max_pyramid_level)

listing = dir(folder);

% listing also includes two dirs, './' and '../'
% i represents the 'real' index
i = 1;

for l = 1 : numel(listing)
    file = listing(l);
    if ~file.isdir
        fprintf('Image %d ...\n', i);
        try
            % might throw FITS read error
            img = fitsread([folder '\' file.name]);
        catch err
            fprintf(['ERROR:\t' file.name '\n']);
            continue
        end

        if i == 1: % first time, we allocate the space
            fea = getFeature(img, max_pyramid_level);
            features = zeros(numel(listing)-2, numel(fea));
        end
        features(i, :) = getFeature(img, max_pyramid_level);
        i = i + 1;
    end
end
