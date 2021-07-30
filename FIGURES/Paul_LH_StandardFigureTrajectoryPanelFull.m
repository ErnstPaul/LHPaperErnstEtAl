%% Paul_LH_StandardFigureTrajectoryPanelFull.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/13/2021
%Date of Last Update: 7/13/2021
%Update History:
%PE 7/13/2021 - Created
%--------------------------------------
%Purpose: Creates the figure for all the trajectories combined.
%Inputs: FinalEddyIDLists from Paul_FinalEddyTracking.m, AE_traj from steps
%        Standard figure panel mat files from previous trajpanel scripts
%Outputs: Single figure of average trajectories
%--------------------------------------
%% Load data
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
load('AE_Filtered_Trajectories.mat') %load AE trajectories
x_p=AE_traj(:,2); y_p=AE_traj(:,3);
datearray = 1993:2019;
load('FinalEddyIDLists');
load('StandardFigureTrajectoryPanelLH.mat');
load('StandardFigureTrajectoryPanelLHW.mat');
load('StandardFigureTrajectoryPanelGW.mat');
load('StandardFigureTrajectoryPanelSES.mat');
load('StandardFigureTrajectoryPanelSEF.mat');
load('StandardFigureTrajectoryPanelSESNew.mat');
load('StandardFigureTrajectoryPanelSEFNew.mat');
titlestring = "FullTrajectoriesFigureWithLegend.jpeg";
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
%% Make figure

figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%Using TiledLayout for this so we can stuff it in a for-loop
t = tiledlayout(6,2,'TileSpacing','tight');

