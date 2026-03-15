function dataTable = saveTable(varargin)
p = inputParser;
defaultSavePath = pwd;
defaultVariableNames = [];
defaultFileName = 'output.txt';
defaultDelimiter = '\t';

optionNames = {'SavePath','VariableNames','FileName','Delimiter'};
idx = find(cellfun(@ischar,varargin));
optionStart = length(varargin) + 1;
for i = 1:length(idx)
    if ismember(varargin{idx(i)},optionNames)
        optionStart = idx(i);
        break;
        %找到第一个合法参数名就停止循环，因为我们只关心 name-value 对的开始位置。
    end
end
var = varargin(1:optionStart - 1);
optionPart = varargin(optionStart:end);

addParameter(p, 'SavePath',defaultSavePath,@(x) ischar(x) || isstring(x));
addParameter(p,'VariableNames',defaultVariableNames);
addParameter(p,'FileName',defaultFileName, @(x) ischar(x) || isstring(x));
addParameter(p,'Delimiter',defaultDelimiter, @(x) ischar(x) || isstring(x));

parse(p, optionPart{:});
options = p.Results;


if strcmpi(options.SavePath, pwd)
    warning("Save path not specified. Saving at current directory")
end
outputPath = fullfile(options.SavePath, options.FileName);
if not(isempty(options.VariableNames))
    if length(options.VariableNames) ~= length(var)
        error('Number of variables must equal number of variable names.')
    else
        dataTable = table(var{:},'VariableNames',options.VariableNames);
    end
else
    dataTable = table(var{:});
end
writetable(dataTable,outputPath,'Delimiter',options.Delimiter)
end
