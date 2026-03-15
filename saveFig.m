function saveFig(fig,name,path,varargin)


if ~isscalar(fig)
    error('fig must be a scalar handle');
end
if ~ischar(name)
    error('name must be a character array');
end
if ~ischar(path)
    error('path must be a character array');
end
formats = varargin;
for i = 1:length(formats)
    if ~ischar(formats{i})
        error('Each format must be a character array');
    end
end

savePath = [path filesep name];

if length(savePath) > 240
    warning("Save path is near the maximum allowed by Windows."+....
        "Some files might not be saved")
end
for iFormat = 1:length(formats)
    switch formats{iFormat}
        case 'fig'
            savefig(fig,[savePath, '.fig'])
        case 'png'
            print(fig,savePath, '-dpng','-r300')
        case 'pdf'
%             print(fig,savePath, '-dpdf');
            print(fig,savePath, '-dpdf','-bestfit');
%             print(fig,savePath, '-dpdf','auto');
        case 'svg'
            print(fig,savePath, '-dsvg');
        otherwise
            warning('Unsupported format: %s',formats{iFormat});
    end
end
end

            
        
        
    
    