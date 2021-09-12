
function imaging(runVer)%, isFTP)
% change back:
% open two imaging (online and offline) 
% delete imaging pics
% remove loop condition (and at the end) - OK
% IDS_Main.dir in creaeConsts.m - OK
% in run change file path '/' to '\' (also in createconsts/idsReadFunction,
%  '/' to '\': analyzeAndPlot

if nargin == 0
    imaging('offline');
    imaging('online');%, 'noFTP');
    return
end
% if nargin == 1 
%     if (strcmp(runVer, 'FTP') || strcmp(runVer, 'FTP') )
%         imaging('offline', runVer);
%         imaging('online', runVer);
%     else
%         imaging(runVer, 'FTP');
%     end
%     return
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defining consts
%
appData.consts.vertion = '4.6.6';
appData.consts. saveVersion = '-v7';
appData.consts.runVer = runVer;

appData.consts.Mrb = 1.44e-25; 
appData.consts.Kb = 1.38e-23; 
% appData.consts.detun = 1e6;%          %  off resonance detuning
appData.consts.wavelength = 780e-9;                      %  [m]
appData.consts.linew = 6.065e6;%     %  [Hz]   
                                                    % line width of the Rb87 cooling transition: Lambda = 2*pi*linew
appData.consts.scatcross0 = 3*appData.consts.wavelength^2/2/pi;   % scattering cross section for Rb87 in m^2
% appData.consts.scatcross = appData.consts.scatcross0;      %  resonant imaging 
% appData.consts.defaultDetuning = 0;
% consts.scatcross = scatcross0 * 1/(1+(detun*2/linew)^2);   % off resonance scattering cross section


appData.consts.winName = 'Imaging Analysis: Picture ';% num2str(handles.data.num)];
appData.consts.screenWidth = 1280;
appData.consts.screenHeight = 780;
appData.consts.strHeight = 20;
appData.consts.maxplotSize = round(appData.consts.screenHeight*0.75);
appData.consts.xyPlotsHeight = round(appData.consts.screenHeight-(5+appData.consts.maxplotSize+appData.consts.strHeight*2.5));
appData.consts.fontSize = 9;
appData.consts.componentHeight = 22;
appData.consts.folderIcon = imread('folder28.bmp');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create consts
appData = createConsts(appData);

% if strcmp(isFTP, 'FTP')
%     appData.consts.LVFile = appData.consts.defaultLVFile;
% else
%     appData.consts.LVFile = 'tempLVData.txt';
% %     appData.data.LVData = LVData.readLabview('tempLVData.txt');
% end
appData.data.LVData = [];
appData.data.lastLVData = [];
% appData.data.isLastLVData = 0;
appData.data.firstLVData = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defining data
%

appData.data.isRun = 0;
% appData.data.scatcross = appData.consts.scatcross0 * 1/(1+(detun*2/linew)^2);   % off resonance scattering cross section

% appData.data.atoms = [];
% appData.data.back = [];
appData.data.dark = [];
% appData.data.absorption = [];
% appData.data.ROI = [];
% appData.data.pic = [];
% appData.data.atomsNo = 0;
appData.data.date = datestr(now);
appData.data.fitType = appData.consts.fitTypes.default;
appData.data.fits = appData.consts.fitTypes.fits;
appData.data.plotType = appData.consts.plotTypes.default;
appData.data.plots = appData.consts.plotTypes.plots;
% appData.data.picNo = -1;
% appData.data.saveParam = -1;
% appData.data.saveParamVal = -1;

appData.data.ROIUnits = appData.consts.ROIUnits.default;
appData.data.ROITypes = appData.consts.ROIUnits.ROITypes;
appData.data.ROISizeX = appData.consts.ROIUnits.defaultSizeX;
appData.data.ROISizeY = appData.consts.ROIUnits.defaultSizeY;
appData.data.ROICenterX = 0;
appData.data.ROICenterY = 0;
% appData.data.ROILeft = -1;
% appData.data.ROIRight = -1;
% appData.data.ROITop = -1;
% appData.data.ROIBottom = -1;

appData.data.xPosMaxBack = 0;
appData.data.yPosMaxBack = 0;
% appData.data.xPosMax = 0;
% appData.data.yPosMax = 0;

% appData.data.cameraType = appData.consts.cameraTypes.default;
appData.data.camera = appData.consts.cameras{appData.consts.cameraTypes.default};%{appData.data.cameraType};
appData.data.plotWidth = round(appData.consts.maxplotSize*(appData.data.camera.width / appData.data.camera.height));
appData.data.plotHeight = appData.consts.maxplotSize;
if ( appData.data.plotWidth > appData.consts.maxplotSize )
    appData.data.plotWidth = appData.consts.maxplotSize;
    appData.data.plotHeight = round(appData.consts.maxplotSize*( appData.data.camera.height / appData.data.camera.width));
end

appData.options.calcAtomsNo = appData.consts.calcAtomsNo.default;
appData.options.calcs = appData.consts.calcAtomsNo.calcs;
appData.options.plotSetting = appData.consts.plotSetting.default;
appData.options.cameraType = appData.consts.cameraTypes.default;
appData.options.avgWidth = appData.consts.defaultAvgWidth;
appData.options.detuning = appData.consts.defaultDetuning;
appData.options.doPlot = appData.consts.defaultDoPlot;


% appData.save.defaultDir = ['F:\My Documents\Experimental\' datestr(now,29)];%'C:\Documents and Settings\broot\Desktop\shimi';
% mkdir(appData.save.defaultDir); %#ok<NASGU>
appData.save.saveDir=appData.save.defaultDir;
appData.save.saveParam = appData.consts.saveParams.default;
appData.save.saveParamVal = appData.consts.saveParamValDefault;
appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
appData.save.commentStr = appData.consts.commentStr;
appData.save.isSave = 0;
appData.save.picNo = 1;

appData.loop.isLoop = 0;
appData.loop.measurementsList = {};
appData.loop.measurements = [];
% appData.loop.loopStart = 0;
% appData.loop.loopJump = 0;
% appData.loop.noJumps = 0;
% appData.loop.noIterations = 0;
% appData.loop.curVal = 0;
% appData.loop.curJump = 0;
% appData.loop.curIteration = 0;

% appData.monitoring.currentMonitoring = [];
% appData.monitoring.onlySavedPics = 1;
% appData.monitoring.isMonitoring = 0;
% appData.monitoring.monitoringData = cell(1, 3);
% appData.monitoring.figs = [];

appData.analyze.currentAnalyzing = [];
% appData.analyze.analyzePicNums = [1 : 5];
appData.analyze.showPicNo = 1;
appData.analyze.isReadPic = 0;
appData.analyze.readDir = appData.save.defaultDir;
appData.analyze.totAppData = 0;

% appData.fitData = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% defining components
%

appData.ui.win = figure('Visible', 'off', ...
    'Name', appData.consts.winName, ...
    'Units', 'Pixels', ...
    'Position', [appData.consts.winXPos appData.consts.winYPos appData.consts.screenWidth appData.consts.screenHeight], ...
    'Resize', 'on', ...
    'MenuBar', 'None', ...
    'Toolbar', 'None', ...
    'NumberTitle', 'off' , ...
    'HandleVisibility', 'callback');%, ...
%      'DeleteFcn', {@closewin_Callback},...
%     'ResizeFcn', @win_resize);

% creating axes
%%%%%%%%
appData.ui.plot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5 5 appData.data.plotWidth appData.data.plotHeight], ...
    'HandleVisibility', 'callback', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
appData.ui.xPlot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5 5+appData.data.plotHeight+appData.consts.strHeight appData.data.plotWidth appData.consts.xyPlotsHeight], ...
    'HandleVisibility', 'callback', ...
    'XTickLabel', '', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
xlabel(appData.ui.xPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
ylabel(appData.ui.xPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);
appData.ui.yPlot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5+appData.data.plotWidth+appData.consts.strHeight 5 appData.consts.xyPlotsHeight appData.data.plotHeight], ...
    'HandleVisibility', 'callback', ...
    'YTickLabel', '', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
ylabel(appData.ui.yPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
xlabel(appData.ui.yPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);

% creating panel - Plotting and Fitting
%%%%%%%%%%%%%%%%%%%%

appData.ui.pPlotFit = uipanel('Parent', appData.ui.win, ...
    'Title', 'Plotting and Fitting', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [640 630 225 150], ... 
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st11 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'ROI Size:', ...
    'Units', 'pixels', ...
    'Position', [5 5 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etROISizeX = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROISizeX), ...
    'Units', 'pixels', ...
    'Position', [80 5 30 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROISizeX_Callback}); 
appData.ui.etROISizeY = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROISizeY), ...
    'Units', 'pixels', ...
    'Position', [110 5 30 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROISizeY_Callback}); 
appData.ui.etROICenterX = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROICenterX), ...
    'Units', 'pixels', ...
    'Position', [140 5 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROICenterX_Callback}); 
appData.ui.etROICenterY = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROICenterY), ...
    'Units', 'pixels', ...
    'Position', [180 5 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROICenterY_Callback}); 

appData.ui.st12 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'ROI Units:', ...
    'Units', 'pixels', ...
    'Position', [5 40 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmROIUnits = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.ROIUnits.str, ...
    'Value', appData.data.ROIUnits, ...
    'Units', 'pixels', ...
    'Position', [80 45  140 20], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmROIUnits_Callback}); 

appData.ui.st13 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'Plot Type:', ...
    'Units', 'pixels', ...
    'Position', [5 70 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmPlotType = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.plotTypes.str, ...
    'Value', appData.data.plotType, ...
    'Units', 'pixels', ...
    'Position', [80 75  140 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmPlotType_Callback}); 

appData.ui.st14 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'Fit Type:', ...
    'Units', 'pixels', ...
    'Position', [5 100 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmFitType = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.fitTypes.str, ...
    'Value', appData.data.fitType, ...
    'Units', 'pixels', ...
    'Position', [80 105  140 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmFitType_Callback}); 

    

% creating panel - Options
%%%%%%%%%%%%%%%%%%%%

appData.ui.pOption = uipanel('Parent', appData.ui.win, ...
    'Title', 'Options', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 5 485 90], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);


appData.ui.pmCalcAtomsNo = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.calcAtomsNo.str, ...
    'Value', appData.options.calcAtomsNo, ...
    'Units', 'pixels', ...
    'Position', [5 10 100 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmCalcAtomsNo_Callback}); 
appData.ui.tbReanalyze = uicontrol(appData.ui.pOption, ...
    'Style', 'togglebutton', ...
    'String', 'Re-Analyze', ...
    'Units', 'pixels', ...
    'Position', [110 5 100 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@tbReanalyze_Callback}); 
