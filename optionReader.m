%% Customized option reader for AstroVision
% Option struct specification [default]:
% .level: pyramid level [6]
% .window: gaussian window size [7]
% .sigma: initial sigma [1]
% .scale: sigma * scale^n, should always be > 1 [2]
%
function [level window sigma scale] = optionReader(option)

if isfield(option, 'level'), level = option.level; else level = 6; end
if isfield(option, 'window'), window = option.window; else window = 7; end
if isfield(option, 'sigma'), sigma = option.sigma; else sigma = 1; end
if isfield(option, 'scale'), scale = option.scale; else scale = 2; end
