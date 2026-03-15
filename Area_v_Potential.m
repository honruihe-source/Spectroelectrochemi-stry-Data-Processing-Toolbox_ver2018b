clear 
close all
expName = 'Area vs E slop overlay';
dataPath = {"E:\ µ—È “\E3_(rough)_CV_5mVps.txt"};
datapath = dataPath{:};
nFiles = length(dataPath);
potential = cell([nFiles 1]);
area = cell([nFiles 1]);

for i = 1:nFiles
    [potential{i},area{i}] = readData( dataPath{i},[1,2]);
end

[fig, ax] = plotXY(potential{1},area{1},'XLabel','{\itE}(V vs. Ag/AgCl)',...
    'YLabel','{\itA}_{592}','YLim',[],...
    'AspectRatio',1.2,...
    'FigureName','area_vs_pot',...
    'PlotWidth',6);

min(area{1})
max(area{1})
if nFiles > 1
    for j = 2:nFiles
        plotXY(potential{j}, area{j}, ...
                'Color', j, ...
                'Axes', ax);
    end
end

Eonset = -0.19;
Ehalf = -0.34;

ERange = {[-0.33 -0.19];[-0.35 -0.22]; [-0.31 -0.19]};

for i = 1:nFiles
    [~, EonsetIdx] = min(abs(potential{i} - Eonset));%Find the potential position corresponding to Eonset 
    [~, EhalfIdx] = min(abs(potential{i} - Ehalf));
    [~, E1Idx] = min(abs(potential{i} - ERange{i}(2)));
    [~, E2Idx] = min(abs(potential{i} - ERange{i}(1)));
    
    f = @(x,E) x(1) * E + x(2);
    
    potentialRange{i} = potential{i}(E1Idx:E2Idx);%Range of -0.33 to -0.19
    areaRange{i} = area{i}(E1Idx:E2Idx);
    
    [x, resnorm, ~, exitfilag, output] = lsqcurvefit(f,[1 1],potentialRange{1},areaRange{i});
    
    m{i} = x(1);
    b{i} = x(2);
    
    extendedERange{i} = stretch(potentialRange{i},5);
   
    plotXY(extendedERange{i},f(x, extendedERange{i}),'Color', i,'LineStyle', '--','Axes', ax);
    ax.YLim = [min(area{1}) max(area{1})];
    if i == 1
        [fig2, ax2] = plotXY(extendedERange{i}, f(x, extendedERange{i}), ...
            'XLabel', '{\itE} (V vs. Ag/AgCl)', ...
            'YLabel', 'Fit {\itA}_{592}', ...
            'AspectRatio', 1.2, ...
            'FigureName', 'linear_fit', ...
            'PlotWidth', 5);
    else
        disp(i)
        plotXY(extendedERange{i}, f(x, extendedERange{i}), ...
            'Color', i, ...
            'Axes', ax2);
    end
end

%{
legend(ax, ...
    {'25 °„C'; '30 °„C'; '35 °„C'}, ...
    'Location', 'best')
legend(ax2, ...
    {'25 °„C'; '30 °„C'; '35 °„C'}, ...
    'Location', 'best')
%}

savePath = createAnalysisFolder(datapath{:}, expName);
saveALLFigs(savePath, 'png')
saveReport(savePath)
% copyFile(savePath, dataPath)
        
        
