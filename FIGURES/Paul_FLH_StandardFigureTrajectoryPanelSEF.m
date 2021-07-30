%% Paul_FLH_StandardFigureTrajectoryPanelSEF.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/7/2021
%Date of Last Update: 7/7/2021
%Update History:
%PE 7/7/2021 - Created
%--------------------------------------
%Purpose: Creates a single trajectory plot of SEF with three colors: Red for
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
lowerF = cell(2,2); lowercount = 1; loweryears = [1993, 2001];
upperF = cell(2,6); uppercount = 1; upperyears = [1997, 1998, 2008, 2009, 2011, 2017];
socotraF = cell(2,5); socotracount = 1; socotrayears = [2012, 2018, 2007,2015, 1996];
whatF = cell(2,1); whatyears = 2006;
midF = cell(2,11); midcount = 1;
listtouse = SEFRoot;

%loop and categorize
counttemp = 1;
for i = 1:27
    x_p1 = x_p{listtouse(i),1};
    y_p1 = y_p{listtouse(i),1};
    if ismember(datearray(i), loweryears)
        lowerF{1,lowercount} = x_p1;
        lowerF{2,lowercount} = y_p1;
        lowercount = lowercount + 1;
    elseif ismember(datearray(i), upperyears)
        upperF{1,uppercount} = x_p1;
        upperF{2,uppercount} = y_p1;
        uppercount = uppercount + 1;
    elseif ismember(datearray(i), socotrayears)
        socotraF{1,socotracount} = x_p1;
        socotraF{2,socotracount} = y_p1;
        socotracount = socotracount + 1;
    elseif datearray(i) == 2006
        whatF{1,1} = x_p1;
        whatF{2,1} = y_p1;
    else
        midF{1,midcount} = x_p1;
        midF{2,midcount} = y_p1;
        midcount = midcount + 1;
        questionableF(counttemp) = datearray(i);
        counttemp = counttemp + 1;
    end
end

%grab "average" eddies: Half
lenlower = zeros(1,4);
for i = 1:length(lowerF)
    lenlower(i) = length(lowerF{1,i});
end
maxlenlower = max(lenlower);
xavglower = zeros(1,maxlenlower);
yavglower = zeros(1,maxlenlower);
for i = 1:maxlenlower
    validcount = 0;
    for j = 1:length(lowerF)
        if (i <= length(lowerF{1,j})) %if we're within range of this doodad
            xavglower(i) = xavglower(i) + lowerF{1,j}(i);
            yavglower(i) = yavglower(i) + lowerF{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavglower(i) = xavglower(i)/validcount;
    yavglower(i) = yavglower(i)/validcount;
end

%grab "average" eddies: Local
lenupper = zeros(1,4);
for i = 1:length(upperF)
    lenupper(i) = length(upperF{1,i});
end
maxlenupper = round(mean(lenupper));
xavgupper = zeros(1,maxlenupper);
yavgupper = zeros(1,maxlenupper);
for i = 1:maxlenupper
    validcount = 0;
    for j = 1:length(upperF)
        if (i <= length(upperF{1,j})) %if we're within range of this doodad
            xavgupper(i) = xavgupper(i) + upperF{1,j}(i);
            yavgupper(i) = yavgupper(i) + upperF{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgupper(i) = xavgupper(i)/validcount;
    yavgupper(i) = yavgupper(i)/validcount;
end

%grab "average" eddies: Full
lenmid = zeros(1,4);
for i = 1:length(midF)
    lenmid(i) = length(midF{1,i});
end
maxlenmid = round(mean(lenmid));
xavgmid = zeros(1,maxlenmid);
yavgmid = zeros(1,maxlenmid);
for i = 1:maxlenmid
    validcount = 0;
    for j = 1:length(midF)
        if (i <= length(midF{1,j})) %if we're within range of this doodad
            xavgmid(i) = xavgmid(i) + midF{1,j}(i);
            yavgmid(i) = yavgmid(i) + midF{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgmid(i) = xavgmid(i)/validcount;
    yavgmid(i) = yavgmid(i)/validcount;
end

%grab "average" eddies: Socotra
lensocotra = zeros(1,4);
for i = 1:length(socotraF)
    lensocotra(i) = length(socotraF{1,i});
end
maxlensocotra = round(mean(lensocotra));
xavgsocotra = zeros(1,maxlensocotra);
yavgsocotra = zeros(1,maxlensocotra);
for i = 1:maxlensocotra
    validcount = 0;
    for j = 1:length(socotraF)
        if (i <= length(socotraF{1,j})) %if we're within range of this doodad
            xavgsocotra(i) = xavgsocotra(i) + socotraF{1,j}(i);
            yavgsocotra(i) = yavgsocotra(i) + socotraF{2,j}(i);
            validcount = validcount+1;
        end
    end
    xavgsocotra(i) = xavgsocotra(i)/validcount;
    yavgsocotra(i) = yavgsocotra(i)/validcount;
end

%grab "average" eddies: What
xavgwhat = whatF{1,1};
yavgwhat = whatF{2,1};
        

figure('units', 'normalized', 'outerposition', [0 0 1 1])
m_proj('mercator','lon',[40, 90],'lat',[-5 25])
m_coast('patch',[.6 .6 .6]);
m_grid('box','fancy','fontsize',27);
hold on
m_text(44,20,"Average",'Color','w','fontsize',32);
colors = ['b', 'r', 'k', 'g', 'm'];
toplotTrajSEF = cell(2,5);
toplotTrajSEF{1,1} = xavglower; toplotTrajSEF{1,2} = xavgupper; toplotTrajSEF{1,3} = xavgmid;
toplotTrajSEF{2,1} = yavglower; toplotTrajSEF{2,2} = yavgupper; toplotTrajSEF{2,3} = yavgmid;
toplotTrajSEF{1,4} = xavgsocotra; toplotTrajSEF{1,5} = xavgwhat;
toplotTrajSEF{2,4} = yavgsocotra; toplotTrajSEF{2,5} = yavgwhat;
for i = 1:5
    m_plot(toplotTrajSEF{1,i},toplotTrajSEF{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',32);
title("SEF Averages", 'fontsize', 28)
ylabel('Latitude');
xlabel('Longitude');
h = zeros(1, 5);
h(1) = plot([-10 -11],[-10 -11],'-r');
h(2) = plot([-10 -11],[-10 -11],'-b');
h(3) = plot([-10 -11],[-10 -11],'-k');
h(4) = plot([-10 -11],[-10 -11],'-g');
h(5) = plot([-10 -11],[-10 -11],'-m');
hold on
legend(h, {'SEF: Upper', 'SEF: Lower', 'SEF: Midbasin', 'SEF: Socotra', 'SEF: Outlier'}, 'FontSize', 24);

save('StandardFigureTrajectoryPanelSEFNew.mat', 'toplotTrajSEF', 'upperF', 'lowerF', 'midF', 'socotraF', 'whatF');

