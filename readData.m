function varargout = readData(datapath, columns)

if nargin < 1
    datapath = {string(pwd)};
    datapath = datapath{:};
end
    
if length(columns) ~= nargout
    error('The number of columns must match the number of outputs.')
end

if isfile(datapath)
    [path, file, ext] = fileparts(datapath);
    file = file + ext;
else
    if isfolder(datapath)
        [file, path] = uigetfile({'*.*'}, 'Select files to analyze',datapath,'MultiSelect', 'on');
        file = string(file);
    else
        warning("Path not found. Prompting user for files in the current working folder.")
        [file, path] = uigetfile({'*.*'},'Select files to analyze.',pwd, 'MultiSelect', 'on');
        file = string(file);
    end
end

if ~iscell(file)
    if isempty(file) || str2double(file) == 0
        error('No file selected.')
    end
    else
        file = {file};
end

nFiles = length(file);
data = cell([1 nFiles]);
filePath = cell([1 nFiles]);
for ifile = 1:length(file)
    filePath{ifile} = strcat(path, filesep, file{ifile});
    disp(['Opening ' file{ifile} '...'])
    data{ifile} = table2array(readtable(filePath{ifile}));
end
varargout = num2cell(zeros(1, nargout));
for n = 1:length(varargout)
    varargout{n} = {};
    if length(filePath) > 1
        for ifile = 1:length(filePath)
            varargout{n}{ifile} = data{ifile}(:, columns(n));
        end
    else
        varargout{n} = data{ifile}(:, columns(n));
    end
end
end