appData.ui.pmPlotSetting = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.plotSetting.str, ...
    'Value', appData.options.plotSetting, ...
    'Units', 'pixels', ...
    'Position', [215 10 115 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmPlotSetting_Callback}); 
appData.ui.pmCameraType = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.cameraTypes.str, ...
    'Value', appData.options.cameraType, ...
    'Units', 'pixels', ...
    'Position', [335 10 145 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmCameraType_Callback}); 


appData.ui.st21 = uicontrol(appData.ui.pOption, ...
    'Style', 'text', ...
    'String', 'Detuning (MHz):', ...
    'Units', 'pixels', ...
    'Position', [5 40 110 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etDetuning = uicontrol(appData.ui.pOption, ...
    'Style', 'edit', ...
    'String', num2str(appData.options.detuning), ...
    'Units', 'pixels', ...
    'Position', [110 40 35 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etDetuning_Callback}); 
appData.ui.st22 = uicontrol(appData.ui.pOption, ...
    'Style', 'text', ...
    'String', 'Avg. Width (half):', ...
    'Units', 'pixels', ...
    'Position', [150 40 130 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etAvgWidth = uicontrol(appData.ui.pOption, ...
    'Style', 'edit', ...
    'String', num2str(appData.options.avgWidth), ...
    'Units', 'pixels', ...
    'Position', [260 40 35 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etAvgWidth_Callback}); 
appData.ui.cbDoPlot = uicontrol(appData.ui.pOption, ...
    'Style', 'checkbox', ...
    'String', 'Update plots', ...
    'Max', 1, ...
    'Min', 0, ...
    'Value', appData.options.doPlot, ...
    'Units', 'pixels', ...
    'Position', [300 40 100 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
     'Callback', {@cbDoPlot_Callback});
 appData.ui.pbCompareFiles = uicontrol(appData.ui.pOption, ...
    'Style', 'pushbutton', ...
    'String', 'Compare', ...
    'Units', 'pixels', ...
    'Position', [405 40 75 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbCompareFiles_Callback}); 



% creating panel - Loop Options
%%%%%%%%%%%%%%%%%%%%%

appData.ui.pLoop = uipanel('Parent', appData.ui.win, ...
    'Title', 'Loop', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 95 485 85], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

% appData.ui.st31 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'No. Jumps:', ...
%     'Units', 'pixels', ...
%     'Position', [5 5 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etNoLoops = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.noJumps), ...
%     'Units', 'pixels', ...
%     'Position', [100 5 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etNoJumps_Callback}); 
% appData.ui.sNoLoops = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [150 5 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sNoJumps_Callback}); 
% appData.ui.st32 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'No. Iterations:', ...
%     'Units', 'pixels', ...
%     'Position', [175 5 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etNoIterations = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.noIterations), ...
%     'Units', 'pixels', ...
%     'Position', [270 5 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etNoIterations_Callback}); 
% appData.ui.sNoIterations = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [320 5 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sNoIterations_Callback}); 
% 
% appData.ui.st33 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'Loop Start:', ...
%     'Units', 'pixels', ...
%     'Position', [5 35 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etLoopStart = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.loopStart), ...
%     'Units', 'pixels', ...
%     'Position', [100 40 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etLoopStart_Callback}); 
% appData.ui.sLoopStart = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [150 40 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sLoopStart_Callback}); 
% appData.ui.st34 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'Loop Jump:', ...
%     'Units', 'pixels', ...
%     'Position', [175 35 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etLoopJump = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.loopJump), ...
%     'Units', 'pixels', ...
%     'Position', [270 40 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etLoopJump_Callback}); 
% appData.ui.sLoopJump = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [320 40 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sLoopJump_Callback}); 


% appData.ui.pbEditLoop = uicontrol(appData.ui.pLoop, ...
%     'Style', 'pushbutton', ...
%     'String', 'Edit', ...
%     'Units', 'pixels', ...
%     'Position', [70 5 60 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'center', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@pbEditLoop_Callback});  
% appData.ui.pbRemoveLoop = uicontrol(appData.ui.pLoop, ...
%     'Style', 'pushbutton', ...
%     'String', 'Remove', ...
%     'Units', 'pixels', ...
%     'Position', [135 5 70 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'center', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@pbRemoveLoop_Callback}); 

appData.ui.pmAvailableLoops = uicontrol(appData.ui.pLoop, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.availableLoops.str, ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [5 13 130 20], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmAvailableLoops_Callback}); 

appData.ui.pbAddMeasurement = uicontrol(appData.ui.pLoop, ...
    'Style', 'pushbutton', ...
    'String', 'Add', ...
    'Units', 'pixels', ...
    'Position', [140 5 60 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pbAddMeasurement_Callback});  

appData.ui.lbMeasurementsList = uicontrol(appData.ui.pLoop, ...
    'Style', 'listbox', ...
    'String', '', ...
    'Min', 0, ...
    'Max', 1, ...
    'Units', 'pixels', ...
    'Position', [205 5 135 60], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'KeyPressFcn', {@lbMeasurementsList_KeyPressFcn});

appData.ui.tbLoop = uicontrol(appData.ui.pLoop, ...
    'Style', 'togglebutton', ...
    'String', 'Loop On/Off', ...
    'Value', appData.loop.isLoop, ...
    'Units', 'pixels', ...
    'Position', [350 10 125 50], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbLoop_Callback}); 


% creating panel - Save Options
%%%%%%%%%%%%%%%%%%%%%

appData.ui.pSave = uipanel('Parent', appData.ui.win, ...
    'Title', 'Save', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 180 485 145], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st41 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Save Param:', ...
    'Units', 'pixels', ...
    'Position', [5 5 90 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmSaveParam = uicontrol(appData.ui.pSave, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.saveParams.str, ...
    'Value', appData.save.saveParam, ...
    'Units', 'pixels', ...
    'Position', [105 10 90 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmSaveParam_Callback}); 
appData.ui.st42 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Param Val:', ...
    'Units', 'pixels', ...
    'Position', [200 5 90 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etParamVal = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', num2str(appData.save.saveParamVal), ...
    'Units', 'pixels', ...
    'Position', [275 5 65 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etParamVal_Callback}); 
% appData.ui.etSaveOtherParam = uicontrol(appData.ui.pSave, ...
%     'Style', 'edit', ...
%     'String', appData.consts.saveOtherParamStr, ...
%     'Units', 'pixels', ...
%     'Position', [215 5 125 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etSaveOtherParam_Callback}); 

appData.ui.st43 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'File Comment:', ...
    'Units', 'pixels', ...
    'Position', [5 35 100 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etComment = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', appData.consts.commentStr, ...
    'Units', 'pixels', ...
    'Position', [105 35 235 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etComment_Callback}); 

appData.ui.pbOpenSaveDir = uicontrol(appData.ui.pSave, ...
    'Style', 'pushbutton', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [5 65 30 30], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'CData', appData.consts.folderIcon, ...
    'Callback', {@pbOpenSaveDir_Callback}); 
appData.ui.st44 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Pic. No.:', ...
    'Units', 'pixels', ...
    'Position', [40 65 60 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etPicNo = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', num2str(appData.save.picNo), ...
    'Units', 'pixels', ...
    'Position', [105 65 50 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etPicNo_Callback}); 
appData.ui.sPicNo = uicontrol(appData.ui.pSave, ...
    'Style', 'slider', ...
    'Max', 2, ...
    'Min', 0, ...
    'SliderStep', [0.5 0.5], ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [155 65 20 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Callback', {@sPicNo_Callback}); 
appData.ui.pbSaveCurrent = uicontrol(appData.ui.pSave, ...
    'Style', 'pushbutton', ...
    'String', 'Save Current Pic.', ...
    'Units', 'pixels', ...
    'Position', [180 65 160 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pbSaveCurrent_Callback});  

appData.ui.tbSave = uicontrol(appData.ui.pSave, ...
    'Style', 'togglebutton', ...
    'String', 'Save All', ...
    'Value', appData.save.isSave, ...
    'Units', 'pixels', ...
    'Position', [350 10 125 75], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbSave_Callback}); 

appData.ui.etSaveDir = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', appData.save.saveDir, ...
    'Units', 'pixels', ...
    'Position', [5 97 485-10 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etSaveDir_Callback}); 


% creating panel - Fit Results
%%%%%%%%%%%%%%%%%%%%

appData.ui.pFitResults = uipanel('Parent', appData.ui.win, ...
    'Title', 'Fit Results', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 325 485 220], ...% [790 325 485 305], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);
appData.ui.tmp = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [790 325 1 1], ...
    'HandleVisibility', 'off');

% Run Button
%%%%%%%%%%%%%%%%%%%%
            
appData.ui.tbRun = uicontrol(appData.ui.win, ...
    'Style', 'togglebutton', ...
    'String', 'Run', ...
    'Value', appData.data.isRun, ...
    'Units', 'pixels', ...
    'Position', [790 550 125 75], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbRun_Callback});


% creating panel - Monitoring
%%%%%%%%%%%%%%%%%%%%

% appData.ui.pMonitoring = uipanel('Parent', appData.ui.win, ...
%     'Title', 'Monitoring', ...
%     'TitlePosition', 'lefttop', ...
%     'Units', 'pixels', ...
%     'Position', [790+140 550 345 75], ...% [790 325 485 305], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize);
% 
% st71 = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'text', ...
%     'String', {'Available' 'Monitoring:'}, ...
%     'Units', 'pixels', ...
%     'Position', [5 5 70 appData.consts.componentHeight*2], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize);
% appData.ui.lbAvailableMonitoring = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'listbox', ...
%     'String', appData.consts.availableMonitoring.str, ...
%     'Max', length(appData.consts.availableMonitoring.str), ...
%     'Value', appData.monitoring.currentMonitoring, ...
%     'Units', 'pixels', ...
%     'Position', [80 5 125 appData.consts.componentHeight*2+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@lbAvailableMonitoring_Callback}); 
% appData.ui.tbMonitoringOnOff = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'togglebutton', ...
%     'String', 'On/Off', ...
%     'Value', appData.monitoring.isMonitoring, ...
%     'Units', 'pixels', ...
%     'Position', [210 5 65 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize, ...    
%     'Callback', {@tbMonitoringOnOff_Callback}); 
% appData.ui.pbMonitoringSave = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'pushbutton', ...
%     'String', 'Save', ...
%     'Units', 'pixels', ...
%     'Position', [280 5 55 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize, ...    
%     'Callback', {@pbMonitoringSave_Callback}); 
% cbOnlySavedPics = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'checkbox', ...
%     'String', 'Only Saved Pics', ...
%     'Max', 1, ...
%     'Min', 0, ...
%     'Value', appData.monitoring.onlySavedPics, ...
%     'Units', 'pixels', ...
%     'Position', [210 35 130 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%      'Callback', {@cbOnlySavedPics_Callback});


