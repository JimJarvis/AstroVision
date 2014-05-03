%% Get a matrix of feature vectors from a set of images
% Each row a feauture, each col a dimension in a feature
% Parameters:
% - dataset: assume the folder to be data/'dataset'
% - filters
% - bincell
%
function features = batchFeatureSet(dataset, filters, bincell)

FOLDER = ['data/' dataset];

% i represents the 'real' index
i = 1;
fileList = getFilesFolder(FOLDER);
for file = fileList
    fname = file{1}; % get file name from the singleton cell
    fprintf('%d ... ', i);
    try
        % might throw FITS read error
        % mat2gray to convert to [0, 1]
        img = fitsread([FOLDER '/' fname]);
    catch err
        fprintf(['ERROR:\t' fname '\n']);
        continue
    end

    if i == 1 % first time, we allocate the space
        fea = getFeature(img, filters, bincell);
        features = zeros(numel(fileList), numel(fea));
        features(i, :) = fea;
    else
        features(i, :) = getFeature(img, filters, bincell);
    end

    i = i + 1;
end
