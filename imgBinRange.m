%% Get 1D-clustered bin ranges from the image pyramids of a few randomly chosen images in a specific folder
% parameter: 
% - folder: folder of the images
% - nSample: how many samples to draw from the folder to do the 1D clustering
% - option: specify various options using optionReader()
%
% returns:
% - bincell: a cell array whose components are the bin ranges of each level of the pyramid. Each bin range will have (nbin - 1) interval endpoints, omitting -Inf at beginning and +Inf at end. 
%
function bincell = imgBinRange(folder, nSample, option)

[level, window, sigma, scale, nbin] = optionReader(option);

files = getFilesFolder(folder); % listing of all file names
nFile = numel(files);
% read a random FITS image
randImg = @() mat2gray(fitsread([folder '/' files{randi(nFile)}]));

% Randomly choose 10 images to do the 1D clustering for each level of the pyramid. Report their GVF as well
bincell = cell(level, 1);

for l = 1:level % l == 1 for the original unblurred image
    mergedImg = [];
    % multi-resolution
    if l ~= 1
        gfilter = fspecial('gaussian', window, sigma * scale^(l-2)); end
    for s = 1:nSample
        img = randImg();
        if l ~= 1
            img = imfilter(img, gfilter); end
        mergedImg = [mergedImg; img(:)];
    end
    bincell{l} = lloyd1D(mergedImg, nbin(l));
end
