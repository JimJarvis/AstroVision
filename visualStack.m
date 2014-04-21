%% Generate, display and save a stack of Gaussian pyramid
% Press any key to display the stack one by one. Close all at last.
% Parameters:
% - Randomly pick an image file from a folder (data/'dataset') 
% - fil (optional): if empty, use the default genFilter([])
% - saveName (optional): save to 'test/*' with saveName_level
%
function [] = visualStack(dataset, fil, saveName)

intensity = 4; % multiply the image to exaggerate the contrast

% Select a random image from all the files in that folder
img = randImg(dataset);

% Use the default filter
if ~exist('fil', 'var') || isempty(fil)
    fil = genFilters([]);
end

% Generate the image stack
level = numel(fil);
stack = cell(level, 1);
stack{1} = img * intensity;  % to exaggerate the brightness
for l = 2:level
    stack{l} = imfilter(img, fil{l}) * intensity;
end

% save to 'test/' folder
if exist('saveName', 'var')
    for l = 1:level
        imwrite((stack{l}), ['test/' saveName '_' num2str(l) '.png']);
    end
end

% display the images
for l = 1:level
    figure, imshow(stack{l});
    pause;
end

close all;