% creating panel - Analyze Options
%%%%%%%%%%%%%%%%%%%%

appData.ui.pAnylize = uipanel('Parent', appData.ui.win, ...
    'Title', 'Analyze Options', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [870 630 405 150], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st81 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', {'Analyze' 'Data:'}, ...
    'Units', 'pixels', ...
    'Position', [5 5 55 appData.consts.componentHeight*2+15], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.lbAvailableAnalyzing = uicontrol(appData.ui.pAnylize, ...
    'Style', 'listbox', ...
    'String', appData.consts.availableAnalyzing.str, ...
    'Max', length(appData.consts.availableAnalyzing.str), ...
    'Value', appData.analyze.currentAnalyzing, ...
    'Units', 'pixels', ...
    'Position', [60 5 135 appData.consts.componentHeight*2+15], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@lbAvailableAnalyzing_Callback}); 
appData.ui.pbSaveToWorkspace = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Save to WS', ...
    'Units', 'pixels', ...
    'Position', [200 5 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbSaveToWorkspace_Callback}); 
appData.ui.pbClearTotappData = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Clear Data', ...
    'Units', 'pixels', ...
    'Position', [310 5 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbClearTotAppData_Callback}); 
appData.ui.pbAnalyze = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Analyze', ...
    'Units', 'pixels', ...
    'Position', [200 35 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbAnalyze_Callback}); 
appData.ui.tbReadPics = uicontrol(appData.ui.pAnylize, ...
    'Style', 'togglebutton', ...
    'String', 'Read Pics', ...
    'Units', 'pixels', ...
    'Position', [310 35 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbReadPics_Callback}); 

appData.ui.st82 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', 'Pic No:', ...
    'Units', 'pixels', ...
    'Position', [5 65 50 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etShowPicNo = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', num2str(appData.analyze.showPicNo), ...
    'Units', 'pixels', ...
    'Position', [55 65 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etShowPicNo_Callback}); 
appData.ui.sShowPicNo = uicontrol(appData.ui.pAnylize, ...
    'Style', 'slider', ...
    'Max', 2, ...
    'Min', 0, ...
    'SliderStep', [0.5 0.5], ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [90 65 20 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Callback', {@sShowPicNo_Callback}); 
appData.ui.tbReadPic = uicontrol(appData.ui.pAnylize, ...
    'Style', 'togglebutton', ...
    'String', 'Read Pic', ...
    'Value', appData.analyze.isReadPic, ...
    'Units', 'pixels', ...
    'Position', [115 65 75 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbReadPic_Callback}); 
appData.ui.st83 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', 'Pics Nums:', ...
    'Units', 'pixels', ...
    'Position', [200 65 85 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etAnalyzePicNums = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [280 65 120 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etAnalyzePicNums_Callback}); 



appData.ui.pbOpenReadDir = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [5 95 30 30], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'CData', appData.consts.folderIcon, ...
    'Callback', {@pbOpenReadDir_Callback}); 
appData.ui.etReadDir = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', appData.analyze.readDir, ...
    'Units', 'pixels', ...
    'Position', [40 97 360 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etReadDir_Callback}); 


% last commands
if strcmp(runVer, 'online')
    set(appData.ui.pAnylize, 'Visible', 'off');
    appData.consts.winName = 'Imaging Analysis (Online): Picture ';
%     if strcmp(isFTP, 'FTP')
%         ftpname=ftp(appData.consts.ftpAddress);
%         cd(ftpname, appData.consts.ftpDir);
%     end
elseif strcmp(runVer, 'offline')
    set(appData.ui.tbRun, 'Visible', 'off');
    set(appData.ui.pLoop, 'Visible', 'off');
    appData.consts.winName = 'Imaging Analysis (Offline): Picture ';
else
    errordlg('Function input incorrect', 'Error', 'modal');
    return
end
set(appData.ui.win, 'Name', appData.consts.winName);
set(appData.ui.win, 'Visible', 'on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function closewin_Callback(object, eventdata) %#ok<INUSD>
%     if strcmp(isFTP, 'FTP')
%         close(ftpname);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROISizeX_Callback(object, eventdata) %#ok<*DEFNU,INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz<= 0
        set(object, 'String', num2str(appData.data.ROISizeX));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROISizeX = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROISizeY_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz<= 0
        set(object, 'String', num2str(appData.data.ROISizeY));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROISizeY = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROICenterX_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz< 0
        set(object, 'String', num2str(appData.data.ROICenterX));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROICenterX = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROICenterY_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz< 0
        set(object, 'String', num2str(appData.data.ROICenterY));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROICenterY = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmROIUnits_Callback(object, eventdata) %#ok<INUSD
    appData.data.ROIUnits = get(object, 'Value');
    appData = updateROI(appData);
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmFitType_Callback(object, eventdata) %#ok<INUSD>    
    appData.data.fitType = get(object, 'Value');
    if ( appData.save.isSave == 1 )
        appData.save.picNo = appData.save.picNo - 1;
    end
    appData = analyzeAndPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmPlotType_Callback(object, eventdata) %#ok<INUSD>
    appData.data.plotType = get(object, 'Value');
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmCalcAtomsNo_Callback(object, eventdata) %#ok<INUSD>
    appData.options.calcAtomsNo = get(object, 'Value');
    appData = updateROI(appData);
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReanalyze_Callback(object, eventdata) %#ok<INUSD>    
    if (get(object, 'Value') == 0)
        return
    end
    appData.data.fits = appData.consts.fitTypes.fits;
%     appData.data.plots = appData.consts.plotTypes.plots;
    if ( appData.save.isSave == 1 )
        appData.save.picNo = appData.save.picNo - 1;
    end
    appData = analyzeAndPlot(appData);
    set(object, 'Value', 0);
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmPlotSetting_Callback(object, eventdata) %#ok<INUSD>
    appData.options.plotSetting = get(object, 'Value');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmCameraType_Callback(object, eventdata) %#ok<INUSD>
    appData.options.cameraType = get(object, 'Value');
    appData.data.camera = appData.consts.cameras{appData.options.cameraType};
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etDetuning_Callback(object, eventdata) %#ok<INUSD>
    det = str2double(get(object, 'String'));
    if isnan(det)
        set(object, 'String', num2str(appData.options.detuning));
        errordlg('Input must be a  number','Error', 'modal');
    else
        appData.options.detuning = det;
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etAvgWidth_Callback(object, eventdata) %#ok<INUSD>
    avg = str2double(get(object, 'String'));
    if isnan(avg) || avg < 0 || floor(avg) ~= avg  
        set(object, 'String', num2str(appData.options.avgWidth));
        errordlg('Input must be a positive integer','Error', 'modal');
    else
        appData.options.avgWidth = avg;
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cbDoPlot_Callback(object, eventdata) %#ok<INUSD>
    appData.options.doPlot = get(object, 'Value');
    if appData.options.doPlot == 1
        % Plot image and results
        onlyPlot(appData)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbCompareFiles_Callback(object, eventdata) %#ok<INUSD>
    answer = measDlg({'First File' 'Second File'}, 'Compare Two Files', [1 1]',  {'first file' 'second file'}, ...
        struct('Interpreter', 'tex', 'WindowStyle', 'normal', 'Resize', 'off'),  {'file' 'file' }, {[appData.save.saveDir '\*.txt'] [appData.save.saveDir '\*.txt'] });
    if ~isempty(answer)
        ret = compareLabview( LVData.readLabview(answer{1}), LVData.readLabview(answer{2})); %#ok<NASGU>
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etNoJumps_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) || val <= 0 || floor(val) ~= val )
%         set(object, 'String', num2str(appData.loop.noJumps));
%         errordlg('Input must be positive integer','Error', 'modal');
%     else
%         appData.loop.noJumps = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etNoIterations_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) || val <= 0 || floor(val) ~= val )
%         set(object, 'String', num2str(appData.loop.noIterations));
%         errordlg('Input must be positive integer','Error', 'modal');
%     else
%         appData.loop.noIterations = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etLoopStart_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) )
%         set(object, 'String', num2str(appData.loop.loopStart));
%         errordlg('Input must be a number','Error', 'modal');
%     else
%         appData.loop.loopStart = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etLoopJump_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) )
%         set(object, 'String', num2str(appData.loop.loopJump));
%         errordlg('Input must be a number','Error', 'modal');
%     else
%         appData.loop.loopJump = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sNoJumps_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         if ( appData.loop.noJumps > 1 )
%             appData.loop.noJumps = appData.loop.noJumps - 1;
%         end
%     elseif ( val == 2 )
%         appData.loop.noJumps = appData.loop.noJumps + 1;
%     end
%     set(appData.ui.etNoLoops, 'String', num2str(appData.loop.noJumps));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sNoIterations_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         if ( appData.loop.noIterations > 1 )
%             appData.loop.noIterations = appData.loop.noIterations - 1;
%         end
%     elseif ( val == 2 )
%         appData.loop.noIterations = appData.loop.noIterations + 1;
%     end
%     set(appData.ui.etNoIterations, 'String', num2str(appData.loop.noIterations));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sLoopStart_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         appData.loop.loopStart = appData.loop.loopStart - 1;
%     elseif ( val == 2 )
%         appData.loop.loopStart = appData.loop.loopStart + 1;
%     end
%     set(appData.ui.etLoopStart, 'String', num2str(appData.loop.loopStart));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sLoopJump_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         appData.loop.loopJump = appData.loop.loopJump - 1;
%     elseif ( val == 2 )
%         appData.loop.loopJump = appData.loop.loopJump + 1;
%     end
%     set(appData.ui.etLoopJump, 'String', num2str(appData.loop.loopJump));
%     set(object, 'Value', 1);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmAvailableLoops_Callback(object, eventdata)  %#ok<INUSD>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lbMeasurementsList_KeyPressFcn (object, eventdata)  %#ok<INUSL>
    val = get(appData.ui.lbMeasurementsList, 'Value');
    if isempty(val)
        return
    end
    switch(eventdata.Key)
        case 'return'
%              fieldNames = fieldnames(appData.loop.measurements{val});
%             for i = 1 : length(fieldNames);
%                 if strcmp(fieldNames(i), 'GUI')
%                     appData.loop.measurements{val} = appData.loop.measurements{val}.createLoadObj();
%                     break
%                 end
%             end
            meas = appData.loop.measurements{val}.edit(appData);
%             meas = appData.loop.measurements{val}.initialize(appData);
            
