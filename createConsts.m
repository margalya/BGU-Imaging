
function appData = createConsts(appData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defaults

appData.consts.plotTypes.default = 1;
appData.consts.ROIUnits.default = 2;
appData.consts.ROIUnits.defaultSizeX = 0.5;
appData.consts.ROIUnits.defaultSizeY = 0.5;
appData.consts.calcAtomsNo.default = 1;
appData.consts.plotSetting.default = 1;
appData.consts.fitTypes.default = 2;%12;
appData.consts.saveParams.default = 1;
appData.consts.saveParamValDefault = 0;

appData.consts.defaultAvgWidth = 2; %on each side
appData.consts.maxAvgWidth = 8;
appData.save.defaultDir = ['F:\My Documents\Experimental\' datestr(now, 29)];%'C:\Documents and Settings\broot\Desktop\shimi';
appData.consts.defaultStrLVFile_Save = 'F:\My Documents\Experimental\LVData_Save.txt'; %'D:\My Documents\MATLAB\lv data.txt';
appData.consts.defaultStrLVFile_Load = 'F:\My Documents\Experimental\LVData_Load.txt'; %'D:\My Documents\MATLAB\lv data.txt';
appData.consts.defaultDetuning = 0;
appData.consts.defaultDoPlot = 1;

appData.consts.winXPos = 1;
appData.consts.winYPos = 65;
% appData.consts.ftpAddress = '132.72.8.2';
% appData.consts.ftpDir = 'LabViewProjects/Ramp_Integration/Interface39.5/TXT/';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loops
appData.consts.availableLoops.str = {'Gen. Loop' 'TOF', 'LT' 'SG'};%, 'Heating', 'SG'};
appData.consts.availableLoops.generalLoop = 1;
appData.consts.availableLoops.TOF = 2;
appData.consts.availableLoops.LT = 3;
% appData.consts.availableLoops.heating = 4;
appData.consts.availableLoops.SG = 4;
appData.consts.availableLoops.createFncs = {@GeneralLoop.create, @TOF.create, @LT.create, @SternGerlach.create};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loops defaults
appData.consts.loops.iterationsStr = {'Iterate Measurement' 'Iterate Loop' 'Random Iterations'};
appData.consts.loops.options = struct('Interpreter', 'tex', 'WindowStyle', 'normal', 'Resize', 'off');

appData.consts.loops.TOF.noIterations = '1';
appData.consts.loops.TOF.TOFTimes = '5:2:13';

appData.consts.loops.LT.noIterations = '1';
appData.consts.loops.LT.LTTimes = '[0:1:20]*1e3';

appData.consts.loops.SG.noIterations = '1';
appData.consts.loops.SG.SGTimes = '[0:1:20]*1e3';
appData.consts.loops.SG.RFRampNo = 15;
% appData.consts.loops.SG.RFRampNo = 18;

appData.consts.loops.GenLoop.saveFolder = 'F:\My Documents\Experimental\Loops';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cameras

appData.consts.cameraTypes.str = {'Andor', 'IDS - main', 'IDS - second', 'prosilica',  'prosilica-c'};
appData.consts.cameraTypes.andor = 1;
appData.consts.cameraTypes.idsMain = 2;
appData.consts.cameraTypes.idsSecond = 3;
appData.consts.cameraTypes.prosilica = 4;
appData.consts.cameraTypes.prosilicaC= 5;
appData.consts.cameraTypes.default = 4;

appData.consts.cameras{appData.consts.cameraTypes.andor}.string = 'Andor';
appData.consts.cameras{appData.consts.cameraTypes.andor}.dir = 'C:\Documents and Settings\broot\Desktop\shimi';
appData.consts.cameras{appData.consts.cameraTypes.andor}.fileName = 'tmpPic';
appData.consts.cameras{appData.consts.cameraTypes.andor}.fileFormat = 'i32';
appData.consts.cameras{appData.consts.cameraTypes.andor}.fileReadFunction = @andorReadFunction;
appData.consts.cameras{appData.consts.cameraTypes.andor}.darkPicStr = 'andorDark.bmp';
appData.consts.cameras{appData.consts.cameraTypes.andor}.magnification = 500/150;%3/5;
appData.consts.cameras{appData.consts.cameraTypes.andor}.xPixSz = ...
    16e-6 / appData.consts.cameras{appData.consts.cameraTypes.andor}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.andor}.yPixSz = ...
    16e-6 / appData.consts.cameras{appData.consts.cameraTypes.andor}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.andor}.width = 512;
