%% Paul_FLH_StandardFigureTrajectoryPanelLH.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/7/2021
%Date of Last Update: 7/7/2021
%Update History:
%PE 7/7/2021 - Created
%--------------------------------------
%Purpose: Creates a single trajectory plot of LH with three colors: Red for
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
x_p=AE_traj(:,2); y_p=AE_traj(:,3); date_p=AE_traj(:,14);
datearray = 1993:2019;
%% Crunch crunch
half = cell(3,6); halfcount = 1; halfyears = [1994, 1999, 2003, 2011, 2013, 2019];
local = cell(3,4); localcount = 1; localyears = [1997, 1998, 2004, 2010];
full = cell(3,17); fullcount = 1;
listtouse = LHRoot;

%loop and categorize
for i = 1:27
    x_p1 = x_p{listtouse(i),1};
    y_p1 = y_p{listtouse(i),1};
    date_p1 = date_p{listtouse(i),1};
    if ismember(datearray(i), halfyears)
        half{1,halfcount} = x_p1;
        half{2,halfcount} = y_p1;
        %process date
        for j = 1:length(date_p1)
            date=date_p1(j);
            date2=datestr(date(1));
            daynf=str2double(date2(1:2));
            month=date2(4:6);
            [monthint, ~] = monthconversion(month);
            year=str2double(date2(8:11));
            date3 = datetime([year monthint daynf]);
            dayt = day(date3,'dayofyear');
            if (dayt > 300)
                if (mod(i,4) == 0)
                    leap = 366;
                else
                    leap = 365;
                end
                dayt = dayt-leap;
            end
            half{3,halfcount}(j) = dayt;
        end
        halfcount = halfcount + 1;
    elseif ismember(datearray(i), localyears)
        local{1,localcount} = x_p1;
        local{2,localcount} = y_p1;
        for j = 1:length(date_p1)
            date=date_p1(j);
            date2=datestr(date(1));
            daynf=str2double(date2(1:2));
            month=date2(4:6);
            [monthint, ~] = monthconversion(month);
            year=str2double(date2(8:11));
            date3 = datetime([year monthint daynf]);
            dayt = day(date3,'dayofyear');
            if (dayt > 300)
                if (mod(i,4) == 0)
                    leap = 366;
                else
                    leap = 365;
                end
                dayt = dayt-leap;
            end
            local{3,localcount}(j) = dayt;
        end
        localcount = localcount + 1;
    else
        full{1,fullcount} = x_p1;
        full{2,fullcount} = y_p1;
        for j = 1:length(date_p1)
            date=date_p1(j);
            date2=datestr(date(1));
            daynf=str2double(date2(1:2));
            month=date2(4:6);
            [monthint, ~] = monthconversion(month);
            year=str2double(date2(8:11));
            date3 = datetime([year monthint daynf]);
            dayt = day(date3,'dayofyear');
            if (dayt > 300)
                if (mod(i,4) == 0)
                    leap = 366;
                else
                    leap = 365;
                end
                dayt = dayt-leap;
            end
            full{3,fullcount}(j) = dayt;
        end
        fullcount = fullcount + 1;
    end
end

%grab "average" eddies: Half
lenhalf = zeros(1,4);
for i = 1:length(half)
    lenhalf(i) = length(half{1,i});
end
maxlenhalf = round(mean(lenhalf));
xavghalf = zeros(1,maxlenhalf);
yavghalf = zeros(1,maxlenhalf);
davghalf = zeros(1,maxlenhalf);
for i = 1:maxlenhalf
    validcount = 0;
    for j = 1:length(half)
        if (i <= length(half{1,j})) %if we're within range of this doodad
            xavghalf(i) = xavghalf(i) + half{1,j}(i);
            yavghalf(i) = yavghalf(i) + half{2,j}(i);
            davghalf(i) = davghalf(i) + half{3,j}(i);
            validcount = validcount+1;
        end
    end
    xavghalf(i) = xavghalf(i)/validcount;
    yavghalf(i) = yavghalf(i)/validcount;
    davghalf(i) = davghalf(i)/validcount;
end

%grab "average" eddies: Local
lenlocal = zeros(1,4);
for i = 1:length(local)
    lenlocal(i) = length(local{1,i});
end
maxlenlocal = round(mean(lenlocal));
xavglocal = zeros(1,maxlenlocal);
yavglocal = zeros(1,maxlenlocal);
davglocal = zeros(1,maxlenlocal);
for i = 1:maxlenlocal
    validcount = 0;
    for j = 1:length(local)
        if (i <= length(local{1,j})) %if we're within range of this doodad
            xavglocal(i) = xavglocal(i) + local{1,j}(i);
            yavglocal(i) = yavglocal(i) + local{2,j}(i);
            davglocal(i) = davglocal(i) + local{3,j}(i);
            validcount = validcount+1;
        end
    end
    xavglocal(i) = xavglocal(i)/validcount;
    yavglocal(i) = yavglocal(i)/validcount;
    davglocal(i) = davglocal(i)/validcount;
end

%grab "average" eddies: Full
lenfull = zeros(1,4);
for i = 1:length(full)
    lenfull(i) = length(full{1,i});
end
maxlenfull = round(mean(lenfull));
xavgfull = zeros(1,maxlenfull);
yavgfull = zeros(1,maxlenfull);
davgfull = zeros(1,maxlenfull);
for i = 1:maxlenfull
    validcount = 0;
    for j = 1:length(full)
        if (i <= length(full{1,j})) %if we're within range of this doodad
            xavgfull(i) = xavgfull(i) + full{1,j}(i);
            yavgfull(i) = yavgfull(i) + full{2,j}(i);
            davgfull(i) = davgfull(i) + full{3,j}(i);
            validcount = validcount+1;
        end
    end
    xavgfull(i) = xavgfull(i)/validcount;
    yavgfull(i) = yavgfull(i)/validcount;
    davgfull(i) = davgfull(i)/validcount;
end

figure('units', 'normalized', 'outerposition', [0 0 1 1])
m_proj('mercator','lon',[40, 90],'lat',[-5 25])
m_coast('patch',[.6 .6 .6]);
m_grid('box','fancy','fontsize',27);
hold on
m_text(44,20,"Average",'Color','w','fontsize',32);
colors = ['b', 'r', 'k'];
toplotTrajLH = cell(3,3);
toplotTrajLH{1,1} = xavghalf; toplotTrajLH{1,2} = xavglocal; toplotTrajLH{1,3} = xavgfull;
toplotTrajLH{2,1} = yavghalf; toplotTrajLH{2,2} = yavglocal; toplotTrajLH{2,3} = yavgfull;
toplotTrajLH{3,1} = davghalf; toplotTrajLH{3,2} = davglocal; toplotTrajLH{3,3} = davgfull;
for i = 1:3
    m_plot(toplotTrajLH{1,i},toplotTrajLH{2,i}, 'LineStyle', '-', 'Color', colors(i), 'LineWidth', 2);
    hold on
end
set(gca,'fontsize',32);
title("LH Averages", 'fontsize', 28)
ylabel('Latitude');
xlabel('Longitude');
h = zeros(1, 3);
h(1) = plot([-10 -11],[-10 -11],'-r');
h(2) = plot([-10 -11],[-10 -11],'-b');
h(3) = plot([-10 -11],[-10 -11],'-k');
hold on
legend(h, {'LH: Local', 'LH: Half', 'LH: Full'}, 'FontSize', 24);

save('StandardFigureTrajectoryPanelLH.mat', 'toplotTrajLH', 'half', 'local', 'full');

