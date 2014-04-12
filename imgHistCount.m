%% Customized version of histogram counting
% binrange: obtained by cluster1D()
%
function counts = imgHistCount(img, binrange)

counts = histc(img(:), binrange);
counts = counts(1:end-1);
counts(1) = counts(1) + 1;
