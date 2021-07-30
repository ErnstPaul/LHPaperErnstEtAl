%% Paul_FLH_StandardFigureTrajectoryPanelSES.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/7/2021
%Date of Last Update: 7/7/2021
%Update History:
%PE 7/7/2021 - Created
%--------------------------------------
%Purpose: Creates a single trajectory plot of SES with three colors: Red for
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
socotraS = cell(2,7); socotracount = 1; socotrayears =sort([2011,2012,2006,2007,2015,2017,1998]);
lowerS = cell(2,4); lowercount = 1; loweryears = [1997, 2000, 2001, 2009];
upperS = cell(2,3); uppercount = 1; upperyears = [1995, 2014, 2018];
southS = cell(2,5); southcount = 1; southyears = [1996,2002,2003,1999,2019];
midS = cell(2,8); midcount = 1;
listtouse = SESRoot;

%loop and categorize
for i = 1:27
    x_p1 = x_p{listtouse(i),1};
    y_p1 = y_p{listtouse(i),1};
    if ismember(datearray(i), loweryears)
        lowerS{1,lowercount} = x_p1;
        lowerS{2,lowercount} = y_p1;
        lowercount = lowercount + 1;
    elseif ismember(datearray(i), upperyears)
        upperS{1,uppercount} = x_p1;
        upperS{2,uppercount} = y_p1;
        uppercount = uppercount + 1;
    elseif ismember(datearray(i), socotrayears)
        socotraS{1,socotracount} = x_p1;
        socotraS{2,socotracount} = y_p1;
        socotracount = socotracount + 1;
    elseif ismember(datearray(i), southyears)
        southS{1,southcount} = x_p1;
        southS{2,southcount} = y_p1;
        southcount = southcount + 1;
    else
        midS{1,midcount} = x_p1;
        midS{2,midcount} = y_p1;
        midyears(midcount) = datearray(i);
        midcount = midcount + 1;
    end
end

%grab "average" eddies: Half
lenlower = zeros(1,4);
for i = 1:length(lowerS)
    lenlower(i) = length(lowerS{1,i});
end
maxlenlower = round(mean(lenlower));
xavglower = zeros(1,maxlenlower);
yavglower = zeros(1,maxlenlower);
for i = 1:maxlenlower
    validcount = 0;
    for j = 1:length(lowerS)
        if (i <= length(lowerS{1,j})) %if we're within range of this doodad
            xavglower(i) = xavglower(i) + lowerS{1,j}(i);
            yavglower(i) = yavglower(i) + lowerS{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavglower(i) = xavglower(i)/validcount;
    yavglower(i) = yavglower(i)/validcount;
end

%grab "average" eddies: Local
lenupper = zeros(1,4);
for i = 1:length(upperS)
    lenupper(i) = length(upperS{1,i});
end
maxlenupper = round(mean(lenupper));
xavgupper = zeros(1,maxlenupper);
yavgupper = zeros(1,maxlenupper);
for i = 1:maxlenupper
    validcount = 0;
    for j = 1:length(upperS)
        if (i <= length(upperS{1,j})) %if we're within range of this doodad
            xavgupper(i) = xavgupper(i) + upperS{1,j}(i);
            yavgupper(i) = yavgupper(i) + upperS{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgupper(i) = xavgupper(i)/validcount;
    yavgupper(i) = yavgupper(i)/validcount;
end

%grab "average" eddies: Full
lenmid = zeros(1,4);
for i = 1:length(midS)
    lenmid(i) = length(midS{1,i});
end
maxlenmid = round(mean(lenmid));
xavgmid = zeros(1,maxlenmid);
yavgmid = zeros(1,maxlenmid);
for i = 1:maxlenmid
    validcount = 0;
    for j = 1:length(midS)
        if (i <= length(midS{1,j})) %if we're within range of this doodad
            xavgmid(i) = xavgmid(i) + midS{1,j}(i);
            yavgmid(i) = yavgmid(i) + midS{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgmid(i) = xavgmid(i)/validcount;
    yavgmid(i) = yavgmid(i)/validcount;
end

%grab "average" eddies: South
lensouth = zeros(1,3);
for i = 1:length(southS)
    lensouth(i) = length(southS{1,i});
end
maxlensouth = round(mean(lensouth));
xavgsouth = zeros(1,maxlensouth);
yavgsouth = zeros(1,maxlensouth);
for i = 1:maxlensouth
    validcount = 0;
    for j = 1:length(southS)
        if (i <= length(southS{1,j})) %if we're within range of this doodad
            xavgsouth(i) = xavgsouth(i) + southS{1,j}(i);
            yavgsouth(i) = yavgsouth(i) + southS{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgsouth(i) = xavgsouth(i)/validcount;
    yavgsouth(i) = yavgsouth(i)/validcount;
end

%grab "average" eddies: Socotra
lensocotra = zeros(1,8);
for i = 1:length(socotraS)
    lensocotra(i) = length(socotraS{1,i});
end
maxlensocotra = round(mean(lensocotra));
xavgsocotra = zeros(1,maxlensocotra);
yavgsocotra = zeros(1,maxlensocotra);
for i = 1:maxlensocotra
    validcount = 0;
    for j = 1:length(socotraS)
        if (i <= length(socotraS{1,j})) %if we're within range of this doodad
            xavgsocotra(i) = xavgsocotra(i) + socotraS{1,j}(i);
            yavgsocotra(i) = yavgsocotra(i) + socotraS{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgsocotra(i) = xavgsocotra(i)/validcount;
    yavgsocotra(i) = yavgsocotra(i)/validcount;
end

figure('units', 'normalized', 'outerposition', [0 0 1 1])
m_proj('mercator','lon',[40, 90],'lat',[-5 25])
m_coast('patch',[.6 .6 .6]);
m_grid('box','fancy','fontsize',27);
hold on
m_text(44,20,"Average",'Color','w','fontsize',32);
colors = ['b', 'r', 'k', 'g', 'm'];
toplotTrajSES = cell(2,5);
toplotTrajSES{1,1} = xavglower; toplotTrajSES{1,2} = xavgupper; toplotTrajSES{1,3} = xavgmid;
toplotTrajSES{2,1} = yavglower; toplotTrajSES{2,2} = yavgupper; toplotTrajSES{2,3} = yavgmid;
toplotTrajSES{1,4} = xavgsouth; toplotTrajSES{1,5} = xavgsocotra; 
toplotTrajSES{2,4} = yavgsouth; toplotTrajSES{2,5} = yavgsocotra;
for i = 1:5
    m_plot(toplotTrajSES{1,i},toplotTrajSES{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',32);
title("SES Averages", 'fontsize', 28)
ylabel('Latitude');
xlabel('Longitude');
h = zeros(1, 5);
h(1) = plot([-10 -11],[-10 -11],'-r');
h(2) = plot([-10 -11],[-10 -11],'-b');
h(3) = plot([-10 -11],[-10 -11],'-k');
h(4) = plot([-10 -11],[-10 -11],'-g');
h(5) = plot([-10 -11],[-10 -11],'-m');
hold on
legend(h, {'SES: Upper', 'SES: Lower', 'SES: Midbasin', 'SES: South', 'SES: Socotra'}, 'FontSize', 24);

save('StandardFigureTrajectoryPanelSESNew.mat', 'toplotTrajSES', 'upperS', 'lowerS', 'midS', 'southS', 'socotraS');

