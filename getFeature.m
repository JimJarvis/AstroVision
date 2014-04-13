%% Returns the multi-resolution histogram feature vector from a single image
% option struct see 'optionReader.m'
%
function feature = getFeature(img, option)

%% option setting with defaults
[level, window, sigma, scale, ~, bincell, visual] = optionReader(option);
pyramid = genGaussianPyramid(img, option);

first_level = true;

for l = 1:level
    binrange = bincell{l};
    bin = imgHistCount(pyramid{l}, binrange);
    % L1-normalization
    bin = bin / norm(bin, 1);

    if first_level %% alloc
        first_level = false;
        len = numel(bin);
        feature = zeros(level * len, 1);
    end

    if visual
        subplot(level, 1, l);
        length_cut = 1:32;
        bar(binrange(length_cut), bin(length_cut), 0.6, 'FaceColor', [0.5 0 0.6], 'EdgeColor', [0 1 0]);
    end

    feature(1 + len*(level-1):len*level) = bin;
end