appData.consts.cameras{appData.consts.cameraTypes.andor}.height = 512;
appData.consts.cameras{appData.consts.cameraTypes.andor}.rotate = 90;
appData.consts.cameras{appData.consts.cameraTypes.andor}.bits = 14;
appData.consts.cameras{appData.consts.cameraTypes.andor}.chipStart = 1;
appData.consts.cameras{appData.consts.cameraTypes.andor}.firstImageNo = 1;
appData.consts.cameras{appData.consts.cameraTypes.andor}.secondImageNo = 2;


appData.consts.cameras{appData.consts.cameraTypes.idsMain}.string = 'IDS - main';
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.dir =  'C:\Program Files\IDS\uEye\Samples'; %'D:\My Documents\MATLAB\imaging v4.3';%
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.fileName = 'uEye_Image_';
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.fileFormat = 'bmp';
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.fileReadFunction = @idsReadFunction;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.darkPicStr = 'dark.bmp';
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.magnification = 300/200;%100/300;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.xPixSz = ...
    6e-6 / appData.consts.cameras{appData.consts.cameraTypes.idsMain}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.yPixSz = ...
    6e-6 / appData.consts.cameras{appData.consts.cameraTypes.idsMain}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.width = 480;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.height = 752;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.rotate = 90;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.bits = 8;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.chipStart = 40;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.firstImageNo = 1;
appData.consts.cameras{appData.consts.cameraTypes.idsMain}.secondImageNo = 2;
% consts.cameras{consts.cameraTypes.ids} = ids;

appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.string = 'IDS - second';
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.dir = 'C:\Program Files\IDS\uEye\Samples';%'F:\Jonathan\Documents\MATLAB\';
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.fileName = 'uEye_Image_';
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.fileFormat = 'bmp';
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.fileReadFunction = @idsReadFunction;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.darkPicStr = 'dark.bmp';
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.magnification = 1/2.55;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.xPixSz = ...
    6e-6 / appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.yPixSz = ...
    6e-6 / appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.width = 480;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.height = 752;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.rotate = 90;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.bits = 8;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.chipStart = 1;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.firstImageNo = 1;
appData.consts.cameras{appData.consts.cameraTypes.idsSecond}.secondImageNo = 2;
% consts.cameras{consts.cameraTypes.ids} = ids;

appData.consts.cameras{appData.consts.cameraTypes.prosilica}.string = 'prosilica';
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.dir = 'C:\Program Files\Prosilica';
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.fileName = 'snap';
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.fileFormat = 'tiff';
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.fileReadFunction = @prosilicaReadFunction;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.darkPicStr = 'dark.bmp';
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.magnification = 300/200;%100/300;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.xPixSz = ...
    3.45e-6 / appData.consts.cameras{appData.consts.cameraTypes.prosilica}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.yPixSz = ...
    3.45e-6 / appData.consts.cameras{appData.consts.cameraTypes.prosilica}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.width = 2448;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.height = 1050;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.rotate = 0;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.bits = 16;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.chipStart =102;%82 ;%was 131 before hight calibration
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.firstImageNo = 0;
appData.consts.cameras{appData.consts.cameraTypes.prosilica}.secondImageNo = 1;

appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.string = 'prosilica-c';
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.dir = 'C:\Documents and Settings\broot\Desktop\shimi\prosilica';
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.fileName = 'snap';
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.fileFormat = 'tiff';
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.fileReadFunction = @prosilicaCReadFunction;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.darkPicStr = 'dark.bmp';
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.magnification = 3.27;%100/300;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.xPixSz = ...
    3.45e-6 / appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.magnification;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.yPixSz = ...
    3.45e-6 / appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.magnification;
% appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.width = 480;
% appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.height = 752;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.rotate = 90;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.bits = 16;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.chipStart = 1;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.firstImageNo = 1;
appData.consts.cameras{appData.consts.cameraTypes.prosilicaC}.secondImageNo = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

appData.consts.calcAtomsNo.str = {'Real', 'Theoretical', 'Theoretical - Full'};
appData.consts.calcAtomsNo.real = 1;
appData.consts.calcAtomsNo.theoretical = 2;
appData.consts.calcAtomsNo.theoreticalFull = 3;
appData.consts.calcAtomsNo.calcs = { CalcReal CalcTheoretical CalcTheoreticalFull};%, Theoretical};
appData.consts.plotSetting.str = {'Default Setting', 'Last Setting'};
appData.consts.plotSetting.defaults = 1;
appData.consts.plotSetting.last = 2;

appData.consts.fitTypes.str = {'XY Cut', 'Only Maximum', '1D Gaussian', '1D Gaussian (Only Y)', '2-1D Gaussian (Only Y)', '2D Gaussian', ...
    '1D TF', '1D TF (Only Y)', '2D TF', '1D BiModal', '2D BiModal', 'Stern-Gerlach', 'FFT', 'Fringes (only Y)'};%, '2 1D Gaussians'};
appData.consts.fitTypes.XYCut = 1;
appData.consts.fitTypes.onlyMaximum = 2;
appData.consts.fitTypes.oneDGaussian = 3;
appData.consts.fitTypes.oneDGaussianOnlyY = 4;
appData.consts.fitTypes.twoOneDGaussianOnlyY = 5;
appData.consts.fitTypes.twoDGaussian = 6;
appData.consts.fitTypes.oneDTF = 7;
appData.consts.fitTypes.oneDTFOnlyY = 8;
appData.consts.fitTypes.twoDTF = 9;
appData.consts.fitTypes.oneDBiModal = 10;
appData.consts.fitTypes.twoDBiModal = 11;
appData.consts.fitTypes.SG = 12;
appData.consts.fitTypes.FFT = 13;
appData.consts.fitTypes.fringesY = 14;
appData.consts.fitTypes.fits = {FitXYCut, FitOnlyMax, Fit1DGaussian, Fit1DGaussianOnlyY, ...
    Fit21DGaussianOnlyY, Fit2DGaussian, FitThomasFermi1D, FitThomasFermi1DOnlyY, FitThomasFermi2D, ...
    FitBiModal1D, FitBiModal2D, FitSternGerlach, FitFFT, FitFringesY};%, Fit21DGaussian};

appData.consts.plotTypes.str = {'Absorption', 'ROI', 'With Atoms', 'Without Atoms'};
appData.consts.plotTypes.absorption = 1;
appData.consts.plotTypes.ROI = 2;
appData.consts.plotTypes.withAtoms = 3;
appData.consts.plotTypes.withoutAtoms = 4;
appData.consts.plotTypes.plots = {Absorption, ROI, WithAtoms, WithoutAtoms};

appData.consts.ROIUnits.str = {'Sigma (Sx Sy)', 'mm (Sx Sy)', 'Size [mm] (Sx Sy Cx Cy)'};
appData.consts.ROIUnits.sigma = 1;
appData.consts.ROIUnits.mm = 2;
appData.consts.ROIUnits.size = 3;
appData.consts.ROIUnits.ROITypes = {Sigma, MM, Size};

