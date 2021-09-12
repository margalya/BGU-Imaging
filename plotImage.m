
function plotImage(appData)

lineColor = 0.85;
colors = ['r', 'k', 'g', 'c'];

% setWinName(appData);
    
%
% plot the main image
%
% [pic, xFit, yFit] = appData.data.fits{appData.data.fitType}.getPicData(appData);
% [xData, yData] = appData.data.plots{appData.data.plotType}.getXYData(appData);
% [h w] = size(pic);
% x = [1 : w];
% y = [1 : h];
[pic x0 y0] = appData.data.plots{appData.data.plotType}.getPic();
pic = appData.data.plots{appData.data.plotType}.normalizePic(appData, pic);
% pic = appData.data.fits{appData.data.fitType}.normalizePic(pic);
[h w] = size(pic);
x = [1 : w];
y = [1 : h];
chipStart = appData.data.camera.chipStart;
% [xCenter yCenter] = appData.data.ROITypes{appData.data.ROIUnits}.getCenter(appData, appData.data.fits{appData.data.fitType});
%            x0 = fitObj.xCenter; %TODO: round, min max
%            y0 = fitObj.yCenter;
xCenter = appData.data.fits{appData.data.fitType}.xCenter;
yCenter = appData.data.fits{appData.data.fitType}.yCenter;
xCenter = max(xCenter, x0);
yCenter = max(yCenter, y0);
xCenter = min(xCenter, x0+w-1-1);
yCenter = min(yCenter, y0+h-1-1);
xSz = round(appData.data.fits{appData.data.fitType}.xUnitSize)*2;
ySz = round(appData.data.fits{appData.data.fitType}.yUnitSize)*2; 
if appData.data.fitType == appData.consts.fitTypes.onlyMaximum
    xSz = min(xCenter-x0-10, w-(xCenter-x0)-10);%round(w/2-10);
    ySz = min(yCenter-y0-10, h-(yCenter-y0)-10);%round(h/2-10);
else
    xSz = min(xSz, round(w/2-10));
    ySz = min(ySz, round(h/2-10));
end
% xSz = max(xCenter-x0+1-xSz, 1);
% ySz = max(yCenter-y0+1-ySz, 1);
% xSz = min(xCenter-x0+1+xSz, w);
% ySz = min(yCenter-y0+1+ySz, h);
[xFit yFit] = appData.data.fits{appData.data.fitType}.getXYFitVectors(x+x0-1, y+y0-1);
[xData yData] = appData.data.plots{appData.data.plotType}.getXYDataVectors(xCenter, yCenter, appData.options.avgWidth);
% pic( [yCenter : yCenter+1] -y0+1, :) = ones(2, w) * lineColor;  % a line at the center (x axis)
% pic( [yCenter : yCenter+1] -y0+1, [1:xCenter-x0+1-xSz xCenter-x0+1+xSz:w]) = ones(2, w-2*xSz+1) * lineColor;
% pic(:, [xCenter : xCenter+1] -x0+1 ) = ones(h, 2) * lineColor; % a line at the center (y axis)
% pic([1:yCenter-y0+1-ySz yCenter-y0+1+ySz:h], [xCenter : xCenter+1] -x0+1 ) = ones(h-2*ySz+1, 2) * lineColor;
pic = appData.data.plots{appData.data.plotType}.createSquare(appData, pic);

appData.data.imageWidth = round(appData.consts.maxplotSize*(w / h));
appData.data.imageHeight = appData.consts.maxplotSize;
if ( appData.data.imageWidth > appData.consts.maxplotSize )
    appData.data.imageWidth = appData.consts.maxplotSize;
    appData.data.imageHeight = round(appData.consts.maxplotSize*( h / w));
end
set(appData.ui.plot, 'Position', [5 5 appData.data.imageWidth appData.data.imageHeight]);
set(appData.ui.xPlot, 'Position', [5 5+appData.data.imageHeight+appData.consts.strHeight appData.data.imageWidth appData.consts.xyPlotsHeight]);
set(appData.ui.yPlot, 'Position', [5+appData.data.imageWidth+appData.consts.strHeight*1.5 5 appData.consts.xyPlotsHeight appData.data.imageHeight]);

figure(appData.ui.win);
set(appData.ui.win,'CurrentAxes',appData.ui.plot);
colormap(jet(256));
% image( ([x(1) x(end)]+x0-1)*appData.data.camera.xPixSz * 1000, ...
%     ([y(1) y(end)]+y0-1-chipStart-1)*appData.data.camera.yPixSz * 1000, pic*256);
image( ([x(1) x(end)]-1)*appData.data.camera.xPixSz * 1000, ...
    ([y(1) y(end)]+y0-1-chipStart-1)*appData.data.camera.yPixSz * 1000, pic*256);
