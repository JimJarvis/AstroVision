%% Randomly picks an FITS image file from a folder (data/'dataset')
%
function img = randImg(dataset)

folder = ['data/' dataset]; % make a symbolic link

files = getFilesFolder(folder);
% Select a random image from all the files in that folder
img = mat2gray(fitsread([folder '/' files{randi(numel(files))}]));
