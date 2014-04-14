%% Generate a Gaussian Pyramid
% If the input img is [], we don't process any image but return the gaussian filters at each level instead. 
% optionally save the stack to disk

function imgPyramid = genGaussianPyramid(img, option, save_img_name)

[level window sigma scale] = optionReader(option);
imgPyramid = cell(level, 1);

if isempty(img)
    imgPyramid = cell(level, 1);
    for l = 2:level
        imgPyramid{l} = fspecial('gaussian', window, sigma * scale^(l-2));
    end
    return
end

imgPyramid{1} = img;

if isfield(option, 'filters')
    % Use pre-calculated filters
    'good'
    for l = 2:level
        imgPyramid{l} = imfilter(img, option.filters{l});
    end
else
    % calculate the gaussian on the fly
    for l = 2:level
        imgPyramid{l} = imfilter(img, ...
            fspecial('gaussian', window, sigma * scale^(l-2)));
    end
end

if exist('save_img_name', 'var')  % save the images
    for i = 1:level
        imwrite(uint8(imgPyramid{i}), ...
            sprintf('test/%s_%d.png', save_img_name, i));
    end
end