%             fieldNames = fieldnames(appData.loop.measurements{val});
% %             for i = 1 : length(fieldNames);
%                 if strcmp(fieldNames(1), 'GUI')
%                     meas = appData.loop.measurements{val}.createLoadObj();
% %                     meas.updateGUI();
% %                     break
%                 end
% %             end
% %             appData.loop.measurements{val} = appData.loop.measurements{val}.load();
%             if isempty(meas) || meas.noIterations == -1
%                 return;
%             end
            appData.loop.measurements{val} = meas;  
        case 'removeFirst'
            set(appData.ui.lbMeasurementsList, 'Value', 1);
            appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
            appData.loop.measurementsList =  {appData.loop.measurementsList{2:end}}; %#ok<CCAT1>
            appData.loop.measurements = {appData.loop.measurements{2:end}}; %#ok<CCAT1>
            if val > length(appData.loop.measurementsList) && val > 1
                val = val-1;
            elseif isempty(appData.loop.measurementsList)
                val = [];
%                 set(appData.ui.tbLoop, 'Value', 0)
%                 tbLoop_Callback(appData.ui.tbLoop, []) ;
            end
            set(appData.ui.lbMeasurementsList, 'Value', val);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
        case 'delete'
            appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
            appData.loop.measurementsList = {appData.loop.measurementsList{1:val-1} appData.loop.measurementsList{val+1:end}};
            appData.loop.measurements =  {appData.loop.measurements{1:val-1} appData.loop.measurements{val+1:end}};
            if val > length(appData.loop.measurementsList) && val > 1
                val = val-1;
            elseif isempty(appData.loop.measurementsList)
                val = [];
                set(appData.ui.tbLoop, 'Value', 0)
                tbLoop_Callback(appData.ui.tbLoop, []) ;
            end
            set(appData.ui.lbMeasurementsList, 'Value', val);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbAddMeasurement_Callback(object, eventdata) %#ok<INUSD>
    
    appData.data.LVData = LVData.readLabview(appData.consts.defaultStrLVFile_Save);
    if isempty(appData.data.LVData)
        errordlg({'Cannot read file!!',  ['Maybe file does not exist: ' appData.consts.defaultStrLVFile_Save]},'Error', 'modal');
        return
    end
    appData.data.firstLVData = appData.data.LVData;

    val = get(appData.ui.pmAvailableLoops, 'Value');  
    h = appData.consts.availableLoops.createFncs{val};
    meas = h(appData);
    
%     fieldNames = fieldnames(meas);
% %     for i = 1 : length(fieldNames);
%         if strcmp(fieldNames(1), 'GUI')
%             meas = meas.createLoadObj();
% %             break
%         end
% %     end
    
    if isempty(meas) || meas.noIterations == -1
        return
    end
    appData.loop.measurements{length(appData.loop.measurements)+1} = meas;  
    
    appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
    appData.loop.measurementsList{length(appData.loop.measurementsList)+1} = meas.getMeasStr(appData);

    set(appData.ui.lbMeasurementsList, 'Value', 1);    
    set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbLoop_Callback(object, eventdata) 
    appData.loop.isLoop = get(object, 'Value');
    if ( appData.loop.isLoop == 0 )
        set(appData.ui.tbSave, 'Value', 0);
        tbSave_Callback(appData.ui.tbSave, eventdata)
        return
    end    
    if isempty(get(appData.ui.lbMeasurementsList, 'String'))
        warndlg('Measurements list is empty.', 'Warning', 'modal');
        set(appData.ui.tbLoop, 'Value', 0)
        tbLoop_Callback(object, eventdata);
        return
    end
    set(appData.ui.tbSave, 'Value', 1);
    tbSave_Callback(appData.ui.tbSave, eventdata);
