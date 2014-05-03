%% Generate a pyramid of gaussian filters
% Parameter:
% - isNoisy: true to use larger Gaussian sigma. Omit == false
% if it's noisy, we don't histogram the original image. Start from level 2 (blurred) instead.
%
% Gaussian
% .level: pyramid level
% .window: gaussian window size
% .sigma: initial sigma
% .scale: sigma * scale^n, should always be > 1
%
function filters = genFilters(isNoisy)

isNoisy = exist('isNoisy', 'var') && isNoisy;

if isNoisy % don't count the first level (original image)
    level = 6;
    sigma = 5;
    scale = 1.43;
else % include the original raw image
    level = 7;
    sigma = 2;
    scale = 1.5;
end

filters = cell(level, 1);

% If not noisy, leave filter{1} empty because the first level is the original image
if isNoisy, l_1 = 1; else l_1 = 2; end
for l = l_1:level
    % Half-window will be 2 sigma in width
    s = sigma * scale^(l - l_1);
    filters{l} = fspecial('gaussian', ceil(4*s), s);
end
