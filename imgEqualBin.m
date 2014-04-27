%% Determines the equally spaced bins by the min/max (unscaled) values from 
% a few different data sets
% Store the generated bin range to BIN_equal.mat
% Return the min/max
%
function [mx, mn] = imgEqualBin(datasets, nBins)

mx = -Inf;
mn = Inf;

for dataset = datasets
    dataset = dataset{1};
    folder = ['data/' dataset];

    files = getFilesFolder(folder);

    % Randomly select a few images to get min/max
    for i = 1:100
        img = fitsread([folder '/' files{randi(numel(files))}]);
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
    fileName = 'BIN_equal';
    varName = ['bin_' num2str(nBin)];
    saveVar(fileName, varName, bincell);
    fprintf('Saved %s to %s\n\n', varName, fileName);
end