%LH - LHW - GW - SES - SEF
%Lines show trajectories; Dots show formation points
%--------------------------------------
% LH
%--------------------------------------
ax = nexttile([2, 1]);
m_proj('mercator','lon',[50, 80],'lat',[3 12])
m_coast('patch',[.5 .5 .5]);
m_grid('box','fancy','fontsize',27);
hold on
colors = ['r', 'b', 'k'];
%plot average trajectories
for i = 1:3
    m_plot(toplotTrajLH{1,i},toplotTrajLH{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
m_text(76,11,"(a) LH",'Color','w','fontsize',32);
%plot origin points
for i = 1:length(half)
    m_plot(half{1,i}(1), half{2,i}(1), '*r', 'MarkerSize', 8);
end
for i = 1:length(local)
    m_plot(local{1,i}(1), local{2,i}(1), '*b', 'MarkerSize', 8);
end
for i = 1:length(full)
    m_plot(full{1,i}(1), full{2,i}(1), '*k', 'MarkerSize', 8);
end
set(gca,'fontsize',24);
%legend
h = zeros(1, 3);
h(1) = plot([-10 -11],[-10 -11],'-k','LineWidth', 3);
h(2) = plot([-10 -11],[-10 -11],'-r','LineWidth', 3);
h(3) = plot([-10 -11],[-10 -11],'-b','LineWidth', 3);
hold on
legend(h, {'Lives Past Half Basin', 'Dies Near Half Basin', 'Dies Near Coast'}, 'FontSize', 24, 'Location', 'northwest');

%--------------------------------------
% SES
%--------------------------------------
ax = nexttile([3 1]);
m_proj('mercator','lon',[50, 80],'lat',[5.5 20])
m_coast('patch',[.5 .5 .5]);
m_grid('box','fancy','fontsize',27);
hold on
%lower upper middle south socotra
colors = ['g', 'm', 'r', 'b', 'k'];
%plot average trajectories
for i = 1:5
    m_plot(toplotTrajSES{1,i},toplotTrajSES{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',24);
m_text(76,19,"(d) SES",'Color','w','fontsize',32);
%plot origin points
for i = 1:length(lowerS)
    m_plot(lowerS{1,i}(1), lowerS{2,i}(1), '*g', 'MarkerSize', 8)
%     m_text(lowerS{1,i}(1), lowerS{2,i}(1), int2str(loweryears(i)), 'Color', 'g');
end
for i = 1:length(upperS)
    m_plot(upperS{1,i}(1), upperS{2,i}(1), '*m', 'MarkerSize', 8);
%     m_text(upperS{1,i}(1), upperS{2,i}(1), int2str(upperyears(i)), 'Color', 'm');
end
for i = 1:length(midS)
    m_plot(midS{1,i}(1), midS{2,i}(1), '*r', 'MarkerSize', 8);
%     m_text(midS{1,i}(1), midS{2,i}(1), int2str(midyears(i)), 'Color', 'r');
end
for i = 1:length(socotraS)
    m_plot(socotraS{1,i}(1), socotraS{2,i}(1), '*k', 'MarkerSize', 8);
%     m_text(socotraS{1,i}(1), socotraS{2,i}(1), int2str(socotrayears(i)), 'Color', 'k');
end
for i = 1:length(southS)
    m_plot(southS{1,i}(1), southS{2,i}(1), '*b', 'MarkerSize', 8);
%     m_text(southS{1,i}(1), southS{2,i}(1), int2str(southyears(i)), 'Color', 'b');
end
%legend
h = zeros(1, 5);
h(1) = plot([-10 -11],[-10 -11],'-k','LineWidth', 3); %mid
h(2) = plot([-10 -11],[-10 -11],'-r','LineWidth', 3); %socotra
h(3) = plot([-10 -11],[-10 -11],'-b','LineWidth', 3); %south
h(4) = plot([-10 -11],[-10 -11],'-g','LineWidth', 3); %lower
h(5) = plot([-10 -11],[-10 -11],'-m','LineWidth', 3); %upper
hold on
legend(h, {'Origin Close to Socotra', 'Origin in Midbasin', 'Origin in South Basin',...
    'Origin in Southeast Basin', 'Origin in Northeast Basin'}, 'FontSize', 24, 'Location', 'northwest');

%--------------------------------------
% LHW
%--------------------------------------
ax = nexttile([2, 1]);
m_proj('mercator','lon',[50, 80],'lat',[3 12])
m_coast('patch',[.5 .5 .5]);
m_grid('box','fancy','fontsize',27);
hold on
colors = ['k', 'r'];
%plot average trajectories
for i = 1:2
    m_plot(toplotTrajLHW{1,i},toplotTrajLHW{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
m_text(76,11,"(b) LHW",'Color','w','fontsize',32);
%plot origin points
for i = 1:length(nonGW)
    m_plot(nonGW{1,i}(1), nonGW{2,i}(1), '*k', 'MarkerSize', 8);
end
for i = 1:length(fullGW)
    m_plot(fullGW{1,i}(1), fullGW{2,i}(1), '*r', 'MarkerSize', 8);
end
set(gca,'fontsize',24);
%legend
h = zeros(1, 2);
h(1) = plot([-10 -11],[-10 -11],'-k','LineWidth', 3);
h(2) = plot([-10 -11],[-10 -11],'-r','LineWidth', 3);
hold on
legend(h, {'Dies from Child-Splitting','Becomes GW Root'}, 'FontSize', 24, 'Location', 'northwest');

%--------------------------------------
% SEF
%--------------------------------------
ax = nexttile([3 1]);
m_proj('mercator','lon',[50, 80],'lat',[5.5 20])
m_coast('patch',[.5 .5 .5]);
m_grid('box','fancy','fontsize',27);
hold on
colors = ['g', 'r', 'k', 'b', 'm'];
%plot average trajectories
for i = 1:5
    m_plot(toplotTrajSEF{1,i},toplotTrajSEF{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
m_text(76,19,"(e) SEF",'Color','w','fontsize',32);
%plot origin points
for i = 1:length(lowerF)
    m_plot(lowerF{1,i}(1), lowerF{2,i}(1), '*g', 'MarkerSize', 8);
end
for i = 1:length(upperF)
    m_plot(upperF{1,i}(1), upperF{2,i}(1), '*r', 'MarkerSize', 8);
end
for i = 1:length(midF)
    m_plot(midF{1,i}(1), midF{2,i}(1), '*k', 'MarkerSize', 8);
end
for i = 1:length(socotraF)
    m_plot(socotraF{1,i}(1), socotraF{2,i}(1), '*b', 'MarkerSize', 8);
end
for i = 1:1
    m_plot(whatF{1,i}(1), whatF{2,i}(1), '*m', 'MarkerSize', 8);
end
set(gca,'fontsize',24);
%legend
h = zeros(1, 5);
h(1) = plot([-10 -11],[-10 -11],'-k','LineWidth', 3);
h(2) = plot([-10 -11],[-10 -11],'-r','LineWidth', 3);
h(3) = plot([-10 -11],[-10 -11],'-b','LineWidth', 3);
h(4) = plot([-10 -11],[-10 -11],'-g','LineWidth', 3);
h(5) = plot([-10 -11],[-10 -11],'-m','LineWidth', 3);
hold on
legend(h, {'Origin in Midbasin', 'Origin on Northeast Margin', 'Origin Close to Socotra'...
    'Origin in Southeast Basin', 'Outlier in South Basin'}, 'FontSize', 24, 'Location', 'northwest');

%--------------------------------------
% GW
%--------------------------------------
ax = nexttile([2, 1]);
m_proj('mercator','lon',[50, 80],'lat',[3 12])
m_coast('patch',[.5 .5 .5]);
m_grid('box','fancy','fontsize',27);
hold on
colors = ['k', 'r'];
%plot average trajectories
for i = 1:2
    m_plot(toplotTrajGW{1,i},toplotTrajGW{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
m_text(76,11,"(c) GW",'Color','w','fontsize',32);
%plot origin points
for i = 1:length(nonLHW)
    m_plot(nonLHW{1,i}(1), nonLHW{2,i}(1), '*k', 'MarkerSize', 8);
end
for i = 1:length(fullLHW)
    m_plot(fullLHW{1,i}(1), fullLHW{2,i}(1), '*r', 'MarkerSize', 8)
end
set(gca,'fontsize',24);
%legend
h = zeros(1, 2);
h(1) = plot([-10 -11],[-10 -11],'-k','LineWidth', 3);
h(2) = plot([-10 -11],[-10 -11],'-r','LineWidth', 3);
hold on
legend(h, {'Origin From LHW Child', 'Origin from LH Root or LHW Root'}, 'FontSize', 24, 'Location', 'northwest');

%% Save figure
% Save at a high resolution
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
