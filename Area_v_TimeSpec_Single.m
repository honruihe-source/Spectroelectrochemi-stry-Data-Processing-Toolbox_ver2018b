clear 
close all
clc
expName = 'A vs t';
dataPath = {"E:\实验室\E3_(rough)_CV_5mVps.txt"};
nFiles = length(dataPath);
%Loop each file
for iFile = 1:length(dataPath)
    %将内部的str转化为char,即内部的""转为''
    dataPath{iFile} = char(dataPath{iFile});
    [~,fileName, ext] = fileparts(dataPath{iFile});
    file = [fileName ext];
    disp(['Reading file ' num2str(iFile) ' of ' num2str(nFiles) ': ' file '.'])
    %将内部的chr转化为str,即内部的''转为""
    dataPath{iFile} = string(dataPath{iFile});
    area{1} = readData(dataPath{iFile},2);
    area = area{1};
    fps = 1;
    totalTime = (length(area) - 1)/fps;
    time = 0:(1/fps):totalTime;
    [fig,ax] = plotXY(time,area,...
        'XLabel', '{\itt} (s)', ...
        'YLabel', 'Area', ...
        'YExponent', -6, ...
        'AspectRatio', 2.4, ...
        'Title',expName,...
        'PlotWidth', 8);
    
    datapath = dataPath{:};
    if isempty(expName)
        savePath = createAnalysisFolder(datapath{iFile});
    else
        if length(dataPath) <= 1
            savePath = createAnalysisFolder(datapath{iFile}, expName);
        else
            savePath = createAnalysisFolder(dataPath{iFile});
        end
    end
    figs = findobj('Type','figure');
    saveFig(figs, 'output', savePath, 'fig', 'png', 'pdf')
%     saveReport(savePath)
end

        
    