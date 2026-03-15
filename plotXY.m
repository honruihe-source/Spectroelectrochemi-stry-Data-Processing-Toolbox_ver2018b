function [fig,ax,lin] = plotXY(x,y,varargin)
p = inputParser;
addParameter(p,'FontName','Arial');
addParameter(p,'FontSize', 20);
addParameter(p, 'NumSize', 18);
addParameter(p, 'LineWidth', 2);
addParameter(p, 'LineStyle', '-');
addParameter(p, 'Color', [0.8500 0.3250 0.0980]);
addParameter(p, 'PlotWidth', []);
addParameter(p, 'AspectRatio', []);
addParameter(p, 'Visible', 'on');
addParameter(p, 'XLabel', '');
addParameter(p, 'YLabel', '');
addParameter(p, 'XLim', []);
addParameter(p, 'YLim', []);
addParameter(p, 'XTick', []);
addParameter(p, 'YTick', []);
addParameter(p,'YExponent',[]);
addParameter(p,'YScaleFactor',1);
addParameter(p,'Axes',[]);
addParameter(p,'Interpreter','tex');
addParameter(p,'LegendLabels',[]);
addParameter(p,'LegendLocaton','best');
addParameter(p,'FigureName','');
addParameter(p,'Units','inches');
addParameter(p,'Theme','light');
addParameter(p,'YAxisLocation',[]);
addParameter(p,'Marker','none');
addParameter(p,'MarkerSize',6);
addParameter(p,'MarkerEdgeColor',[0 0.4470 0.7410]);
addParameter(p,'MarkerFaceColor',[1 1 1]);
addParameter(p,'Title','');
addParameter(p,'TitleFontSize',20);
addParameter(p,'TitleFontWeight','normal');
addParameter(p,'TitleInterpreter','tex');
addParameter(p, 'TitleFontName', 'Arial');

parse(p, varargin{:});
% parse(p, 'XLabel','{\itE}(V vs. Ag/AgCl)',...
%     'YLabel','{\itA}_{592}','YLim',[],...
%     'AspectRatio',1.2,...
%     'FigureName','area_vs_pot',...
%     'PlotWidth',5);
options = p.Results;

COLOR = {
         [0.0000 0.4470 0.7410] % blue
         [0.8500 0.3250 0.0980] % orange
         [0.4660 0.6740 0.1880] % green
         [0.1000 0.1000 0.1000] % very dark grey
         [0.9290 0.6940 0.1250] % burnt yellow
         };
TEMPERATURE_COLOR = {
         [0.1000 0.1000 0.1000] % dark grey
         [0.0000 0.4470 0.7410] % blue
         [0.4660 0.6740 0.1880] % green
         [0.9290 0.6940 0.1250] % burnt yellow
         [0.8500 0.3250 0.0980] % orange
};

if (options.YScaleFactor ~= 1)
    warning(['YScaleFactor is being used (Currently ', num2str(options.YScaleFactor,'%.0e'),...
        '). Double-check output to ensure it is intentional.'])
end

if length(options.Color) < 2
    if not(ischar(options.Color))
        options.Color = COLOR{options.Color};
    end
end

