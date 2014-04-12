%% Jenks Natural Break Algorithm 1D clustering
% parameters:
% - arr: 1D array of data
% - nBin: n classes (bins) to be clustered
% returns: 
% - binrange: endpoints of each bin. Note: cannot be used directly in 'histc' because the end points are off by one (histc excludes the endpoint while we include it).  
% - gvf: Goodness of Variance Fit, taking the difference between the squared deviations from the srray mean (SDAM) and the squared deviations from the class means (SDCM), divided by SDAM. Note that the more classes the better gvf. 
%
function [binrange gvf] = jenksBreak(arr, nBin)

arr = sort(arr); % array assumed to be 1D
nArr = numel(arr);

mat1 = zeros(nArr + 1, nBin + 1);
mat2 = zeros(nArr + 1, nBin + 1);

mat1(2, 2:end) = 1;
mat2(3:end, 2:end) = Inf;

v = 0;
for l = 3 : nArr+1
    s1 = 0;
    s2 = 0;
    w = 0;
    for m = 1 : l-1
        i3 = l - m;
        val = arr(i3);
        s2 = s2 + val * val;
        s1 = s1 + val;
        w = w + 1;
        v = s2 - s1 * s1 / w;
        i4 = i3 - 1;
        if i4 ~= 0
            for j = 3 : nBin+1
                tmp = v + mat2(i4+1, j-1);
                if mat2(l, j) >= tmp
                    mat1(l, j) = i3;
                    mat2(l, j) = tmp;
                end
            end
        end
    end
    mat1(l, 2) = 1;
    mat2(l, 2) = v;
end

binrange = zeros(1, nBin+1);
% index of the bin endpoints in the sorted array
idx = zeros(1, nBin+1); 
binrange(nBin + 1) = arr(end);
idx(nBin + 1) = nArr;
nCount = nBin + 1;
k = nArr;
while nCount >= 3
    id = floor(mat1(k+1, nCount) - 2);
    binrange(nCount - 1) = arr(id + 1);
    idx(nCount - 1) = id + 1;
    k = floor(mat1(k+1, nCount) - 1);
    nCount = nCount - 1;
end

%% Calculate Goodness of Variance Fit (GVF)
% helper func
sumsq = @(arr) sum((arr - mean(arr)).^2);
SDAM = sumsq(arr);
SDCM = 0;
for i = 1:nBin
    subArr = arr(idx(i)+1:idx(i+1));
    SDCM = SDCM + sumsq(subArr);
end
gvf = (SDAM - SDCM) / SDAM;
