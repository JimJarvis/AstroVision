%% Generate a Gaussian Pyramid
% optionally save the stack to disk

function imgPyramid = genGaussianPyramid(img, option, save_img_name)

[level window sigma scale] = optionReader(option);

imgPyramid = cell(level, 1);
imgPyramid{1} = img;

for l = 2:level
    imgPyramid{l} = imfilter(img, ...
        fspecial('gaussian', window, sigma * scale^(l-2)));
end

if exist('save_img_name', 'var')  % save the images
    for i = 1:level
        imwrite(uint8(imgPyramid{i}), ...
            sprintf('test/%s_%d.png', save_img_name, i));
    end
end
