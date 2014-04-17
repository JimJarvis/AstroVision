%% Get a matrix of feature vectors from a folder of images
% Each row a feauture, each col a dimension in a feature
% <Subfolder name>, <Feature generation options>
%
function features = batchFeatureFolder(folder, option)

% i represents the 'real' index
i = 1;
fileList = getFilesFolder(folder);
for file = fileList
    fname = file{1}; % get file name from the singleton cell
    fprintf('%d ... ', i);
    try
        % might throw FITS read error
        % mat2gray to convert to [0, 1]
        img = mat2gray(fitsread([folder '/' fname]));
    catch err
        fprintf(['ERROR:\t' fname '\n']);
        continue
    end

    if i == 1 % first time, we allocate the space
        fea = getFeature(img, option);
        features = zeros(numel(fileList), numel(fea));
    end
    features(i, :) = getFeature(img, option);
    i = i + 1;
end
