%% Generate a pyramid of gaussian filters
% Parameter: option struct
% .level: pyramid level [6]
% .window: gaussian window size [7]
% .sigma: initial sigma [1]
% .scale: sigma * scale^n, should always be > 1 [2]
%
% .img: apply the filters on the image and save the pyramid stack to disk
% .save: file name for the saved stack
%
function filters = genFilters(option)

% If 'filters' field is already specified, then do nothing
if isfield(option, 'filters'), filters = option.filters; return; end

if isfield(option, 'level'), level = option.level; else level = 7; end
if isfield(option, 'sigma'), sigma = option.sigma; else sigma = 2; end
if isfield(option, 'scale'), scale = option.scale; else scale = 1.5; end

filters = cell(level, 1);

% Leave filter{1} empty because the first level is the original image
for l = 2:level
    % Half-window will be 2 sigma in width
    s = sigma * scale^(l - 2);
    filters{l} = fspecial('gaussian', ceil(4*s), s);
end

if isfield(option, 'img')
    if ~isfield(option, 'save')
        error('You must specify a file name for saving');
        return
    end
    for l = 1:level
        if isempty(filters{l})
            img = option.img;
        else
            img = imfilter(option.img, filters{l});
        end
        imwrite(uint8(img), ...
            sprintf('test/%s_%d.png', option.save, l));
    end
end