%     set(appData.ui.etParamVal, 'String', 'wait...');
    if appData.loop.measurements{1}.position == 0
        [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
%         etSaveDir_Callback(appData.ui.etSaveDir, []);
    end
    
    set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
    etSaveDir_Callback(appData.ui.etSaveDir, []);
    appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
    appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
    set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
        
%     appData.loop.curVal = appData.loop.loopStart;
%     appData.save.saveParamVal = appData.loop.curVal;
%     set(appData.ui.etParamVal, 'String', num2str(appData.save.saveParamVal));
%     appData.loop.curJump = 1;
%     appData.loop.curIteration = 1;
end

% function tbSave_Callback(object, eventdata) %#ok<INUSD>
%     appData.save.isSave  = get(object, 'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmSaveParam_Callback(object, eventdata) %#ok<INUSD>
    appData.save.saveParam = get(object, 'Value');
%     str = get(object, 'String');
    otherParam = appData.consts.saveParams.otherParam;
    if ( appData.save.saveParam == otherParam )%&& ...
%             strcmp(str{otherParam}, appData.consts.saveParams.str{otherParam}))
        param = inputdlg('Enter param name:', 'Other param input');
        set(appData.ui.pmSaveParam, 'String', {appData.consts.saveParams.str{1:end-1} ['O.P. - ' param{1}]});
        appData.save.saveOtherParamStr = param;
%     elseif ( appData.save.saveParam == otherParam && ...
%             ~strcmp(str{otherParam}, appData.consts.saveParams.str{otherParam}))
        
    else    
        set(appData.ui.pmSaveParam, 'String', appData.consts.saveParams.str);
        appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etParamVal_Callback(object, eventdata) %#ok<INUSD>
    val = str2double(get(object, 'String'));
    if isnan(val)
        set(object, 'String', num2str(appData.save.saveParamVal));
        errordlg('Input must be a number','Error', 'modal');
    else
        appData.save.saveParamVal = val;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etComment_Callback(object, eventdata) %#ok<INUSD>
    appData.save.commentStr = get(object, 'String');
    if ( ~isempty(appData.save.commentStr) )
        appData.save.commentStr = ['-' appData.save.commentStr];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbOpenSaveDir_Callback(object, eventdata)   %#ok<INUSL>
    dirName = uigetdir(get(appData.ui.etSaveDir, 'String'));
    if ( dirName ~= 0 )
        set(appData.ui.etSaveDir, 'String', dirName);
        etSaveDir_Callback(appData.ui.etSaveDir, eventdata)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbSaveCurrent_Callback(object, eventdata) %#ok<INUSD>
    if ( appData.analyze.isReadPic == 1 )
        picNo = appData.save.picNo;
%         picNo = appData.data.picNo;
    elseif ( appData.save.isSave == 1 && appData.analyze.isReadPic == 0 )
        picNo = appData.save.picNo - 1;
    else
        picNo = appData.save.picNo;
    end
    
    savedData = createSavedData(appData);  %#ok<NASGU>
    save([appData.save.saveDir '\data-' num2str(picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);
        
%     if ( ~isempty(appData.consts.LVFile) && strcmp(appData.consts.runVer, 'online') )
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(picNo) '.txt']); %#ok<NASGU>
%         if ( s == 0 )
%             warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%         end
%     end
    if ( strcmp(appData.consts.runVer, 'online') )
        ret = appData.data.LVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
        if ( ret == 0)
            warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
        end
    end
    
    set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
    
    if ( appData.analyze.isReadPic == 0)
        appData.save.picNo = picNo + 1;
        set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etPicNo_Callback(object, eventdata) %#ok<INUSD>
    val = str2double(get(object, 'String'));
    if ( isnan(val) || val <= 0 || floor(val) ~= val )
        set(object, 'String', num2str(appData.save.picNo));
        errordlg('Input must be positive integer','Error', 'modal');
    else
        appData.save.picNo = val;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sPicNo_Callback(object, eventdata) %#ok<INUSD>
    val = get(object, 'Value');
    if ( val == 0 )
        if ( appData.save.picNo > 1 )
            appData.save.picNo = appData.save.picNo - 1;
        end
    elseif ( val == 2 )
        appData.save.picNo = appData.save.picNo + 1;
    end
    set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    % setWinName(appData);
    set(object, 'Value', 1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbSave_Callback(object, eventdata) %#ok<INUSD>
    appData.save.isSave  = get(object, 'Value');
%     appData.analyze.isReadPic = 0;
%     set(appData.ui.tbReadPic, 'Value', 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etSaveDir_Callback(object, eventdata) %#ok<INUSD>
    appData.save.saveDir = get(object, 'String');
    [s, mess, messid] = mkdir(appData.save.saveDir); %#ok<NASGU>
    if ( s == 0 )
        warndlg(['Cannot open/create directory: ' mess], 'Warning', 'modal');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbRun_Callback(object, eventdata)  

appData.data.isRun  = get(object, 'Value');

if ( appData.data.isRun == 0 )
    return
end

% firstLoop = 1;
% i = 0; %safety
picPause = 0.5;
isLastLVData = 0;
isNewMeasurement = 0;
% saftyPause = 1;
while ( appData.data.isRun == 1 )%&& i < 10 )   
    %
    % read atoms, backgraund and dark images
    %
    
    fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  ...
        num2str(appData.data.camera.firstImageNo) '.' appData.data.camera.fileFormat];
    fid = fopen(fileName);
    while ( fid  == -1 && appData.data.isRun == 1)
        pause(picPause);
        fid = fopen(fileName);
    end
    if ( appData.data.isRun == 0 )
        return
    end
    fclose(fid); 
    pause(picPause);
%     appData.data.atoms = rot90( double(appData.data.camera.fileReadFunction(appData, 0)), appData.data.camera.rotate / 90);
    atoms = rot90( double(appData.data.camera.fileReadFunction(appData, appData.data.camera.firstImageNo)), ...
        appData.data.camera.rotate / 90);
    delete(fileName);
   
    fileName = [appData.data.camera.dir '\' appData.data.camera.fileName ...
        num2str(appData.data.camera.secondImageNo) '.' appData.data.camera.fileFormat];
    fid = fopen(fileName);
    while ( fid  == -1 && appData.data.isRun == 1)
        pause(picPause);
        fid = fopen(fileName);
    end
    if ( appData.data.isRun == 0 )
        return
    end
    fclose(fid);
    pause(picPause);
%     appData.data.back = rot90( double(appData.data.camera.fileReadFunction(appData, 1)), appData.data.camera.rotate / 90);
    back = rot90( double(appData.data.camera.fileReadFunction(appData, appData.data.camera.secondImageNo)), ...
        appData.data.camera.rotate / 90);
    delete(fileName);
    
%     appData.data.dark = double(imread([appData.data.camera.dir '\' appData.data.camera.darkPicStr]));
    appData.data.dark = 0;%zeros(size(atoms));
    
    if ( appData.loop.isLoop == 0 )
        appData.data.LVData = LVData.readLabview(appData.consts.defaultStrLVFile_Save);
        appData.data.lastLVData = appData.data.LVData;
    end

    %
    % Loop 
    %
    if ( appData.loop.isLoop == 1 )
        if isempty(appData.loop.measurements)
            warndlg('No More Measurements.', 'Warning', 'modal');
            set(appData.ui.tbLoop, 'Value', 0)
            tbLoop_Callback(appData.ui.tbLoop, eventdata);
%             firstLoop = 1;
            continue
        end
        
        % get next measurement
        appData.data.lastLVData = appData.data.LVData;
        [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
%         pmSaveParam_Callback(appData.ui.pmSaveParam, []);
%         etParamVal_Callback(appData.ui.etParamVal, []);
        
        if isempty(appData.data.LVData)
%             'empty' %#ok<NOPRT>
%              set(appData.ui.lbMeasurementsList, 'Value', 1);
             lbMeasurementsList_KeyPressFcn(appData.ui.lbMeasurementsList, struct('Key', 'removeFirst'));
                 
            if  isempty(appData.loop.measurements)         % TODO : move that part to after saving (so the last pic will be saved)       
                isLastLVData = 1;
                
%                 set(appData.ui.tbSave, 'Value', 0);
%                 tbSave_Callback(appData.ui.tbSave, eventdata)
                
%                 set(appData.ui.tbLoop, 'Value', 0);
%                 tbLoop_Callback(appData.ui.tbLoop, eventdata)
%                 
%                 appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
            else
                isNewMeasurement = 1;
                % start next measuremdent
                [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
%                 pmSaveParam_Callback(appData.ui.pmSaveParam, []);
%                 etParamVal_Callback(appData.ui.etParamVal, []);
                
%                 set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
%                 etSaveDir_Callback(appData.ui.etSaveDir, []);
                appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
                appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
                set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
            end
        else
            set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
%             etSaveDir_Callback(appData.ui.etSaveDir, []);
            appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
            appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
            
%             if ( appData.save.isSave == 1 && strcmp(appData.consts.runVer, 'online') )
%                 ret = appData.data.LVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
%                 if ( ret == 0)
%                     warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%                 end
%             end
        end
    end
    
    
    %
    % Initialize data
    %

    appData.data.xPosMaxBack = 0;
    appData.data.yPosMaxBack = 0;
    
    appData.data.date = datestr(now);
    
    appData.data.fits = appData.consts.fitTypes.fits;
    appData.data.plots = appData.consts.plotTypes.plots;
%     appData.data.ROITypes = appData.consts.ROIUnits.ROITypes;

%     set(appData.ui.etComment, 'String', appData.consts.commentStr);
%     appData.save.commentStr = appData.consts.commentStr;

%     appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
    
    %
    % Create absorption image
    %
    atoms = atoms - appData.data.dark;                           % subtract the dark background from the atom pic
    atoms = atoms .* ( ~(atoms<0));                                                   % set all pixelvalues<0 to 0
    back =  back - appData.data.dark;                              % subtract the dark background from the background pic
    back = back .* ( ~(back<0));                                                         % set all pixelvalues<0 to 0
%     appData.data.absorption = log( (back2 + (back2==0))./ (atoms2 + (atoms2==0))  );  % set all pixelvalues=0 to 1 and divide pics
    absorption = log( (back + 1)./ (atoms + 1)  );
%     appData.data.absorption = log( (back2 + 1)./ (atoms2 + 1)  );
    appData = appData.data.plots{appData.consts.plotTypes.withAtoms}.setPic(appData, atoms);
    appData = appData.data.plots{appData.consts.plotTypes.withoutAtoms}.setPic(appData, back);
    appData = appData.data.plots{appData.consts.plotTypes.absorption}.setPic(appData, absorption);
    appData = appData.data.plots{appData.consts.plotTypes.ROI}.setPic(appData, absorption);
    
    %
    % Smoothing
    %
    
%     %
%     % Check for saturation
%     %
%     binningFactor = 10;
%     binnedData = binning ( back, binningFactor);
% 
%     [maxes, indexes] = max(binnedData);
%     [maxValue, xPosMax] = max(maxes);
%     yPosMax = indexes(xPosMax);
%     if maxValue >= (2^appData.data.camera.bits*0.95)
%         appData.data.xPosMaxBack = binningFactor * (xPosMax - 0.5);
%         appData.data.yPosMaxBack = binningFactor * (yPosMax - 0.5);
%         msgbox({['Found mean value of: ' num2str(maxValue) ' in a region of 10 by 10 pixels.'] ...
%             ['The maximum value the camera can handle is: ' num2str(2^appData.data.camera.bits) '.']}, ...
%             'CCD-Camera might be saturated!', 'warn', 'modal');
%     else
%         appData.data.xPosMaxBack = 0;
%         appData.data.yPosMaxBack = 0;
%     end
    
    %
    % Analyze and Plot
    %
    appData = analyzeAndPlot(appData);
    
    if ( appData.loop.isLoop == 1 )
        etSaveDir_Callback(appData.ui.etSaveDir, []);
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
    end
    if isNewMeasurement == 1
        isNewMeasurement = 0;
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
        set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
        etSaveDir_Callback(appData.ui.etSaveDir, []);
    end
    if isLastLVData == 1
        isLastLVData = 0;
        set(appData.ui.tbLoop, 'Value', 0);
        tbLoop_Callback(appData.ui.tbLoop, [])
        
        appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
    end
    
    
    
%     %
%     % Saving 
%     %
%     if ( appData.save.isSave == 1 )
%         savedData = createSavedData(appData); 
%         save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);
%             
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
%         if ( s == 0)
%             warndlg(['Cannot copy LabView file: ' mess], 'Warning', 'modal');
%         end
%         
%         set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
%         appData.save.picNo = appData.save.picNo + 1;
%         set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
%     end
    
    set(appData.ui.etComment, 'String', appData.consts.commentStr);
    appData.save.commentStr = appData.consts.commentStr;
    
    %
    % Monitoring
    %
    

    
%     pause(saftyPause);
%     i=i+1;
%     set(object, 'Value', 0); % stop running
end %while

%                 continue 
% set(appData.ui.pAnylize, 'Visible', 'on');
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function pbMonitoringSave_Callback(object, eventdata) %#ok<INUSD>
% export2wsdlg({'Monitoring Data:'}, {'monitoringData'}, {appData.monitoring.monitoringData});
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function tbMonitoringOnOff_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.isMonitoring = get(object, 'Value');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function cbOnlySavedPics_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.onlySavedPics = get(object, 'Value');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function lbAvailableMonitoring_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.currentMonitoring = get(object, 'Value');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lbAvailableAnalyzing_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.currentAnalyzing = get(object, 'Value');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbSaveToWorkspace_Callback(object, eventdata) %#ok<INUSD>
    export2wsdlg({'All Pics:'}, {'totAppData'}, {appData.analyze.totAppData});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbClearTotAppData_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.totAppData = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbAnalyze_Callback(object, eventdata) %#ok<INUSD>
    for ( i = 1 : length(appData.analyze.currentAnalyzing) )
        switch appData.analyze.currentAnalyzing(i)
            case appData.consts.availableAnalyzing.picMean
                pic = zeros(size(appData.analyze.totAppData{1}.data.plots{1}.pic));
                atoms = zeros(size(appData.analyze.totAppData{1}.data.plots{3}.pic));
                back = zeros(size(appData.analyze.totAppData{1}.data.plots{4}.pic));
                if isempty(pic)
                     errordlg('There is no data in the files. Use f when reading the files.','Error', 'modal'); 
                     continue;
                end
                for ( j = 1 : length(appData.analyze.totAppData)  )
                    pic = pic + appData.analyze.totAppData{j}.data.plots{1}.pic;
                    atoms = atoms + appData.analyze.totAppData{j}.data.plots{3}.pic;
                    back = back + appData.analyze.totAppData{j}.data.plots{4}.pic;
                end
                pic = pic / length(appData.analyze.totAppData);
                atoms = atoms / length(appData.analyze.totAppData);
                back = back / length(appData.analyze.totAppData);
                
                appData = appData.data.plots{appData.consts.plotTypes.absorption}.setPic(appData, [ zeros(appData.data.camera.chipStart-1, size(pic, 2)) ;pic]);
                appData = appData.data.plots{appData.consts.plotTypes.withAtoms}.setPic(appData, atoms);
                appData = appData.data.plots{appData.consts.plotTypes.withoutAtoms}.setPic(appData, back);
             
%                 appData.data.plots{1}.pic = pic;
                appData.data.fits = appData.consts.fitTypes.fits;
                appData = analyzeAndPlot(appData);
%%%%%%%%%%%%%%%%%%%%% save an averaged picture for 1 to j pics.
%             case appData.consts.availableAnalyzing.picMean
%                 for ( k = 1 : length(appData.analyze.totAppData)  )
%                     pic = zeros(size(appData.analyze.totAppData{1}.data.plots{1}.pic));
%                     atoms = zeros(size(appData.analyze.totAppData{1}.data.plots{3}.pic));
%                     back = zeros(size(appData.analyze.totAppData{1}.data.plots{4}.pic));
%                     if isempty(pic)
%                         errordlg('There is no data in the files. Use f when reading the files.','Error', 'modal');
%                         continue;
%                     end
%                     for ( j = 1 : length(appData.analyze.totAppData)  )
%                         pic = pic + appData.analyze.totAppData{j}.data.plots{1}.pic;
%                         atoms = atoms + appData.analyze.totAppData{j}.data.plots{3}.pic;
%                         back = back + appData.analyze.totAppData{j}.data.plots{4}.pic;
%                     end
%                     pic = pic / length(appData.analyze.totAppData);
%                     atoms = atoms / length(appData.analyze.totAppData);
%                     back = back / length(appData.analyze.totAppData);
%                     
%                     appData = appData.data.plots{appData.consts.plotTypes.absorption}.setPic(appData, [ zeros(appData.data.camera.chipStart-1, size(pic, 2)) ;pic]);
%                     appData = appData.data.plots{appData.consts.plotTypes.withAtoms}.setPic(appData, atoms);
%                     appData = appData.data.plots{appData.consts.plotTypes.withoutAtoms}.setPic(appData, back);
%                     
%                     %                 appData.data.plots{1}.pic = pic;
%                     appData.data.fits = appData.consts.fitTypes.fits;
%                     appData = analyzeAndPlot(appData);
%                     appData.save.picNo = k;
%                     pbSaveCurrent_Callback(object, eventdata)
%                 end
                %%%%%%%%%%%%%%%%%%%%
            otherwise
                appData = analyzeMeasurement(appData, i);
        end
    end
    return
    for ( i = 1 : length(appData.analyze.currentAnalyzing) ) %#ok<*NO4LP>
        switch appData.analyze.currentAnalyzing(i)
            case appData.consts.availableAnalyzing.temperature
%                 [graphs(i) results{i}]  = temperature2(appData.analyze.totAppData);
                temperature(appData.analyze.totAppData);
            case appData.consts.availableAnalyzing.heating
                heating(appData, @tbReadPics_Callback, @lbAvailableAnalyzing_Callback, @pbAnalyze_Callback);             
            case appData.consts.availableAnalyzing.gravity 
                gravity(appData.analyze.totAppData);
            case appData.consts.availableAnalyzing.lifeTime1 
                lifeTime1(appData.analyze.totAppData);
            case appData.consts.availableAnalyzing.lifeTime2 
                lifeTime2(appData.analyze.totAppData);
            case appData.consts.availableAnalyzing.dampedSine 
                dampedSineY(appData.analyze.totAppData);
            case appData.consts.availableAnalyzing.atomNo 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.atomsNo; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, N);
                xlabel('Param Value');
                ylabel('Atoms Number');
                case appData.consts.availableAnalyzing.OD 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.maxVal; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, N);
                xlabel('Param Value');
                ylabel('Max Val');
            case appData.consts.availableAnalyzing.xPos 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
%                     xPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.xCenter ...
%                         * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
                    xPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.x0 ...
                        * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, xPos);
                xlabel('Param Value');
                ylabel('X Position [mm]');
            case appData.consts.availableAnalyzing.yPos 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
%                     if isfield(appData.analyze.totAppData{j}.data.fits{ fitType }, 'y0')
                        yPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y0 ...
                            * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
%                     else
%                         yPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter ...
%                             * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
%                     end
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, yPos);
                xlabel('Param Value');
                ylabel('Y Position [mm]');
            case appData.consts.availableAnalyzing.sizeX 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    szX(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.xUnitSize ...
                        * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, szX);
                xlabel('Param Value');
                ylabel('Size X [mm]');
            case appData.consts.availableAnalyzing.sizeY 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    szY(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yUnitSize ...
                        * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val, szY);
                xlabel('Param Value');
                ylabel('Size Y [mm]');
            case appData.consts.availableAnalyzing.deltaY_2 
                 fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    Delta_Y2(j) = 0.5*abs(appData.analyze.totAppData{j}.data.fits{ fitType }.y02-appData.analyze.totAppData{j}.data.fits{ fitType }.y01)...
                        * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val,  Delta_Y2);
                xlabel('Param Value');
                ylabel('\Deltay/2  [mm]');
            case appData.consts.availableAnalyzing.picMean
                pic = zeros(size(appData.analyze.totAppData{1}.data.plots{1}.pic));
                atoms = zeros(size(appData.analyze.totAppData{1}.data.plots{3}.pic));
                back = zeros(size(appData.analyze.totAppData{1}.data.plots{4}.pic));
                if isempty(pic)
                     errordlg('There is no data in the files. Use f when reading the files.','Error', 'modal'); 
                     continue;
                end
                for ( j = 1 : length(appData.analyze.totAppData)  )
                    pic = pic + appData.analyze.totAppData{j}.data.plots{1}.pic;
                    atoms = atoms + appData.analyze.totAppData{j}.data.plots{3}.pic;
                    back = back + appData.analyze.totAppData{j}.data.plots{4}.pic;
                end
                pic = pic / length(appData.analyze.totAppData);
                atoms = atoms / length(appData.analyze.totAppData);
                back = back / length(appData.analyze.totAppData);