if (isempty(options.Axes))
    fig = figure;
    ax = axes(fig);
    set(fig,'Units',options.Units,...
            'Name',options.FigureName,...
            'Visible',options.Visible)

    theme = options.Theme;
    if verLessThan('matlab','9.13')
        if strcmp(theme,'light')
            fig.Color = [1 1 1];
        else
            fig.Color = [0.15 0.15 0.15];
        end
    else
        fig.Theme = theme;
    end
        
    xlabel(ax,options.XLabel,...
            'FontSize',options.FontSize,...
            'FontName',options.FontName,...
            'Interpreter',options.Interpreter)
    ylabel(ax,options.YLabel,...
            'FontSize',options.FontSize,...
            'FontName',options.FontName,...
            'Interpreter',options.Interpreter)
        
    if ~isempty(options.Title)
        title(ax,options.Title,...
            'FontSize',options.TitleFontSize,...
            'FontWeight',options.TitleFontWeight,...
            'Interpreter',options.TitleInterpreter,...
            'FontName',options.FontName,...
            'FontName', options.TitleFontName);
    end
    set(ax,'LineWidth', options.LineWidth,...
            'FontName', options.FontName,...
            'FontSize', options.NumSize,...
            'Box', 'on',...
            'Layer', 'top',...
            'Units', options.Units,...
            'TickLabelInterpreter', options.Interpreter)
        
    if (isempty(options.PlotWidth)) && (isempty(options.AspectRatio))
        ax.Units = 'normalized';   
        if ~verLessThan('matlab','9.7')
            ax.PositionConstraint = 'outerposition';
        else
            ax.Position = [0.12, 0.15, 0.8, 0.8];
        end
    end
   
     if not(isempty(options.XLim))
         ax.XLim = options.XLim;
     end
     if not(isempty(options.YLim))
         ax.YLim = options.YLim;
     end
     if not(isempty(options.XTick))
         ax.XTick = options.XTick;
     end
     if not(isempty(options.YTick))
         ax.YTick = options.YTick;
     end
     if not(isempty(options.YExponent))
        ax.YAxis.Exponent = options.YExponent;
     end
     
     % need to be optimized
     if not(isempty(options.PlotWidth)) && not(isempty(options.AspectRatio))
         PlotHeight = options.PlotWidth/options.AspectRatio;
         ax.Position([3 4]) = [options.PlotWidth PlotHeight];
         fig.Position([3 4]) = ax.OuterPosition([3 4]);
         ax.OuterPosition(1) = ax.OuterPosition(1) + ax.TickLength(1);
     end

else
    ax = options.Axes;
    fig = ax.Parent;
end
hold on

if not(isempty(options.YAxisLocation))
    yyaxis(ax, options.YAxisLocation)
end

if not(iscell(y))
    lin = line(ax, x, y * options.YScaleFactor,...
               'LineStyle', options.LineStyle,...
               'LineWidth' , options.LineWidth,...
               'Color', options.Color,...
               'Marker', options.Marker,...
               'MarkerSize', options.MarkerSize,...
               'MarkerEdgeColor', options.MarkerEdgeColor,...
               'MarkerFaceColor', options.MarkerFaceColor);
else
    if not(iscell(x))
        error("x must be a cell if y is also passed as one.")
    else
        if length(y) ~= length(x)
            if isscalar(x)
               warning("Only one array for x provided. All y values" + ...
                        "will be plotted vs. it.")
               x = x{1};
            else
                error("x must have either the same number of arrays" + ...
                        "as y, or have exactly one array.")
            end
        end
    end
    
    lin = cell([length(y),1]);
    for i = 1:length(y)
        if not(iscell(options.Color))
            warning("Default color will be used since thee Color"+ ...
                    "argument wasn't passed as a cell array.")
            options.Color = COLOR;
        end
        
        if iscell(x)
            lin{i} = line(ax, x{i}, y{i} * options.YScaleFactor,...
                        'LineStyle', options.LineStyle,...
                        'LineWidth', options.LineWidth, ...
                        'Color', options.Color{i}, ...
                        'Marker', options.Marker, ...
                        'MarkerSize', options.MarkerSize, ...
                        'MarkerEdgeColor', options.MarkerEdgeColor, ...
                        'MarkerFaceColor', options.MarkerFaceColor);
        else
            lin{i} = line(ax, x, y{i} * options.YScaleFactor, ...
                        'LineStyle', options.LineStyle,...
                        'LineWidth', options.LineWidth, ...
                        'Color', options.Color{i}, ...
                        'Marker', options.Marker, ...
                        'MarkerSize', options.MarkerSize, ...
                        'MarkerEdgeColor', options.MarkerEdgeColor, ...
                        'MarkerFaceColor', options.MarkerFaceColor);
        end
    end
end
hold off

if (not(isempty(options.LegendLabels)))
    Legend(ax,options.LegendLabels,...
        'FontName', options.FontName,...
        'FontSize', options.FontSize,...
        'Interpreter', options.Interpreter,...
        'Location', options.LegendLocation)
end

if isempty(options.XLim) && isempty(options.YLim)
    axis tight
end
end

    

                        
                        
            
                    
               
    
     

    
    