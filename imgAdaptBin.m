%% Get 1D-clustered adaptive bin ranges from the image pyramids of a few randomly chosen images in a specific dataset
% parameter: 
% - datasets: folder(s) of the images (assume to be in 'data/...' folder). Generated bins will be appended to BIN_<dataSet>.mat with the variable name bin_<dataSet>_<nBin>.mat
% - nBins: how many histogram bins per level. Can be a list of nBin, so that one dataset is clustered on each nBin to get multiple bin ranges.
% - nSample: how many samples to draw from the dataset to do the 1D clustering
% - option: as specified in genFilters. Leave it [] to use defaults.
%
% returns:
% - bincell: a cell array whose components are the bin ranges of each level of the pyramid. Each bin range will have (nBin - 1) interval endpoints, omitting -Inf at beginning and +Inf at end. 
%
function [] = imgAdaptBin(datasets, nBins, nSample, option)

filters = genFilters(option);
level = numel(filters);
if ~iscell(datasets), datasets = {datasets}; end

%% Multiple datasets
for dataset = datasets
    dataset = dataset{1};
    % Randomly choose 10 images to do the 1D clustering for each level of the pyramid. Report their GVF as well
    bincell = cell(level, 1);

    %% Multiple bin ranges
    for nBin = nBins
        for l = 1:level % l == 1 for the original unblurred image (filter will be empty)
            mergedImg = [];
            % multi-resolution
            for s = 1:nSample
                img = randImg(dataset);
                if ~isempty(filters{l})
                    img = imfilter(img, filters{l}); end
                mergedImg = [mergedImg; img(:)];
            end
            bincell{l} = lloyd1D(mergedImg, nBin);
        end

        %% Save to disk
        fileName = ['BIN_' dataset '.mat'];
        varName = ['bin_' dataset '_' num2str(nBin)];
        saveVar(fileName, varName, bincell);
        fprintf('Saved %s to %s\n\n', varName, fileName);
    end
end