%                  figure;
%                  colormap(jet(256));
%                 image( ([x(1) x(end)]+x0-1)*appData.data.camera.xPixSz * 1000, ...
%                     ([y(1) y(end)]+y0-1-chipStart-1)*appData.data.camera.yPixSz * 1000, pic*256);
%                 imagesc( pic*256);
%                  xlabel('px');
%                  ylabel('px');
                appData = appData.data.plots{appData.consts.plotTypes.absorption}.setPic(appData, [ zeros(appData.data.camera.chipStart-1, size(pic, 2)) ;pic]);
                appData = appData.data.plots{appData.consts.plotTypes.withAtoms}.setPic(appData, atoms);
                appData = appData.data.plots{appData.consts.plotTypes.withoutAtoms}.setPic(appData, back);
             
%                 appData.data.plots{1}.pic = pic;
                appData.data.fits = appData.consts.fitTypes.fits;
                appData = analyzeAndPlot(appData);
            case appData.consts.availableAnalyzing.SG
                 fitType = appData.analyze.totAppData{1}.data.fitType;
                 N=[];
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.mF1*100; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
%                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
%                 hh = figure('CloseRequestFcn', {@closeRequestFcn_Callback, appData.analyze.readDir, 'SG.fig'});
%                 plot(val, N, 'o');
%                 xlabel(xlabelstr{get(appData.ui.pmSaveParam, 'Value')});
%                 ylabel('mF=1 Percentage [%]');
%                 saveas(hh, [appData.analyze.readDir '\SG_tmp.fig']);
%                 plotSG({appData.analyze.readDir})
                plotSG(val, N, appData.analyze.readDir);
            case appData.consts.availableAnalyzing.mF1
                 fitType = appData.analyze.totAppData{1}.data.fitType;
                 N=[];
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.mF1*100; %#ok<AGROW>
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '.fig']);
                plot(val,  N, 'o');
%                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
%                 xlabel(xlabelstr{appData.analyze.totAppData{1}.save.saveParamVal});
                xlabel('Param Value');
                ylabel('mF1 [%] ');
%                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
%                 hh = figure('CloseRequestFcn', {@closeRequestFcn_Callback, appData.analyze.readDir, 'SG.fig'});
%                 plot(val, N, 'o');
%                 xlabel(xlabelstr{get(appData.ui.pmSaveParam, 'Value')});
%                 ylabel('mF=1 Percentage [%]');
%                 saveas(hh, [appData.analyze.readDir '\SG_tmp.fig']);
%                 plotSG({appData.analyze.readDir})
%                 plotSG(val, N, appData.analyze.readDir);
            case appData.consts.availableAnalyzing.SGyPos 
                fitType = appData.analyze.totAppData{1}.data.fitType;
                for ( j= 1 : length(appData.analyze.totAppData)  )
%                     if isfield(appData.analyze.totAppData{j}.data.fits{ fitType }, 'y0')
                    switch fitType
                        case appData.consts.fitTypes.SG
                            yPos1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y01 ...
                                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                            yPos2(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y02 ...
                                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                        case appData.consts.fitTypes.twoDGaussian
                            yPos1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y0 ...
                                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                            yPos2(j) = yPos1(j);
                    end
%                     else
%                         yPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter ...
%                             * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
%                     end
                    val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
                end
                val = val*1e-3;
                if ( min(val) == max(val) )
                    for ( j= 1 : length(appData.analyze.totAppData)  )
                        val(j) = appData.analyze.totAppData{j}.save.picNo; %#ok<AGROW>
                    end
                end
                s1 = fitoptions('Method','NonlinearLeastSquares', 'Startpoint', [0.02 1.51 0 70 0]);
                s2 = fitoptions('Method','NonlinearLeastSquares', 'Startpoint', [0.01 2.06 0 100 0]);
                f1 = fittype('a*sin(2*pi*f*(x - p))+c+d*x', 'coefficients', {'a', 'c', 'd', 'f',  'p'}, 'independent', 'x', 'dependent', 'y', 'options', s1);
                f2 = fittype('a*sin(2*pi*f*(x - p))+c+d*x', 'coefficients', {'a', 'c', 'd', 'f',  'p'}, 'independent', 'x', 'dependent', 'y', 'options', s2);
                [out1.res, out1.gof, out1.output] = fit(val', yPos1', f1);
                [out2.res, out2.gof, out2.output] = fit(val', yPos2', f2);
                
                 [path, name, ext] = fileparts(appData.analyze.totAppData{1}.save.saveDir);
                 export2wsdlg({'mF=1:' 'mF=2:'}, {[name '_mF1'] [name '_mF2']}, {out1 out2});
                 
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '_mF1.fig']);
                plot(out1.res, 'r', val, yPos1, 'ob');     
                title(['mF=1, (' name ')'], 'interpreter', 'none');
                xlabel('time [ms]');
                ylabel('Y Position [mm]');
                legend({['mF=1, (' name ')'],['fit mF=1, (' name ')']},'interpreter', 'none');
                figure( 'FileName', [appData.analyze.totAppData{1}.save.saveDir '_mF2.fig']);
                plot(out2.res, 'b', val, yPos2, 'or');                
                title(['mF=2, (' name ')'], 'interpreter', 'none');
                xlabel('time [ms]');
                ylabel('Y Position [mm]');
                legend({['mF=2, (' name ')'], ['fit mF=2, (' name ')']},'interpreter', 'none');
                
%                 [path, name, ext] = fileparts(appData.analyze.totAppData{1}.save.saveDir);
%                 export2wsdlg({'mF=1:' 'mF=2:'}, {[name '_mF1'] [name '_mF2']}, {out1 out2});
                                    
            case appData.consts.availableAnalyzing.FFT
                fitType = appData.analyze.totAppData{1}.data.fitType;
                w = length(abs(appData.data.fits{fitType}.xData_k));
                data_k = zeros(length(appData.analyze.totAppData), w);
                k = appData.data.fits{fitType}.k;
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    data_k(j, :) = appData.data.fits{fitType}.xData_k;
                end
                figure('FileName', [appData.analyze.totAppData{1}.save.saveDir '-fft.fig']); 
                plot(k(round(w/2):w), sqrt(sum(abs(data_k(:, round(w/2):w)).^2,1)));
                