set( appData.ui.plot, 'XAxisLocation', 'top');
set( appData.ui.plot, 'YAxisLocation', 'right');

%
% plot x plot
%
figure(appData.ui.win);
set(appData.ui.win,'CurrentAxes',appData.ui.xPlot);
plot((x+x0-1)*appData.data.camera.xPixSz * 1000, xData, 'b');
hold on
% create and plot the xFit vector
if ( length(xFit) == length(x) )
    for i = 1 : size(xFit, 1)
        plot((x+x0-1)*appData.data.camera.xPixSz * 1000, xFit(i, :), colors(i));
    end
end
hold off
set( appData.ui.xPlot, 'XAxisLocation', 'top');
set( appData.ui.xPlot, 'YAxisLocation', 'right');
xlabel(appData.ui.xPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
ylabel(appData.ui.xPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);
xtick = get(appData.ui.plot, 'XTick');
set(appData.ui.xPlot, 'XTick', xtick);%/(appData.data.camera.xPixSz * 1000)-xFit(1));%(ytick/(appData.data.camera.yPixSz* 1000)-yFit(1)+appData.data.camera.chipStart)
set(appData.ui.xPlot, 'XTickLabel', []);
set(appData.ui.xPlot, 'XLim', ([x(1) x(end)]+x0-1)*appData.data.camera.xPixSz * 1000);%[1 width]);
% ylim = get(appData.ui.xPlot, 'YLim');
set(appData.ui.xPlot, 'YLim', [min([xData yData]) max([xData yData])]);%[min([yData yFit 0]) ylim(2)]);

%
% plot y plot
%
figure(appData.ui.win);
set(appData.ui.win,'CurrentAxes',appData.ui.yPlot);
% plot(xData, fliplr(y), 'b');
plot(yData, fliplr(y-y0+1+chipStart+1)*appData.data.camera.yPixSz * 1000, 'b');
hold on
% create and plot they Fit vector
if ( length(yFit) == length(y) )
%     plot(xFit, fliplr(y), 'r');
    for i = 1 : size(yFit, 1)
%         plot((x+x0-1)*appData.data.camera.xPixSz * 1000, xFit(i, :), colors(i));
        plot(yFit(i, :), fliplr(y-y0+1+chipStart+1)*appData.data.camera.yPixSz * 1000,  colors(i));
    end
end
hold off
set( appData.ui.yPlot, 'XAxisLocation', 'top');
set( appData.ui.yPlot, 'YAxisLocation', 'right');
ylabel(appData.ui.yPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
xlabel(appData.ui.yPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);
ytick = get(appData.ui.plot, 'YTick');
% set(appData.ui.yPlot, 'YTick', fliplr(ytick));%fliplr(length(yFit)-(ytick/(appData.data.camera.yPixSz* 1000)-yFit(1)+appData.data.camera.chipStart)));
set(appData.ui.yPlot, 'YTickLabel', []);
set(appData.ui.yPlot, 'YLim', ([y(1) y(end)]-y0+1+chipStart+1)*appData.data.camera.yPixSz * 1000);%[1 length(yFit)]);%yFit(end)-yFit(1)]);
% xlim = get(appData.ui.yPlot, 'XLim');
set(appData.ui.yPlot, 'XLim', [min([xData yData]) max([xData yData])]);
set(appData.ui.yPlot, 'YTick', y(end)*appData.data.camera.yPixSz * 1000 - fliplr(ytick));


%
% plot results
%
figure(appData.ui.win);
set(appData.ui.win,'CurrentAxes',appData.ui.tmp);
cla(appData.ui.tmp, 'reset');
set(appData.ui.tmp, 'XLim', [0 1]);
set(appData.ui.tmp, 'YLim', [0 1]);
appData.data.fits{appData.data.fitType}.plotFitResults(appData);

% print(appData.ui.win, 'D:\My Documents\Documents\PhD and Fellowships\PhD Research Proposal\pics\MOT_analysis.eps');
% print('-depsc2', '-opengl', ['-f' num2str(appData.ui.win)], '-r864', 'D:\My Documents\Documents\PhD and Fellowships\PhD Research Proposal\pics\MOT_analysis.eps');
assignin('base','mainPlot',appData.ui.plot)
% assignin('base','xPlot',appData.ui.xPlot)
assignin('base','yPlot',appData.ui.yPlot)
