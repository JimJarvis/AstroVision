%% Get 1D-clustered bin ranges from the image pyramids of a few randomly chosen images in a specific folder
% parameter: 
% - folder: folder of the images
% - nBin: how many histogram bins per level. If a single number, we use the same nBin for all levels
% - nSample: how many samples to draw from the folder to do the 1D clustering
% - option: as specified in genFilters. Leave it [] to use defaults.
% - saveName: leave it blank if you don't want to save the result to disk. Otherwise specify this name and will be saved (or appended) to BIN_<saveName>.mat with the variable name bin_<saveName>_<nBin>
%
% returns:
% - bincell: a cell array whose components are the bin ranges of each level of the pyramid. Each bin range will have (nBin - 1) interval endpoints, omitting -Inf at beginning and +Inf at end. 
%
function bincell = imgBinRange(folder, nBin, nSample, option, saveName)

filters = genFilters(option);
level = numel(filters);

if numel(nBin) == 1
    nBin = nBin * ones(level);
elseif numel(nBin) ~= level
    error('levels of nBin must agree with levels of filters');
end

files = getFilesFolder(folder); % listing of all file names
nFile = numel(files);
% read a random FITS image
randImg = @() mat2gray(fitsread([folder '/' files{randi(nFile)}]));

% Randomly choose 10 images to do the 1D clustering for each level of the pyramid. Report their GVF as well
bincell = cell(level, 1);

for l = 1:level % l == 1 for the original unblurred image (filter will be empty)
    mergedImg = [];
    % multi-resolution
    for s = 1:nSample
        img = randImg();
        if ~isempty(filters{l})
            img = imfilter(img, filters{l}); end
        mergedImg = [mergedImg; img(:)];
    end
    bincell{l} = lloyd1D(mergedImg, nBin(l));
end

%% Save to disk
if exist('saveName', 'var')
    fileName = ['BIN_' saveName '.mat'];
    varName = ['bin_' saveName '_' num2str(nBin(1))];
    saveVar(fileName, varName, bincell);
end