%                 [pic x0 y0] = appData.analyze.totAppData{1}.data.plots{appData.consts.plotTypes.absorption }.getPic();
%                 [h w] = size(pic);
%                 data_k = zeros(length(appData.analyze.totAppData), w);
%                 for ( j= 1 : length(appData.analyze.totAppData)  )
%                     [xData yData] = ...
%                         appData.analyze.totAppData{j}.data.plots{appData.consts.plotTypes.absorption }.getXYDataVectors(...
%                         appData.analyze.totAppData{j}.data.fits{ fitType }.xCenter, appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter, ...
%                         appData.analyze.totAppData{j}.options.avgWidth);
%                     [pic x0 y0] = appData.analyze.totAppData{j}.data.plots{appData.consts.plotTypes.absorption }.getPic();
%                     [h w] = size(pic);
%                     x = [1 : w];
%                     y = [1 : h];
%                     [xFit yFit] = appData.data.fits{appData.data.fitType}.getXYFitVectors(x+x0-1, y+y0-1);
%                     data = xData-xFit(1, :);
%                     dx = appData.analyze.totAppData{j}.consts.cameras{appData.analyze.totAppData{j}.options.cameraType}.xPixSz;
%                     x = dx*[-w/2:w/2-1]; %dx*[-Nx/2:Nx/2-1];
%                     dk = 2*pi/dx/w; %2*pi/dx/Nx;
%                     k = dk*[-w/2:w/2-1]; %dk*[-Nx/2:Nx/2-1];
%                     data_k(j, :)=fftshift(fft(fftshift(data)));
% %                     figure; plot(k, abs(data_k(j, :)));
%                 end
%                 figure('FileName', [appData.analyze.totAppData{1}.save.saveDir '-fft.fig']); 
%                 plot(k, sqrt(sum(abs(data_k).^2,1)));
                
            case appData.consts.availableAnalyzing.oneDstd
                fitType = appData.analyze.totAppData{1}.data.fitType;
                [pic x0 y0] = appData.analyze.totAppData{1}.data.plots{appData.consts.plotTypes.absorption }.getPic();
                [h w] = size(pic);
                data = zeros(length(appData.analyze.totAppData), w);
                fits = zeros(length(appData.analyze.totAppData), w);
                for ( j= 1 : length(appData.analyze.totAppData)  )
                    [xData yData] = ...
                        appData.analyze.totAppData{j}.data.plots{appData.consts.plotTypes.absorption }.getXYDataVectors(...
                        appData.analyze.totAppData{j}.data.fits{ fitType }.xCenter, appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter, ...
                        appData.analyze.totAppData{j}.options.avgWidth);
                    [pic x0 y0] = appData.analyze.totAppData{j}.data.plots{appData.consts.plotTypes.absorption }.getPic();
                    [h w] = size(pic);
                    x = [1 : w];
                    y = [1 : h];
                    [xFit yFit] = appData.analyze.totAppData{j}.data.fits{appData.data.fitType}.getXYFitVectors(x+x0-1, y+y0-1);
                    
                    data(j, :) = xData;
                    fits(j, :) = xFit(1,:);
                end
                figure('FileName', [appData.analyze.totAppData{1}.save.saveDir ' - data.fig']);
                imagesc(data);
                title('X Data');
                figure('FileName', [appData.analyze.totAppData{1}.save.saveDir ' - fits.fig']);
                imagesc(fits);
                title('X Fits');
                export2wsdlg({'Data:', 'Fits:'}, {'data', 'fits'}, {data, fits});
%                 figure('FileName', [appData.analyze.totAppData{1}.save.saveDir ' - std_1.fig']);
%                 plot(std(data, 1));
%                 title('std(data, 1)');
%                 figure('FileName', [appData.analyze.totAppData{1}.save.saveDir ' - std_2.fig']);
%                 plot(std(data, 1)./mean(data, 1));
%                 title('std(data, 1)./mean(data, 1)');
%                 figure('FileName', [appData.analyze.totAppData{1}.save.saveDir ' - std_3.fig']);
%                 plot(std(data, 1)./xFit(1, :));
%                 title('std(data, 1)./xFit(1, :)');
                
            case appData.consts.availableAnalyzing.g2
                [n, g2, dN2] = cloudstat(appData.analyze.totAppData, ...
                    appData.analyze.totAppData{1}.data.camera.xPixSz*1e6, ...
                    2*appData.analyze.totAppData{1}.options.avgWidth+1, ...
                    0, 0); % photonSN,normn);
                figure;
                imagesc(n);
                figure;
                imagesc(g2);
                figure;
                imagesc(dN2);
            otherwise
                errordlg({'Not a known Value in \"imaging.m/pbSaveToWorkspace_Callback\".' ['appData.analyze.currentAnalyzing(' num2str(i)  ...
                    ') is: ' num2str(appData.data.fitType)]},'Error', 'modal'); 
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReadPics_Callback(object, eventdata)
    if ( get(object, 'Value') == 0 )
        return;
    end
    appData.analyze.readDir = get(appData.ui.etReadDir, 'String');
    appData.analyze.totAppData = [];
    evalStr = get(appData.ui.etAnalyzePicNums, 'String');
    if strcmp(evalStr, 'all')
        if strcmp(computer, 'MACI64')
            files = dir([appData.analyze.readDir '/data-*.mat']);
        else
            files = dir([appData.analyze.readDir '\data-*.mat']);
        end
