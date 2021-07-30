%% Paul_LH_Radon_FigureX.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/21/2021
%Date of Last Update: 7/21/2021
%Update History:
%PE 7/21/2021 - Created
%--------------------------------------
%Purpose: Puts together a tri-panel-plot of FFT'd Rossby Waves
%Inputs: SLA, Average Eddy Tracks
%Outputs: One figure, 3 columns, 1 row (Full/Half/Local)
%--------------------------------------
tic
titlestring = "Ernst-RadonEx-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
load("JetWhiteCenter.mat")
addpath(strcat(basepath, 'FUNCTIONS'));
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
%for full years
% halfyearsN = [2, 7, 11, 19, 21, 27];
% localyearsN = [5, 6, 12, 18];
% fullyearsN = [1, 3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
%     22, 23, 24, 25, 26];
%for individual years
halfyearsN = [2];
localyearsN = [6];
fullyearsN = [14];
latlonbounds = [8.1 7.9 79.8 49.4];
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
load('SLAs.mat', 'SLAFinal', 'names4later', 'X', 'Y')

%% Process SLA Averages Across Space and Time
%finding bounds
NLp = nearestpoint(latlonbounds(1), Y);
SLp = nearestpoint(latlonbounds(2), Y);
ELp = nearestpoint(latlonbounds(3), X);
WLp = nearestpoint(latlonbounds(4), X);
Xp = X(WLp:ELp); Yp = Y(SLp:NLp);
SLAforFFT = cell(1,length(years));
%Average SLA across the appropriate bounds
for i = 1:length(years)
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        SLAforFFT{1,i}(:,j) = nanmean(SLAFinal{i,j}(WLp:ELp,SLp:NLp),2).*100;
    end
end

%% Experimental Radon Usage (Example Years)
rados = cell(1,length(years));
datos = cell(1,length(years));
for i = 1:length(years)
    datagrid = SLAforFFT{1,i};
    [xr, yr] = size(datagrid);
    %removing rowwise means and outliers
    for j = 1:xr
        datagrid(abs(datagrid(j,:))>3*nanstd(datagrid(j,:))) = NaN;
        datagrid(j,:) = datagrid(j,:)-nanmean(datagrid(j,:));
    end
    %repaint nans with least squares approach
    datagrid = inpaint_nans(datagrid,3);
    datos{1,i} = gradient(transpose(datagrid));
    rados{1,i} = radon(gradient(transpose(datagrid)));
end
radosTotal = cell(1,3);
radosTotal{1,1} = rados{1,14};
radosTotal{1,2} = rados{1,2};
radosTotal{1,3} = rados{1,6};
datosTotal = cell(1,3);
datosTotal{1,1} = datos{1,14};
datosTotal{1,2} = datos{1,2};
datosTotal{1,3} = datos{1,6};
stdTotal = cell(1,3);
stdTotal{1,1} = std(radosTotal{1,1}.^2);
stdTotal{1,2} = std(radosTotal{1,2}.^2);
stdTotal{1,3} = std(radosTotal{1,3}.^2);
grTotal{1,1} = gradient(std(radosTotal{1,1}.^2));
grTotal{1,2} = gradient(std(radosTotal{1,2}.^2));
grTotal{1,3} = gradient(std(radosTotal{1,3}.^2));

%% Experimental Radon Usage (Average Years)
% load('AverageHovmollerData.mat')
% rados = cell(1,3);
% datos = cell(1,3);
% for i = 1:3
%     datagrid = SLATotal{1,i}.*100;
%     [xr, yr] = size(datagrid);
%     %removing rowwise means and outliers
%     for j = 1:xr
%         datagrid(abs(datagrid(j,:))>3*nanstd(datagrid(j,:))) = NaN;
%         datagrid(j,:) = datagrid(j,:)-nanmean(datagrid(j,:));
%     end
%     %repaint nans with least squares approach
%     datagrid = inpaint_nans(datagrid,3);
%     datos{1,i} = gradient(transpose(datagrid));
%     rados{1,i} = radon(gradient(transpose(datagrid)));
% end
% radosTotal = cell(1,3);
% radosTotal{1,1} = rados{1,1};
% radosTotal{1,2} = rados{1,2};
% radosTotal{1,3} = rados{1,3};
% datosTotal = cell(1,3);
% datosTotal{1,1} = datos{1,1};
% datosTotal{1,2} = datos{1,2};
% datosTotal{1,3} = datos{1,3};
% stdTotal = cell(1,3);
% stdTotal{1,1} = std(radosTotal{1,1}.^2);
% stdTotal{1,2} = std(radosTotal{1,2}.^2);
% stdTotal{1,3} = std(radosTotal{1,3}.^2);
% grTotal{1,1} = gradient(std(radosTotal{1,1}.^2));
% grTotal{1,2} = gradient(std(radosTotal{1,2}.^2));
% grTotal{1,3} = gradient(std(radosTotal{1,3}.^2));

