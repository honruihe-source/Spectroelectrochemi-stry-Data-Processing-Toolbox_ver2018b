function pList = saveReport(savePath,varargin)
callstack = dbstack('-completenames');
mainScript = callstack(end).file;

[~, mainName, ext] = fileparts(mainScript);
copyPath = fullfile(savePath, [mainName ext]);

%copyPath = append(savePath,filesep,mainScript);
% copyPath = fullfile(savePath,mainScript);

copyfile(mainScript,copyPath)
[fList,pList] = matlab.codetools.requiredFilesAndProducts(mainScript);

apps = struct2table(pList);

dependencies = fList';

% reportPath = append(savePath.filesep,'report.txt');
reportPath = fullfile(savePath,'report.txt');

fid = fopen(reportPath,'w');
fprintf(fid,'\\ANALYSIS REPORT\n');
fprintf(fid,'User:%s\n',getenv('username'));
fprintf(fid,'OS:%s\n',getenv('os'));
fprintf(fid,'Date:%s\n\n',datestr(datetime));

fprintf(fid,'\\Apps used\n');
fclose(fid);

tmpPath = fullfile(savePath,'apps_tmp.txt');
writetable(apps,tmpPath,'Delimiter','\t', 'WriteVariableNames', true, 'FileType','text');

fidReport = fopen(reportPath, 'a');
fidTmp = fopen(tmpPath, 'r');
tline = fgetl(fidTmp);
while ischar(tline)
    fprintf(fidReport, '%s\n', tline);
    tline = fgetl(fidTmp);
end
fclose(fidTmp);
fclose(fidReport);
delete(tmpPath); 

fid = fopen(reportPath,'a');
fprintf(fid,'\n\\ Scripts/routines used\n');
for i = 1:length(dependencies)
    fprintf(fid,'%s\n',dependencies{i});
end
fclose(fid);

fid = fopen(copyPath,'a');
fprintf(fid,'\n%% Subroutines\n');
fclose(fid);

for i = length(dependencies):-1:2
    subLines = importdata(dependencies{i});
    fid = fopen(copyPath,'a');
    if iscell(subLines)
        for j = 1:length(subLines)
            fprintf(fid,'%s\n',subLines{j});
        end
    elseif isstring(subLines) || ischar(subLines)
        fprintf(fid,'%s\n',subLines);
    elseif isstruct(subLines) && isfield(subLines,'textdata')
        for j = 1:length(subLines.textdata)
            fprintf(fid,'%s\n',subLines.textdata{j});
        end
    else
        warning('Unsupported format for file: %s',dependencies(i));
    end
    fprintf(fid,'\n');
    fclose(fid);
end

disp(['Saved report at:',savePath]);
end




