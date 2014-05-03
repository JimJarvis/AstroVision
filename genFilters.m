%% Generate a pyramid of gaussian filters
% Parameter:
% - isNoisy: true to use larger Gaussian sigma. Omit == false
%
% Gaussian
% .level: pyramid level
% .window: gaussian window size
% .sigma: initial sigma
% .scale: sigma * scale^n, should always be > 1
%
function filters = genFilters(isNoisy)

if exist('isNoisy', 'var') && isNoisy
    level = 7;
    sigma = 5;
    scale = 1.43;
else
    level = 7;
    sigma = 2;
    scale = 1.5;
end

filters = cell(level, 1);

% Leave filter{1} empty because the first level is the original image
for l = 2:level
    % Half-window will be 2 sigma in width
    s = sigma * scale^(l - 2);
    filters{l} = fspecial('gaussian', ceil(4*s), s);
end
