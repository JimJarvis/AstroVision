%% Generate, display and save a stack of Gaussian pyramid
% Press any key to display the stack one by one. Close all at last.
% Parameters:
% - Randomly pick an image file from a folder (data/'dataset') 
% - isNoisy: use different filters
% - saveName (optional): save to 'test/*' with saveName_level
%
function [] = visualStack(dataset, isNoisy, saveName)

intensity = 15; % multiply the image to exaggerate the contrast

% Use the default filter
fil = genFilters(isNoisy);

% Select a random image from all the files in that folder
img = randImg(dataset);
if isNoisy
    img = addNoise(img);
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
        imwrite(stack{l}, ...
            sprintf('test/%s_%d.png', saveName, l));
    end
end

% display the images
for l = 1:level
    figure, imshow(stack{l});
    pause;
end

close all;