%         analyzePicNums = [1:length(files)];
        nums = zeros(1, length(files));
        for ( j = 1 : length(files) )
            dotIndex = find(files(j).name == '.');
            dashIndex = find(files(j).name == '-');
            if ( length(dashIndex) == 1 )
                nums(j) = str2double(files(j).name(dashIndex(1)+1 : dotIndex(end)-1));
            else
                nums(j) = str2double(files(j).name(dashIndex(1)+1 : dashIndex(2)-1));
            end
        end
        analyzePicNums = sort(nums);
        fullEval = 0;
    elseif ( evalStr(1) == 'f' )
        analyzePicNums = eval([ '[' evalStr(2:end)  ']' ]);
        fullEval = 1;
    else
        analyzePicNums = eval([ '[' evalStr  ']' ]);
        fullEval = 0;
    end
    if isempty(analyzePicNums)
        errordlg('Input must be an array','Error', 'modal');
    end
    totAppData = cell(1, length(analyzePicNums) );
    tmpIsReadPic = appData.analyze.isReadPic;
    appData.analyze.isReadPic = 1;
    set(appData.ui.tbReadPic, 'Value', appData.analyze.isReadPic);
    for ( i = 1 : length(analyzePicNums) )
        if ( get(object, 'Value') == 0 )
            break
        end
        num = analyzePicNums(i);
        set(appData.ui.etShowPicNo, 'String', num2str(num))
        drawnow;
        etShowPicNo_Callback(appData.ui.etShowPicNo, eventdata);
        
        totAppData{i} = appData;
        totAppData{i}.analyze = [];
        totAppData{i}.oldAppData = [];
        if ( fullEval == 0 )
            totAppData{i}.data.plots = appData.consts.plotTypes.plots;
            totAppData{i}.data.LVData = [];
            totAppData{i}.data.lastLVData = [];
            totAppData{i}.data.firstLVData = [];
        end
    end
    appData.analyze.totAppData = totAppData;
    appData.analyze.isReadPic = tmpIsReadPic;
    set(appData.ui.tbReadPic, 'Value', appData.analyze.isReadPic);
    set(object, 'Value', 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etShowPicNo_Callback(object, eventdata) 
    val = str2double(get(object, 'String'));
    if ( isnan(val) || val <= 0 || floor(val) ~= val )
        set(object, 'String', num2str(appData.analyze.showPicNo));
        errordlg('Input must be positive integer','Error', 'modal');
    else
        appData.analyze.showPicNo = val;
        tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sShowPicNo_Callback(object, eventdata) 
    val = get(object, 'Value');
    if ( val == 0 )
        if ( appData.analyze.showPicNo > 1 )
            appData.analyze.showPicNo = appData.analyze.showPicNo - 1;
        else
            return
        end
    elseif ( val == 2 )
        appData.analyze.showPicNo = appData.analyze.showPicNo + 1;
    end
    set(appData.ui.etShowPicNo, 'String', num2str(appData.analyze.showPicNo));
    set(object, 'Value', 1);
    tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReadPic_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.isReadPic = get(object, 'Value');
    
    if ( appData.analyze.isReadPic == 0 )
        return
    end
    
    % MAC version
    % change also in tcReadPics_Callback (slash <-> back-slash):
%      if strcmp(evalStr, 'all')
%         files = dir([appData.analyze.readDir '/data-*.mat']);
%         ...
%     end
    if strcmp(computer, 'MACI64')
        savedData = tbReadPic_MAC(appData);
        appData = createAppData(savedData, appData);
        appData = analyzeAndPlot(appData);
        return
    end

    comment = [];
    fileName = ls([ appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '-*.mat']);
    if ( size(fileName, 1) > 1 )
        fileName = strtrim(fileName(1, :));
    end
    if ( isempty(fileName) )
        fileName = ls([appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '.mat']);
        if ( isempty(fileName) )
            warndlg({'File doesnt exist:', [appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '.mat']}, 'Warning', 'modal');
            return
        end
    else        
        dotIndex = find(fileName == '.');
        dashIndex = find(fileName == '-');
%         comment = fileName(dashIndex(end):dotIndex-1);
        comment = fileName(dashIndex(2):dotIndex(end)-1);
    end
    
    load([appData.analyze.readDir '\' fileName], 'savedData');
    if ( ~isempty(comment) )
        savedData.save.commentStr = comment;
    end
    if (length(appData.data.fits) > length(savedData.data.fits) )    
        savedData.consts.fitTypes = appData.consts.fitTypes;
        for j=length(savedData.data.fits)+1 : length(appData.data.fits) 
            savedData.data.fits{j} = appData.consts.fitTypes.fits{j};
        end        
    end
    if (length(appData.consts.availableAnalyzing.str) > length(savedData.consts.availableAnalyzing.str) )
        savedData.consts.availableAnalyzing = appData.consts.availableAnalyzing;
%         for i=length(savedData.data.fits)+1 : length(appData.data.fits) 
%             savedData.data.fits{i} = appData.data.fits{i};
%         end        
    end
    appData = createAppData(savedData, appData);
    appData = analyzeAndPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etAnalyzePicNums_Callback(object, eventdata) %#ok<INUSD>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbOpenReadDir_Callback(object, eventdata)  %#ok<INUSL>
    dirName = uigetdir(get(appData.ui.etReadDir, 'String'));
    if ( dirName ~= 0 )
        set(appData.ui.etReadDir, 'String', dirName);
        etReadDir_Callback(appData.ui.etReadDir, eventdata)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etReadDir_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.readDir = get(object, 'String');
end

end
% end imaging function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = idsReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsMain}) ~= 1 && ...
%         strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsSecond}) ~= 1 )
%     warndlg('Trying to read IDS file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = prosilicaReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilica}) ~= 1 )
%     warndlg('Trying to read Prosilica file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = prosilicaCReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilicaC}) ~= 1 )
%     warndlg('Trying to read Prosilica-c file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% file=file(:,:,1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = andorReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.andor}) ~= 1)
%     warndlg('Trying to read ANdor file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% % file = imread(fileName);
% fid = fopen(fileName);
% file = fread(fid, [512 512], 'uint32');
% fclose(fid);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function onlyPlot(appData)
%
% Plot image and results
%
try
    plotImage(appData);
catch ME
    msgbox({ME.message, ME.cause, 'file:', ME.stack.file, 'name:', ME.stack.name, 'line', num2str([ME.stack(:).line])}, ...
        'Cannot plot data!!!', 'error', 'modal');
end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function appData = analyzeAndPlot(appData)
% Analyze the absorption image
avgWidth = appData.options.avgWidth;%str2double(get(appData.ui.etAvgWidth, 'String'));
if ~isfield(appData.consts, 'maxAvgWidth')
    appData.consts.maxAvgWidth = 8;
end
% i = avgWidth+2;
% for (i = avgWidth+2 : 2 : avgWidth+appData.consts.maxAvgWidth)
    try
        if ( appData.data.fits{appData.data.fitType}.atomsNo == -1  || ...
                (  strcmp(appData.consts.runVer, 'offline') && appData.options.plotSetting == appData.consts.plotSetting.last ))
            appData = appData.data.fits{appData.data.fitType}.analyze(appData);
            set(appData.ui.etAvgWidth, 'String', num2str(avgWidth));
            appData.options.avgWidth = avgWidth;
%             break;
        end
    catch ME
%         if ( i == avgWidth+8 )
            msgbox({ME.message, ME.cause, 'file:', ME.stack.file, 'name:', ME.stack.name, 'line', num2str([ME.stack(:).line])}, ...
                'Cannot analyze data!!!', 'error', 'modal');
            appData.data.fitType = appData.consts.fitTypes.onlyMaximum;
            set(appData.ui.pmFitType, 'Value', appData.data.fitType);
            appData = appData.data.fits{appData.data.fitType}.analyze(appData);
%         else        
%             set(appData.ui.etAvgWidth, 'String', num2str(i));
%             appData.options.avgWidth = i;
% 
%             tmpFitType = appData.data.fitType;
%             appData.data.fitType = appData.consts.fitTypes.onlyMaximum;
%             set(appData.ui.pmFitType, 'Value', appData.data.fitType);
%             appData = appData.data.fits{appData.data.fitType}.analyze(appData);     
%             onlyPlot(appData);
%             appData.data.fitType = tmpFitType;
%             set(appData.ui.pmFitType, 'Value', appData.data.fitType);
%         end
    end
% end

if  appData.options.doPlot == 1
    % Plot image and results
    onlyPlot(appData);
end

%
% Saving 
%
if ( appData.save.isSave == 1 )
    savedData = createSavedData(appData);  %#ok<NASGU>
    save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);
%      save(['\\analysis\RawData\imaging-data.mat'], 'savedData', appData.consts.saveVersion);
    
%     if ( ~isempty(appData.consts.LVFile) && strcmp(appData.consts.runVer, 'online') )
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']); %#ok<NASGU>
%         if ( s == 0)
%             warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%         end
%     end
    if ( strcmp(appData.consts.runVer, 'online') )
        ret = appData.data.lastLVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
        if ( ret == 0)
            warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
        end
    end
   
    set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
    appData.save.picNo = appData.save.picNo + 1;
    set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    
% elseif ( appData.analyze.isReadPic == 1 )
%     savedData = createSavedData(appData); 
%     save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);

end
% if appData.data.isLastLVData == 1
%     appData.data.isLastLVData = 0;
%     set(appData.ui.tbLoop, 'Value', 0);
%     tbLoop_Callback(appData.ui.tbLoop, [])
%     
%     appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
% end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function appData = updateROI(appData)
% [pic x0 y0] = appData.data.plots{appData.data.plotType}.getAnalysisPic(appData);
[pic x0 y0] = appData.data.plots{appData.consts.plotTypes.absorption}.getAnalysisPic(appData);
for ( i = 1 : length(appData.data.fits) )
    fitObj = appData.data.fits{i};
    
    if ( fitObj.atomsNo ~= -1 )
       [fitObj.ROILeft fitObj.ROITop fitObj.ROIRight fitObj.ROIBottom] = appData.data.ROITypes{appData.data.ROIUnits}.getROICoords(appData, fitObj);
       fitObj.atomsNo = appData.options.calcs{appData.options.calcAtomsNo}.calcAtomsNo(appData, fitObj, pic, ...
           [fitObj.ROILeft : fitObj.ROIRight] - x0+1, [fitObj.ROITop : fitObj.ROIBottom] - y0+1);  %#ok<*NBRAK>
       appData.data.fits{i} = fitObj;
    end
end
appData = appData.data.plots{appData.consts.plotTypes.ROI}.setPic(appData, pic);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedData = createSavedData(appData)
savedData.consts = appData.consts;
savedData.data = appData.data;
savedData.options = appData.options;
savedData.save = appData.save;

% if ( appData.analyze.isReadPic == 0 )
%     savedData.data.picNo = appData.save.picNo;
%     savedData.data.saveParam = appData.save.saveParam;
%     savedData.data.saveParamVal = appData.save.saveParamVal;
% else
%     savedData.data.picNo = appData.data.picNo;
%     savedData.data.saveParam = appData.data.saveParam;
%     savedData.data.saveParamVal = appData.data.saveParamVal;
% end

savedData.atoms = uint16(savedData.data.plots{appData.consts.plotTypes.withAtoms}.getPic());
savedData.back = uint16(savedData.data.plots{appData.consts.plotTypes.withoutAtoms}.getPic());
savedData.dark = uint16(appData.data.dark);
savedData.data.plots = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newAppData = createAppData(savedData, appData) 
    newAppData = appData;
%     if ( isfield(appData, 'oldAppData') )
%         newAppData.oldAppData = appData.oldAppData;
%     else
%         newAppData.oldAppData = appData;
%     end

%     newAppData.consts = savedData.consts;
    newAppData.data = savedData.data;
    newAppData.options = savedData.options;
    newAppData.options.doPlot = appData.options.doPlot; %Fixes the fact that the saved data has overwrriten the doPlot (updatePlot) variable.
    newAppData.save = savedData.save; 
    
    %
    % Create absorption image
    %
    atoms = double(savedData.atoms);
    back = double(savedData.back);
    newAppData.data.dark = double(savedData.dark);

    atoms = atoms - newAppData.data.dark;                                           % subtract the dark background from the atom pic
    atoms2 = atoms .* ( ~(atoms<0));                                                                                % set all pixelvalues<0 to 0
    back =  back - newAppData.data.dark;                                              % subtract the dark background from the background pic
    back2 = back .* ( ~(back<0));                                                                                      % set all pixelvalues<0 to 0
    absorption = log( (back2 + 1)./ (atoms2 + 1)  );
    
    newAppData.data.plots = newAppData.consts.plotTypes.plots;
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.withAtoms}.setPic(newAppData, atoms);
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.withoutAtoms}.setPic(newAppData, back);
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.absorption}.setPic(newAppData, absorption);
%     newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);

    %
    % Set Pic data in the figure
    %
    
    % TODO: add option for saved or previos plot settings
    if ~isfield(appData.consts, 'plotSetting')
        appData.options.plotSetting = get(newAppData.ui.pmPlotSetting, 'Value');
        appData.consts.plotSetting.str = {'Default Setting', 'Last Setting'};
        appData.consts.plotSetting.defaults = 1;
        appData.consts.plotSetting.last = 2;
        appData.consts.plotSetting.default = 2;
    end
    switch appData.options.plotSetting
        case appData.consts.plotSetting.defaults % saved settings
            set(newAppData.ui.pmFitType, 'Value', newAppData.data.fitType);
            set(newAppData.ui.pmPlotType, 'Value', newAppData.data.plotType);
            set(newAppData.ui.pmROIUnits, 'Value', newAppData.data.ROIUnits);
            set(newAppData.ui.etROISizeX, 'String', num2str(newAppData.data.ROISizeX));
            set(newAppData.ui.etROISizeY, 'String', num2str(newAppData.data.ROISizeY));
            set(newAppData.ui.etROICenterX, 'String', num2str(newAppData.data.ROICenterX));
            set(newAppData.ui.etROICenterY, 'String', num2str(newAppData.data.ROICenterY));
            
            set(newAppData.ui.pmCalcAtomsNo, 'Value', newAppData.options.calcAtomsNo);
            set(newAppData.ui.etAvgWidth, 'String', num2str(newAppData.options.avgWidth));

%             set(newAppData.ui.etSaveDir, 'String', newAppData.save.saveDir);
            
        case appData.consts.plotSetting.last
            newAppData.data.fitType = get(newAppData.ui.pmFitType, 'Value');
            newAppData.data.plotType = get(newAppData.ui.pmPlotType, 'Value');
            newAppData.data.ROIUnits = get(newAppData.ui.pmROIUnits, 'Value');
            newAppData.data.ROISizeX = str2double(get(newAppData.ui.etROISizeX, 'String'));
            newAppData.data.ROISizeY = str2double(get(newAppData.ui.etROISizeY, 'String'));
            newAppData.data.ROICenterX = str2double(get(newAppData.ui.etROICenterX, 'String'));
            newAppData.data.ROICenterY = str2double(get(newAppData.ui.etROICenterY, 'String'));
            
%     newAppData.data.fitType = appData.data.fitType;
%     newAppData.data.plotType = appData.data.plotType;
%     newAppData.data.ROIUnits = appData.data.ROIUnits;
%     newAppData.data.ROISizeX = appData.data.ROISizeX;
%     newAppData.data.ROISizeY = appData.data.ROISizeY;
%     newAppData.data.ROICenterX = appData.data.ROICenterX;
%     newAppData.data.ROICenterY = appData.data.ROICenterY;

            newAppData.options.calcAtomsNo = get(newAppData.ui.pmCalcAtomsNo, 'Value');
            newAppData.options.avgWidth = str2double(get(newAppData.ui.etAvgWidth, 'String'));
            
            newAppData.data.fits = appData.consts.fitTypes.fits;

            newAppData.save.saveDir = get(newAppData.ui.etSaveDir, 'String');

    end
    tmpPlotType = newAppData.data.plotType;
    newAppData.data.plotType = newAppData.consts.plotTypes.absorption;
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);
    newAppData.data.plotType = tmpPlotType;
%     newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);
    
    set(newAppData.ui.pmCameraType, 'Value', newAppData.options.cameraType);
    set(newAppData.ui.etDetuning, 'String', num2str(newAppData.options.detuning));
    set(newAppData.ui.etAvgWidth, 'String', num2str(newAppData.options.avgWidth));
    newAppData.options.plotSetting = appData.options.plotSetting;
    set(newAppData.ui.pmPlotSetting, 'Value', newAppData.options.plotSetting);

    set(newAppData.ui.etSaveDir, 'String', newAppData.save.saveDir);
    set(newAppData.ui.etComment, 'String', newAppData.save.commentStr(2:end));
    set(newAppData.ui.etPicNo, 'String', num2str(newAppData.save.picNo));
    newAppData.save.isSave = appData.save.isSave;
    set(newAppData.ui.tbSave, 'Value', newAppData.save.isSave);
    set(newAppData.ui.pmSaveParam, 'Value', newAppData.save.saveParam);
    set(newAppData.ui.etParamVal, 'String', num2str(newAppData.save.saveParamVal));

    newAppData.consts.winName = appData.consts.winName;
    set(appData.ui.win, 'Name', [newAppData.consts.winName num2str(newAppData.save.picNo) newAppData.save.commentStr]);
    
    newAppData.consts.runVer = 'offline';
end

