%% Paul_FLH_StandardFigureTrajectoryPanelGW.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/7/2021
%Date of Last Update: 7/7/2021
%Update History:
%PE 7/7/2021 - Created
%--------------------------------------
%Purpose: Creates a single trajectory plot of GW with three colors: Red for
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
nonLHW = cell(2,16); nonLHWcount = 1; 
fullLHW = cell(2,11); fullLHWcount = 1; %fullLHWyears = [1993, 2000, 2001, 2003, 2004, 2008, 2009, 2015, 2018];
fullLHWyears = [1993, 1999, 2001, 2000, 2003, 2004, 2009, 2015, 2014, 2017, 2018];
listtouse = GWRoot;

%loop and categorize
for i = 1:27
    x_p1 = x_p{listtouse(i),1};
    y_p1 = y_p{listtouse(i),1};
    if ismember(datearray(i), fullLHWyears)
        fullLHW{1,fullLHWcount} = x_p1;
        fullLHW{2,fullLHWcount} = y_p1;
        fullLHWcount = fullLHWcount + 1;
    else
        nonLHW{1,nonLHWcount} = x_p1;
        nonLHW{2,nonLHWcount} = y_p1;
        nonLHWcount = nonLHWcount + 1;
    end
end

%grab "average" eddies: nonLHW
lennonLHW = zeros(1,9);
for i = 1:length(nonLHW)
    lennonLHW(i) = length(nonLHW{1,i});
end
maxlennonLHW = round(mean(lennonLHW));
xavgnonLHW = zeros(1,maxlennonLHW);
yavgnonLHW = zeros(1,maxlennonLHW);
for i = 1:maxlennonLHW
    validcount = 0;
    for j = 1:length(nonLHW)
        if (i <= length(nonLHW{1,j})) %if we're within range of this doodad
            xavgnonLHW(i) = xavgnonLHW(i) + nonLHW{1,j}(i);
            yavgnonLHW(i) = yavgnonLHW(i) + nonLHW{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgnonLHW(i) = xavgnonLHW(i)/validcount;
    yavgnonLHW(i) = yavgnonLHW(i)/validcount;
end

%grab "average" eddies: fullLHW
lenfullLHW = zeros(1,4);
for i = 1:length(fullLHW)
    lenfullLHW(i) = length(fullLHW{1,i});
end
maxlenfullLHW = round(mean(lenfullLHW));
xavgfullLHW = zeros(1,maxlenfullLHW);
yavgfullLHW = zeros(1,maxlenfullLHW);
for i = 1:maxlenfullLHW
    validcount = 0;
    for j = 1:length(fullLHW)
        if (i <= length(fullLHW{1,j})) %if we're within range of this doodad
            xavgfullLHW(i) = xavgfullLHW(i) + fullLHW{1,j}(i);
            yavgfullLHW(i) = yavgfullLHW(i) + fullLHW{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgfullLHW(i) = xavgfullLHW(i)/validcount;
    yavgfullLHW(i) = yavgfullLHW(i)/validcount;
end

figure('units', 'normalized', 'outerposition', [0 0 1 1])
m_proj('mercator','lon',[40, 90],'lat',[-5 25])
m_coast('patch',[.6 .6 .6]);
m_grid('box','fancy','fontsize',27);
hold on
m_text(44,20,"Average",'Color','w','fontsize',32);
colors = ['r', 'k'];
toplotTrajGW = cell(2,2);
toplotTrajGW{1,1} = xavgnonLHW; toplotTrajGW{1,2} = xavgfullLHW;
toplotTrajGW{2,1} = yavgnonLHW; toplotTrajGW{2,2} = yavgfullLHW;
for i = 1:2
    m_plot(toplotTrajGW{1,i},toplotTrajGW{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',32);
title("GW Averages", 'fontsize', 28)
ylabel('Latitude');
xlabel('Longitude');
h = zeros(1, 2);
h(1) = plot([-10 -11],[-10 -11],'-r');
h(2) = plot([-10 -11],[-10 -11],'-k');
hold on
legend(h, {'GW: non-GW Root', 'GW: GW Root'}, 'FontSize', 24);
disp(int2str(maxlenfullLHW));
disp(int2str(maxlennonLHW));

save('StandardFigureTrajectoryPanelGW.mat', 'toplotTrajGW', 'fullLHW', 'nonLHW');

