%% Generate a reduction Gaussian Pyramid
% optionally save the images to disk

function imgPyramid = genGaussianPyramid(img, level, save_img_name)

if ~exist('level', 'var')
    level = floor(0.5 * log2(numel(img)));
end

imgPyramid = cell(level, 1);
imgPyramid{1} = img;

for i = 2:level
    gauss = vision.Pyramid('PyramidLevel', i-1);
    imgPyramid{i} = step(gauss, img);
end

if exist('save_img_name', 'var')  % save the images
    for i = 1:level
        imwrite(uint8(imgPyramid{i}), ...
            sprintf('test_images/%s_%d.png', save_img_name, i));
    end
end
