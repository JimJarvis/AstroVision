%% Returns the multi-resolution histogram feature vector from a single image
% Uses the bin width from 'ClusterBin.mat'
% option struct:
% .level: pyramid level
% .
% optional histogram visualization
%
function feature = getFeature(img, option)

binrange = linspace(0, 1, 256);

if ~exist('max_pyramid_level', 'var')
    pyramid = genGaussianPyramid(img);
else
    pyramid = genGaussianPyramid(img, max_pyramid_level);
end

if ~exist('visual', 'var')
    visual = false;
end

bin_prev = []; % for histogram difference
feature = []; % concatenated feature vector

for i = 1:numel(pyramid)
    % histogram by image intensity
    bin = histc(pyramid{i}(:), binrange)';
    % L1-norm flattening
    bin = bin / norm(bin, 1);

    if visual
        subplot(max_pyramid_level, 1, i);
        length_cut = 1:32;
        bar(binrange(length_cut), bin(length_cut), 0.6, 'FaceColor', [0.5 0 0.6], 'EdgeColor', [0 1 0]);
    end

    % Cumulative sum
    bin = cumsum(bin);
    if ~isempty(bin_prev)
        % Normalize the difference by L1 norm
        bin_diff = bin - bin_prev;
        feature = [feature; bin_diff / norm(bin_diff, 1)];
    end
    bin_prev = bin;
end
