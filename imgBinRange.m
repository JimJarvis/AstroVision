%% Get 1D-clustered bin ranges from the image pyramids of a few randomly chosen images in a specific folder
% returns:
% - bincell: a cell array whose components are the bin ranges of each level of the pyramid
% - gvf: Goodness of Variance Fit of each level
%
function [bincell, gvf] = imgBinRange(folder, option)

[level window sigma scale] = optionReader(option);

listing = dir(folder);

for l = 1 : numel(listing)
    file = listing(l);
    if file.isdir, continue; end


end
