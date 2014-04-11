%% Get a feature vector from a folder of images
% Subfolder name, levels of gaussian pyramid
% max_pyramid_level: the maximum level to be stored in the database
% later we use concatFeatures to use histograms from various depths
%
function features = batchFeatureFolder(folder, max_pyramid_level)

listing = dir(folder);

% listing also includes two dirs, './' and '../'
i = 1;
% Dim1: difference levels, Dim2: number of histogram bins, Dim3: data samples 
features = zeros(max_pyramid_level-1, 256, numel(listing) - 2);

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

        features(:, :, i) = histogramFeature(img, max_pyramid_level);
        i = i + 1;
    end
end

% Some images might be corrupted and not stored
features = features(:, :, 1:i-1);
