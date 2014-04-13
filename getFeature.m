%% Returns the multi-resolution histogram feature vector from a single image
% option struct see 'optionReader.m'
%
function feature = getFeature(img, option)

%% option setting with defaults
[level, window, sigma, scale, ~, bincell, visual] = optionReader(option);
pyramid = genGaussianPyramid(img, option);

feature = [];

for l = 1:level
    binrange = bincell{l};
    bin = imgHistCount(pyramid{l}, binrange);
    % L1-norm flattening
    bin = bin / norm(bin, 1);

    if visual
        subplot(level, 1, l);
        length_cut = 1:32;
        bar(binrange(length_cut), bin(length_cut), 0.6, 'FaceColor', [0.5 0 0.6], 'EdgeColor', [0 1 0]);
    end

    feature = [feature; bin];
end
