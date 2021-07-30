%% Paul_FLH_StandardFigureTrajectoryPanelLHW.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/7/2021
%Date of Last Update: 7/7/2021
%Update History:
%PE 7/7/2021 - Created
%--------------------------------------
%Purpose: Creates a single trajectory plot of LHW with three colors: Red for
%"Local" years, blue for "partial" years and black for "transbasin" years
%Inputs: FinalEddyIDLists from Paul_FinalEddyTracking.m, AE_traj from steps
%Outputs: Single figure of average trajectories; mat file of said trajs
%--------------------------------------
load('FinalEddyIDLists');
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
load('AE_Filtered_Trajectories.mat') %load AE trajectories
x_p=AE_traj(:,2); y_p=AE_traj(:,3);
datearray = 1993:2019;
%% Crunch crunch
nonGW = cell(2,19); nonGWcount = 1; 
fullGW = cell(2,8); fullGWcount = 1; %fullGWyears = [1993, 2000, 2001, 2003, 2004, 2008, 2009, 2015, 2018];
fullGWyears = [1993, 1999, 2001, 2003, 2004, 2009, 2015, 2018];
listtouse = LHWRoot;

%loop and categorize
for i = 1:27
    x_p1 = x_p{listtouse(i),1};
    y_p1 = y_p{listtouse(i),1};
    if ismember(datearray(i), fullGWyears)
        fullGW{1,fullGWcount} = x_p1;
        fullGW{2,fullGWcount} = y_p1;
        fullGWcount = fullGWcount + 1;
    else
        nonGW{1,nonGWcount} = x_p1;
        nonGW{2,nonGWcount} = y_p1;
        nonGWcount = nonGWcount + 1;
    end
end

%grab "average" eddies: nonGW
lennonGW = zeros(1,9);
for i = 1:length(nonGW)
    lennonGW(i) = length(nonGW{1,i});
end
maxlennonGW = round(mean(lennonGW));
xavgnonGW = zeros(1,maxlennonGW);
yavgnonGW = zeros(1,maxlennonGW);
for i = 1:maxlennonGW
    validcount = 0;
    for j = 1:length(nonGW)
        if (i <= length(nonGW{1,j})) %if we're within range of this doodad
            xavgnonGW(i) = xavgnonGW(i) + nonGW{1,j}(i);
            yavgnonGW(i) = yavgnonGW(i) + nonGW{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgnonGW(i) = xavgnonGW(i)/validcount;
    yavgnonGW(i) = yavgnonGW(i)/validcount;
end

%grab "average" eddies: fullGW
lenfullGW = zeros(1,4);
for i = 1:length(fullGW)
    lenfullGW(i) = length(fullGW{1,i});
end
maxlenfullGW = round(mean(lenfullGW));
xavgfullGW = zeros(1,maxlenfullGW);
yavgfullGW = zeros(1,maxlenfullGW);
for i = 1:maxlenfullGW
    validcount = 0;
    for j = 1:length(fullGW)
        if (i <= length(fullGW{1,j})) %if we're within range of this doodad
            xavgfullGW(i) = xavgfullGW(i) + fullGW{1,j}(i);
            yavgfullGW(i) = yavgfullGW(i) + fullGW{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgfullGW(i) = xavgfullGW(i)/validcount;
    yavgfullGW(i) = yavgfullGW(i)/validcount;
end

figure('units', 'normalized', 'outerposition', [0 0 1 1])
m_proj('mercator','lon',[40, 90],'lat',[-5 25])
m_coast('patch',[.6 .6 .6]);
m_grid('box','fancy','fontsize',27);
hold on
m_text(44,20,"Average",'Color','w','fontsize',32);
colors = ['r', 'k'];
toplotTrajLHW = cell(2,2);
toplotTrajLHW{1,1} = xavgnonGW; toplotTrajLHW{1,2} = xavgfullGW;
toplotTrajLHW{2,1} = yavgnonGW; toplotTrajLHW{2,2} = yavgfullGW;
for i = 1:2
    m_plot(toplotTrajLHW{1,i},toplotTrajLHW{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',32);
title("LHW Averages", 'fontsize', 28)
ylabel('Latitude');
xlabel('Longitude');
h = zeros(1, 2);
h(1) = plot([-10 -11],[-10 -11],'-r');
h(2) = plot([-10 -11],[-10 -11],'-k');
hold on
legend(h, {'LHW: non-GW Root', 'LHW: GW Root'}, 'FontSize', 24);

save('StandardFigureTrajectoryPanelLHW.mat', 'toplotTrajLHW', 'fullGW', 'nonGW');

