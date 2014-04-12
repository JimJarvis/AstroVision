%% Customized option reader for AstroVision
% Option struct specification [default]:
% .level: pyramid level [6]
% .window: gaussian window size [7]
% .sigma: initial sigma [1]
% .scale: sigma * scale^n, should always be > 1 [2]
% .nbin: n bins for each level's histogram. If a single number, we use the same nbin for all levels
% .bincell: a bin for each level of the pyramid (cell array)
%
function [level window sigma scale nbin bincell visual] ...
        = optionReader(option)

if isfield(option, 'level'), level = option.level; else level = 6; end
if isfield(option, 'window'), window = option.window; else window = 7; end
if isfield(option, 'sigma'), sigma = option.sigma; else sigma = 1; end
if isfield(option, 'scale'), scale = option.scale; else scale = 2; end
if isfield(option, 'nbin')
    nbin = option.nbin; 
    if numel(nbin) == 1
        nbin = nbin * ones(level);
    end
else
    nbin = []; 
end
if isfield(option, 'bincell'), bincell = option.bincell; else bincell = {}; end
if isfield(option, 'visual'), visual = option.visual; else visual = false; end
