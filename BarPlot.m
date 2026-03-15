clear 
close all
clc
expName = 'NumMol BarPlot isthermal up to 80% blue';
dataPath = {"E:\ µ—È “"};
datapath = dataPath{:};
x_labels = {'25', '27', '30', '32', '35'};

CO_NI = [28 46.394 58.358 54.31 55.14];
CO_STD_NI = [9.40957 6.227735 10.14016 4.216989 5.93688];

H2_NI = [28.62 19.338 20 19.836 21.984];
H2_STD_NI = [9.907169 8.642912 8.406497 6.257326 4.596486];

CO_I = [14.992 20.372 20.632 17.8 21.972]; 
CO_STD_I = [5.387551 9.13645 8.555979 8.258583 13.3592];

H2_I = [30.646	29.174	29.394	34.554	38.282];
H2_STD_I = [6.524188072	8.52568355 5.326854607	8.079036452	6.774195155];

y1 = CO_I;
y2 = H2_I;
stdy1 = CO_STD_I;
stdy2 = H2_STD_I;

data = [y1; y2]';
std_data = [stdy1; stdy2]';

fig = figure('Units', 'inches','Color', 'w'); 
ax = axes('Parent', fig, 'Units', 'inches');

hold on

b1 = bar(ax,data, 'grouped');
[ngroups, nbars] = size(data);

groupwidth = min(0.8, nbars/(nbars + 1.5));
x = zeros(nbars, ngroups);

for i = 1:nbars
    x(i,:) = (1:ngroups) - groupwidth/2 + (2*i - 1) * groupwidth / (2*nbars);
end

for i = 1:nbars
    errorbar(x(i,:),data(:,i)',std_data(:,i)','k','linestyle','none','linewidth',1.2);
end

set(ax, 'XTick', 1:ngroups, 'XTickLabel', x_labels);
ylabel('Current Density (mA/cm^2)');
legend({'CO', 'H_2'}, 'Location','northwest');
box on;

colorsA = {[0.0000 0.4470 0.7410];[0.4 0.4 0.4];};
colorsB = {[0.9000 0.3250 0.0980];[0.7 0.7 0.7];};

b1(1).FaceColor = colorsA{1};
b1(2).FaceColor = colorsA{2};

b1(1).LineWidth = 1.5;
b1(2).LineWidth = 1.5;
b1(1).BarWidth = 0.8;
b1(2).BarWidth = 0.8;

PlotWidth = 5;
AspectRatio = 1.2;

ax.YLim = [0 80];
ax.LineWidth = 1.5;
ax.FontName = 'Arial';
ax.FontSize = 16;

xlabel('\it{T}(°„C)','Interpreter','tex','FontSize',18,'FontName','Arial')
ylabel('FE(%)','Interpreter','tex','FontSize',18,'FontName','Arial')

PlotHeight = PlotWidth/AspectRatio;
ax.Position([3 4]) = [PlotWidth PlotHeight];
fig.Position([3 4]) = ax.OuterPosition([3 4]);
ax.OuterPosition(1) = ax.OuterPosition(1) + ax.TickLength(1);

savePath = createAnalysisFolder(datapath{1}, expName);

saveALLFigs(savePath, 'fig')


