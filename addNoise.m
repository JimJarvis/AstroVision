%% Add some predefined Gaussian noise to an image
%
function img = addNoise(img)

img = img + randn(size(img)) * 0.19;
