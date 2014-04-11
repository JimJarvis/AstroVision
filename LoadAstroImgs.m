%% Loads images, compute features and store them
%

fd = @(subfolder) ['E:\LonelyCoder\AstroVision\' subfolder];

subfolders = {'ref', 'si850', 'w12', 'om23'};

first_save = true;

for sub = subfolders
    sub = sub{1};
    fprintf('\n============ %s =============\n', sub);
    basename = ['F_' sub];
    eval(sprintf('%s = readAstroFeatures(''%s'', 9);', basename, fd(sub)));

    if first_save
        save('AstroBase', basename);
        first_save = false;
    else
        save('AstroBase', basename, '-append');
    end
end
fprintf('\nDONE\n');
