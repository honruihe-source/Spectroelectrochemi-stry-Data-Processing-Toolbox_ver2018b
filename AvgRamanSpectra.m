clear
close all
clc
expName = 'Avg test';
dataPath = {"E:\实验室\2025-02-14 15_40_49 E3 (rough) CV 5mVps 10FPS.csv"};
bkgPath = {"E:\实验室\2025-02-14 13_34_09 DC.csv"};
laserWavelength = 636.551;
nFiles = length(dataPath);
if not(isempty(bkgPath{1}))
    [~,bkgIntensity] = readSpectra(bkgPath);
    avgBkgIntensity = avgSpectra(bkgIntensity);
end

wavelength = cell([nFiles 1]);
intensity = cell([nFiles 1]);
ramanShift = cell([nFiles 1]);
corrIntensity = cell([nFiles 1]);
avgIntensity = cell([nFiles 1]);

for i = 1:nFiles
    [wavelength{i}, intensity{i}] = readSpectra(dataPath{i});
    ramanShift{i} = wavelengthToRS(wavelength{i}, laserWavelength);
    corrIntensity{i} = intensity{i} - avgBkgIntensity;
    avgIntensity{i} = avgSpectra(corrIntensity{i});
end

sumSpectrum = zeros([length(avgIntensity{i}) 1]);
totalFrames = 0;

for i = 1:nFiles
    sumSpectrum = sumSpectrum + avgIntensity{i};
end

avgSpectrum = sumSpectrum / nFiles;

x = ramanShift{1};
y = avgSpectrum;

[fig ax] = plotXY(x, y, ...
    'Xlabel','Raman shift (cm^{-1})', ...
    'Ylabel','Intensity (counts)', ...
    'XLim',[min(x) max(x)], ...
    'YLim',[], ...
    'FigureName', 'spectrum', ...
    'AspectRatio', 2.4, ...
    'PlotWidth', 8);
datapath = dataPath{:};
savePath = createAnalysisFolder(datapath{1}, expName);
saveALLFigs(savePath, 'fig', 'pdf', 'png');
saveTable(x, y, 'SavePath',savePath,...
     'VariableNames', {'RS_cm_1', 'Intensity'}, ...
     'FileName', 'avgSpectrum.txt');
 
    
