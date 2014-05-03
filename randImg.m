%% Randomly picks an FITS image file from a folder (data/'dataset')
% - dataset
% - scale: if true, scale to 0/1 using mat2gray()
%
function img = randImg(dataset, scale)

folder = ['data/' dataset]; % make a symbolic link

files = getFilesFolder(folder);

img = fitsread([folder '/' files{randi(numel(files))}]);

% Select a random image from all the files in that folder
if exist('scale', 'var') && scale
    img = mat2gray(img);
end
