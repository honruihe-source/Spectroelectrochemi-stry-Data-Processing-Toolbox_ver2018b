function [wavelength,intensity] = readSpectra(path,varargin)
p = inputParser;
validatePath = @(x) ischar(x) || isstring(x) || iscell(x);
addRequired(p,'path',validatePath);
addParameter(p,'FrameRange',[NaN;NaN],@(x) isnumeric(x) && isequal(size(x),[2,1]));
addParameter(p,'XWidth',[]);
addParameter(p,'FrameColumn',3,@(x) isnumeric(x) && isscalar(x));
addParameter(p,'XWidthColumn',6,@(x) isnumeric(x) && isscalar(x));
parse(p, path, varargin{:});
options = p.Results;
if iscell(path)
    if isscalar(path)
        path = path{1};
    end
end
[wavelength,intensity,frame,xpixel] = readData(path,[1,2,options.FrameColumn,options.XWidthColumn]);

if (isempty(options.XWidth))
    XWidth = xpixel(end) + 1;
else
    XWidth = options.XWidth;
end

wavelength = wavelength(1:XWidth);
Frames = frame(end);
intensity = reshape(intensity,[XWidth Frames]);
if not(isempty(options.FrameRange)) && not(any(isnan(options.FrameRange)))
    intensity = intensity(:, options.FrameRange);
end
end

