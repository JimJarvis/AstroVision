%% Returns the multi-resolution histogram feature vector from a single image
% option struct see 'genFilters.m'
% visual: true to display a side-by-side histogram plot
%
function feature = getFeature(img, option, visual)

%% option setting with defaults
filters = genFilters(option);
bincell = option.bincell; % must have this field
level = numel(filters);

for l = 1:level

    % Bincell only specifies one level: we use it for all levels
    if ~iscell(bincell)
        binrange = bincell;
    else
        binrange = bincell{l};
    end

    if isempty(filters{l})
        imf = img; % no filtering
    else
        imf = imfilter(img, filters{l});
    end
    bin = imgHistCount(imf, binrange);
    % L1-normalization
    bin = bin / norm(bin, 1);

    if l == 1 %% alloc
        len = numel(bin);
        feature = zeros(level * len, 1);
    end

    feature(1 + len*(l-1):len*l) = bin;

    if exist('visual', 'var')
        subplot(level, 1, l);
        length_cut = 1:32;
        % bar(binrange(length_cut), bin(length_cut), 0.6, 'FaceColor', [0.5 0 0.6], 'EdgeColor', [0 1 0]);
        bar([0;binrange], bin, 1, 'FaceColor', [0.5 0 0.6], 'EdgeColor', [0 1 0]);
    end
end
