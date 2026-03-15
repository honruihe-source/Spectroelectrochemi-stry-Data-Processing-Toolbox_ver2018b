function [savePath] = createAnalysisFolder(path,name)

validateattributes(path,{'char'},{'nonempty'});
if nargin < 2
    name = '';
else
    validateattributes(name,{'char'},{});
end
[folderPath, fileName, ext] = fileparts(path);

if isfolder(path)
    if isempty(name)
        %If no experimental name was given, save at the given path
        savePath = path;
    else
        if name(1) == '$'
            name = fileName+string(name(2:end));
        else
            savePath = path+string(filesep)+name+"_Analysis";
        end
    end
else
    warning('off','MATLAB:MKDIR:DirectoryExists')
    %if path no a folder
    %If no name is entered, a default name is given. 
    %If a name is given, a suffix is ??added to the file name. 
    %If there is a $ sign, the given name is added after the default name.
    if isempty(name)
        name = fileName;
    else
        if name(1) == '$'
            name = [fileName, name(2:end)];
        end
    end
%     savePath = append(folderPath,string(filesep),name,"_Analysis");
    savePath = [folderPath,filesep,name, '_Analysis'];
end

if ~exist(savePath,'file')
    mkdir(savePath);
else
    winTitle = "Directory already exists";
    winDesc = "Directory "+savePath+" already exists."+...
                "Input a new experiment name or leave same to overwrite."+...
                "Alternatively, select Cancel to abort.";
    sel = inputdlg(winDesc, winTitle, 1, {name});       
    
    if ~isempty(sel)
        % If user clicked 'Ok'
        if isempty(sel{1})
            %if provided input is blank
            error('No input provided.')
        elseif isequal(sel{1},name)
            % If the input is equal to expName, overwrite
            disp('Overwriting...')
            mkdir(savePath)
        else
            disp('Creating new folder...')
            name = sel{1};
            savePath = [folderPath,filesep,name,'_Analysis'];
            mkdir(savePath)
        end
    else
        % If user clicks 'Cancel' or closes the dialog box
        error('Aborted by user.')
    end
end
end

            
        


