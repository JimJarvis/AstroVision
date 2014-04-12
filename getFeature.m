%% Returns the multi-resolution histogram feature vector from a single image
% option struct see 'optionReader.m'
%
function feature = getFeature(img, option)

%% option setting with defaults
[level, window, sigma, scale, ~, bincell, visual] = optionReader(option)


for i = 1:numel(pyramid)
    % histogram by image intensity
    bin = histc(pyramid{i}(:), binrange)';
    % L1-norm flattening
    bin = bin / norm(bin, 1);

    if visual
        subplot(level, 1, i);
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
