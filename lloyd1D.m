%% 1D clustering algorithm based on Lloyd algorithm
% Returns:
% - binrange: endpoints of each bin. Note: cannot be used directly in 'histc' because the end points are off by one (histc excludes the endpoint while we include it)
% Note that 'q' are only bin centers. The first bin is [-infinity, mean(q(1:2))], the second bin is [mean(q(1:2)),mean(q(2:3))], and so on, until the last bin, which is [mean(q(1023:1024)),+infinity]
%
function binrange = lloyd1D(x, k)

x = sort(x);

n = length(x);
s = inf(n,1);
q = zeros(k,1);
% rng(0);
q(1) = x(randi(n));
next_report = 2;
for j = 2:k
  if j == next_report
    fprintf(2, 'picking center %d\n', j);
    next_report = 2*next_report;
  end
  d = x-q(j-1);
  s = min(s,d.*d);
  w = s/sum(s);
  q(j) = x(randsample(n,1,true,w));
end
fprintf(2, 'Running lloyd iteration 1\n');
q = lloyd(x,q);
fprintf(2, 'Running lloyd iteration 2\n');
q = lloyd(x,q);
q = sort(q,'ascend');

binrange = zeros(k - 1, 1);
for i = 1 : k-1
    binrange(i) = mean(q(i:i+1));
end

end


%% Helper
function q = lloyd(x,q)

n = length(x);
k = length(q);
s = inf(n,1);
b = nan(n,1);
next_report = 2;
for i=1:k
  if i == next_report
    % fprintf(2, 'distance to center %d\n', i);
    next_report = 2*next_report;
  end
  [s,a] = min([abs(x-q(i)),s],[],2);
  b(a==1) = i;
end
next_report = 2;
for i=1:k
  if i == next_report
    fprintf(2, 'updating center %d\n', i);
    next_report = 2*next_report;
  end
  q(i) = mean(x(b==i));
end
q = sort(q,'ascend');

end
