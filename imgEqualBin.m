%% Determines the equally spaced bins by the min/max (unscaled) values from 
% a few different data sets
% Store the generated bin range to BIN_equal.mat
% Parameters:
% - dataset(s)
% - nBin(s)
% - isNoisy
% Returns: [min, max]
%
function [mn, mx] = imgEqualBin(datasets, nBins, isNoisy)

isNoisy = exist('isNoisy', 'var') && isNoisy;

mn = Inf;
mx = -Inf;

for dataset = datasets
    dataset = dataset{1};
    folder = ['data/' dataset];

    files = getFilesFolder(folder);

    % Randomly select a few images to get min/max
    for i = 1:100
        img = fitsread([folder '/' files{randi(numel(files))}]);
        if isNoisy
            img = addNoise(img); 
        end
        img = img(:);
        mx_ = max(img);
        mn_ = min(img);
        if mx_ > mx, mx = mx_; end
        if mn_ < mn, mn = mn_; end
    end
end

for nBin = nBins
    bincell = linspace(mn, mx, nBin+1)';
    bincell = bincell(2:end-1);
    if isNoisy, fileName = 'BIN_noisy_equal';
    else fileName = 'BIN_equal'; end
    varName = ['bin_' num2str(nBin)];
    saveVar(fileName, varName, bincell);
    fprintf('Saved %s to %s\n\n', varName, fileName);
end
