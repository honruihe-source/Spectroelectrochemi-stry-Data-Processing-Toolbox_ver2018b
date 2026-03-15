clear
close all
clc
expName = 'NumMols BarPlot all conditions STACKD (thinner)';
dataPath = {"E:\ µ—È “"};
datapath = dataPath{:};
x_labels = {'25', '27', '30', '32', '35'};
x = ["25" "27" "30" "32" "35"];


CO_NI = [0.196 0.454 0.678 0.666 0.736]; 
CO_STD_NI = [0.085615 0.191651 0.337224 0.26025 0.24684]; 

H2_NI = [0.25 0.68 0.206 0.232 0.296];
H2_STD_NI = [0.130576 0.0690665 0.075033 0.093381 0.130307];

CO_I = [0.108 0.1866 0.19 0.146 0.148]; 
CO_STD_I = [0.027749 0.072061 0.056125 0.04827 0.078867]; 

H2_I = [0.33 0.214 0.23 0.318 0.354];
H2_STD_I = [0.127279 0.136858 0.072801 0.12276 0.118448];

fig = figure('Units', 'inches','Color', 'w'); 
ax = axes('Parent', fig, 'Units', 'inches');

hold on
colorsA = {
    [0.0000 0.4470 0.7410]; % blue
    [0.4 0.4 0.4];          % grey
};
colorsB = {
    [0.9000 0.3250 0.0980]; % orange-red
    [0.7 0.7 0.7];          % light grey
};
yA = [CO_I; H2_I]';
yB = [CO_NI; H2_NI]';

stdA = [CO_STD_I; H2_STD_I]';
stdB = [CO_STD_NI; H2_STD_NI]';
nGroups = length(yA);
barWidth = 0.3;
groupSeparation = 0.05;

x_base = 1:nGroups;
xA = x_base - barWidth/2 - groupSeparation;
xB = x_base + barWidth/2 + groupSeparation;


hA = bar(ax, xA, yA, barWidth, 'stacked');
hB = bar(ax, xB, yB, barWidth, 'stacked');

hA(1).FaceColor = colorsA{1}; hA(2).FaceColor = colorsA{2};
hB(1).FaceColor = colorsB{1}; hB(2).FaceColor = colorsB{2};


for i = 1:nGroups
    yA_cum = cumsum([0, yA(i, 1:end-1)]);
    yA_end = yA_cum + yA(i, :);
    
    yB_cum = cumsum([0, yB(i, 1:end-1)]);
    yB_end = yB_cum + yB(i, :);
    
    x_errA = [xA(i), xA(i)];
    x_errB = [xB(i), xB(i)];
    
    errorbar(ax, x_errA, yA_end, stdA(i,:), ...
        'LineStyle', 'none', 'LineWidth', 1.5, 'Color', [0.1 0.1 0.1]);
    errorbar(ax, x_errB, yB_end, stdB(i,:), ...
        'LineStyle', 'none', 'LineWidth', 1.5, 'Color', [0.1 0.1 0.1]);
end

bars = findall(ax, 'Type', 'bar');
set(bars, 'LineWidth' ,1.5);

set(hA, 'LineWidth', 1.5);
set(hB, 'LineWidth', 1.5);

PlotWidth = 5;
AspectRatio = 1.2;

ax.YLim = [0 1.5];
ax.XLim = [0 nGroups + 1];
ax.XTickLabels = ['' x ''];
ax.LineWidth = 1.5;
ax.FontName = 'Arial';
ax.FontSize = 16;

xlabel('{\itT} (°„C)', 'Interpreter','tex', 'FontSize',18, 'FontName','Arial')
ylabel('{\itn} (¶Ãmol)', 'Interpreter','tex', 'FontSize',18, 'FontName','Arial')
box on

PlotHeight = PlotWidth/AspectRatio;
ax.Position([3 4]) = [PlotWidth PlotHeight];
fig.Position([3 4]) = ax.OuterPosition([3 4]);
ax.OuterPosition(1) = ax.OuterPosition(1) + ax.TickLength(1);
legend(ax, ...
    {'CO', 'H_2', 'CO', 'H_2'}, ...
    'Location', 'northwest')

savePath = createAnalysisFolder(datapath{1}, expName);
saveALLFigs(savePath, 'png')