% appData.consts.availableMonitoring.str = {'Atoms Num.', 'X Position', 'Y Position'}; % when adding, change appData.monitoring.monitoringData size
% appData.consts.availableMonitoring.atomNum = 1;
% appData.consts.availableMonitoring.xPos = 2;
% appData.consts.availableMonitoring.yPos = 3;

appData.consts.saveParams.str = {'Other...', 'TOF [ms]', 'Dark Time [ms]', 'X-Bias', 'RF freq [MHz]','Osc time [ms]', 'Other Param'};
appData.consts.saveParams.other = 1;
appData.consts.saveParams.TOF = 2;
appData.consts.saveParams.darkTime = 3;
appData.consts.saveParams.XBias = 4;
appData.consts.saveParams.RFfreq = 5;
appData.consts.saveParams.OscTime = 6;
appData.consts.saveParams.otherParam = 7; %ALWAYS the last
appData.consts.saveOtherParamStr = '';
appData.consts.commentStr = '';

appData.consts.availableAnalyzing.str = {'Temperature', 'Heating', 'Gravity', 'Life Time (1 exp)', 'Life Time (2 exp)', 'Damped Sine (y)', ...
    'Atom No', 'OD', 'X Position', 'Y Position', 'Size X', 'Size Y', 'Delta_y', 'Pic Mean','SG', 'mF1', 'SG Y Position', 'FFT', '1D STD', 'g2', 'lambda', 'phi', ...
    'Visibility'};
appData.consts.availableAnalyzing.temperature = 1;
appData.consts.availableAnalyzing.heating = 2;
appData.consts.availableAnalyzing.gravity = 3;
appData.consts.availableAnalyzing.lifeTime1 = 4;
appData.consts.availableAnalyzing.lifeTime2 = 5;
appData.consts.availableAnalyzing.dampedSine = 6;
appData.consts.availableAnalyzing.atomNo = 7;
appData.consts.availableAnalyzing.OD = 8;
appData.consts.availableAnalyzing.xPos = 9;
appData.consts.availableAnalyzing.yPos = 10;
appData.consts.availableAnalyzing.sizeX = 11;
appData.consts.availableAnalyzing.sizeY = 12;
appData.consts.availableAnalyzing.deltaY_2 = 13;
appData.consts.availableAnalyzing.picMean = 14;
appData.consts.availableAnalyzing.SG = 15;
appData.consts.availableAnalyzing.mF1 = 16;
appData.consts.availableAnalyzing.SGyPos = 17;
appData.consts.availableAnalyzing.FFT = 18;
appData.consts.availableAnalyzing.oneDstd = 19;
appData.consts.availableAnalyzing.g2 = 20;
appData.consts.availableAnalyzing.lambda = 21;
appData.consts.availableAnalyzing.phi = 22;
appData.consts.availableAnalyzing.visibility = 23;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file = idsReadFunction(appData, num)
if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsMain}) ~= 1 && ...
        strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsSecond}) ~= 1 )
    warndlg('Trying to read IDS file.', 'Warning', 'nonmodal');
end
fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
file = imread(fileName, appData.data.camera.fileFormat);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file = prosilicaReadFunction(appData, num)
if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilica}) ~= 1 )
    warndlg('Trying to read Prosilica file.', 'Warning', 'nonmodal');
end
fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
file = imread(fileName, appData.data.camera.fileFormat)/2^4;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file = prosilicaCReadFunction(appData, num)
if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilicaC}) ~= 1 )
    warndlg('Trying to read Prosilica-c file.', 'Warning', 'nonmodal');
end
fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
file = imread(fileName, appData.data.camera.fileFormat);
file=file(:,:,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file = andorReadFunction(appData, num)
if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.andor}) ~= 1)
    warndlg('Trying to read ANdor file.', 'Warning', 'nonmodal');
end
fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName);
fid = fopen(fileName);
file = fread(fid, [512 512], 'uint32');
fclose(fid);
end


end



