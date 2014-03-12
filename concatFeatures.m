%% feature is a 3D matrix with:
% Dim1 as difference vector between histograms at 2 adjacent levels in the Guassian pyramid
% Dim2 is currently 256, the number of bins
% Dim3 - number of samples 
% pyramid_level = 2 => return 1 difference
%
% rows of f_concat are samples
% cols of f_concat are concatenated histogram features
%
function f_concat = concatFeatures(features, pyramid_level)

SAMPLE_N = size(features, 3);
BIN_N = size(features, 2);
f_concat = zeros(SAMPLE_N, (pyramid_level-1)*BIN_N);

% i = number of samples
for i = 1:SAMPLE_N
    f = features(1:pyramid_level-1, :, i)';
    f_concat(i, :) = f(:);
end
