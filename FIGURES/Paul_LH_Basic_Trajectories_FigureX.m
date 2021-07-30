%% Paul_LH_Basic_Trajectories_FigureX.m (version 1.1)
%Author: Paul Ernst
%Date Created: 7/23/2021
%Date of Last Update: 7/30/2021
%Update History:
%PE 7/30/2021 - Changed name, added comments
%PE 7/23/2021 - Created
%--------------------------------------
%Purpose: Creates 3-panel figure of LH's Trajectory for 3 example years.
%Inputs: FinalEddyIDLists from FinalEddyTracking.m, AE_traj from steps
%Outputs: Same domain as ExampleTracking figure of total trajectory.
%--------------------------------------
tic
titlestring = "Ernst-LHTraj-FigureX.tiff"; %what we're calling the figure
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
load('AE_Filtered_Trajectories.mat') %load AE trajectories
load('FinalEddyIDLists'); %load eddy lists
x_p=AE_traj(:,2); y_p=AE_traj(:,3); %setting AE x's and y's
latlonbounds = [25, 0, 80, 40]; %bounds setting for map
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%% Plot, no processing necessary
%set up fullscreened tiledlayout
figure('units', 'normalized', 'outerposition', [0 0 1 1]);
tiledlayout(1,3,'TileSpacing','none')
anno = cell(1,3); anno{1,1} = "(a) 2006"; anno{1,2} = "(b) 1994"; anno{1,3} = "(c) 1998";

%iterate through years
yea = [14 2 6];
for i = 1:3
    t = nexttile;
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    m_coast('patch',[.5 .5 .5]);
    %make sure we get the ticks right
    if i == 1
        m_grid('box','fancy','fontsize',32, 'xtick', [44 52 60 68 76]);
    else
        m_grid('box','fancy','fontsize',32, 'yticklabels',[], 'xtick', [44 52 60 68 76]);
    end
    
    %set up LHRoot trajs
    hold on
    m_text(41,23,anno{1,i},'color','w','fontsize',32);
    x_p1 = x_p{LHRoot(yea(i)),1};
    y_p1 = y_p{LHRoot(yea(i)),1};
    
    %plot the tracks
    m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 4);
    hold on
    m_plot(x_p1(1),y_p1(1), '*k', 'MarkerSize', 28, 'LineWidth', 2);
    m_plot(x_p1(1),y_p1(1), 'ok', 'MarkerSize', 28, 'LineWidth', 2);
    set(gca,'fontsize',32);
    hold on
end

%% Save Figure
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory
toc