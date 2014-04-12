%% Jenks Natural Break algorithm [1D clustering]
% parameters:
% - arr: 1D array of data
% - nBin: n classes (bins) to be clustered
% returns: 
% - binrange: can be used directly in "hist". Left inclusive and right exclusive
% - gvf: Goodness of Variance Fit, taking the difference between the squared deviations from the srray mean (SDAM) and the squared deviations from the class means (SDCM), divided by SDAM. Note that the more classes the better gvf. 
%
function [binrange gvf] = jenksBinRange(arr, nBin)

nArr = numel(arr);
arr = sort(arr);
mat1 = zeros(nArr + 1, );
