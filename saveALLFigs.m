function saveALLFigs(varargin)
%saveAllFigs: Saves all open figures provided they have names.
if nargin < 1
    error('path argument is required.');
end
% path = varargin{1};
path = char(varargin{1}); 
formats = varargin(2:end);


figs = findobj('Type','figure');

numFigs = length(figs);

for iFig = 1:numFigs
    fig = figs(iFig);
    if not(isempty(fig.Name))
        name = fig.Name;
    else
        name = ['figure_' num2str(iFig)];
    end
    saveFig(fig,name,path,formats{:})
end
end