%% Figures: Radon Transform, STD
figure('units', 'normalized', 'outerposition', [0 0 1 1])
t = tiledlayout(5,1,'TileSpacing','tight');

anno = cell(1,5); anno{1,1} = "(a)"; anno{1,2} = "(b)"; ...
    anno{1,3} = "(c)"; anno{1,4} = "(d)"; ...
    anno{1,5} = "(e)";
%Radon transforms
for nTiles = 1:3
    ax = nexttile;
    pcolor(radosTotal{1,nTiles})
    shading interp
    %colormap(JetWhiteCenter)
    colormap(jet)
    set(ax,'fontsize',28);
    xticks([])
    %caxis([-200 200])
    caxis([-400 400])
    %text(2, 220, anno{1,nTiles}, 'FontSize', 34);
    text(2, 340, anno{1,nTiles}, 'FontSize', 34);
end
colorbar(gca,'Position',...
    [0.9640625 0.436988727858293 0.011328125 0.488937198067633]);


% Line Graphs: Variance
ax = nexttile;

[~, indi1] = max(stdTotal{1,1});
c(1) = abs((tand(6) * 111 * cosd(8)));
[~, indi2] = max(stdTotal{1,2});
c(2) = abs((tand(indi2) * 111 * cosd(8)));
[~, indi3] = max(stdTotal{1,3});
c(3) = abs((tand(indi3) * 111 * cosd(8)));
plot(stdTotal{1,1}, '-b', 'LineWidth', 3);
hold on
plot(stdTotal{1,2}, '-g', 'LineWidth', 3);
plot(stdTotal{1,3}, '-r', 'LineWidth', 3);
grid on
plot(6,stdTotal{1,1}(6),'ob','MarkerSize', 24, 'LineWidth', 2);
plot(6,stdTotal{1,1}(6),'*b','MarkerSize', 24, 'LineWidth', 2);
plot(indi2,stdTotal{1,2}(indi2),'og','MarkerSize', 24, 'LineWidth', 2);
plot(indi2,stdTotal{1,2}(indi2),'*g','MarkerSize', 24, 'LineWidth', 2);
plot(indi3,stdTotal{1,3}(indi3),'or','MarkerSize', 24, 'LineWidth', 2);
plot(indi3,stdTotal{1,3}(indi3),'*r','MarkerSize', 24, 'LineWidth', 2);
set(ax,'fontsize',28);
xticklabels([])
xlim([1 180])
%ylim([0 2*(10^4)])
ylim([0 4.2*(10^4)])
%text(9, 1.7*(10^4), anno{1,4}, 'FontSize', 34);
text(8, 3.7*(10^4), anno{1,4}, 'FontSize', 34);
%lgd = legend({'Full Years', 'Half Years', 'Local Years','','','','','',''},...
%    'FontSize', 23, 'Location', 'northeast');
lgd = legend({'2006', '1994', '1998','','','','','',''},...
    'FontSize', 23, 'Location', 'northeast');
lgd.NumColumns = 3;

% Line graphs: Gradient of Variance
ax = nexttile;

[~, ~] = max(stdTotal{1,1});
plot(grTotal{1,1}, '-b', 'LineWidth', 3);
hold on
grid on
plot(6,grTotal{1,1}(6),'ob','MarkerSize', 24, 'LineWidth', 2);
plot(6,grTotal{1,1}(6),'*b','MarkerSize', 24, 'LineWidth', 2);

[~, indi] = max(stdTotal{1,2});
plot(grTotal{1,2}, '-g', 'LineWidth', 3);
plot(indi,grTotal{1,2}(indi),'og','MarkerSize', 24, 'LineWidth', 2);
plot(indi,grTotal{1,2}(indi),'*g','MarkerSize', 24, 'LineWidth', 2);

[~, indi] = max(stdTotal{1,3});
plot(grTotal{1,3}, '-r', 'LineWidth', 3);
plot(indi,grTotal{1,3}(indi),'or','MarkerSize', 24, 'LineWidth', 2);
plot(indi,grTotal{1,3}(indi),'*r','MarkerSize', 24, 'LineWidth', 2);
set(ax,'fontsize',28);
plot([1:180], zeros(1,180), '--k', 'LineWidth', 2)
xlim([1 180])
%ylim([-5*(10^3) 5*(10^3)])
ylim([-1.4*(10^4) 1.4*(10^4)])
%text(6, 3700, anno{1,5}, 'FontSize', 34);
text(8, 1.07*(10^4), anno{1,5}, 'FontSize', 34);

xlabel(t, "Degrees", 'FontSize', 36);

c = (c*1000*100)/(24*60*60);

%% Save Figure
%Using Export_Fig for max resolution (magnified, AA'd)
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG

disp("Figure saved and exported after " + toc + " seconds.");



