%% Test if a cell array of strings contains a particular string
%
function has = containsStr(strcell, target)

for str = strcell
    if strcmp(target, str{1})
        has = true;
        return;
    end
end
has = false;
