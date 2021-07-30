%% Paul_CorrelateDriftersWithLH.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/29/2021
%Date of Last Update: 7/30/2021
%Update History:
%PE 7/30/2021 - Updated name and comments
%PE 7/29/2021 - Created
%--------------------------------------
%Purpose: Identify comorbid drifter and LH trajectories.
%Inputs: .mat files for interpolated drifters and LHRoot.
%Outputs: Figure of intercept points on the trajectories of LH in
%2006-1994-1998 (check for 2019 and 2010 if nothing for 1994 and 1998)
%% Read data in
tic
titlestring = "Ernst-DriftLocs-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
addpath(strcat(basepath, 'FUNCTIONS'));
load('AE_Filtered_Trajectories.mat')
load('FinalEddyIDLists.mat', 'LHRoot'); load('DRByYearAS.mat')
yea = [14 2 6];
latlonbounds = [25, -10, 80, 40];
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%% Process LH + Drifters by year
x_a=AE_traj(:,2); y_a=AE_traj(:,3); r_a = AE_traj(:,6); date_a=AE_traj(:,14);
DRtoplot = cell(1,3); DRwholetrack = cell(1,3); DRfirsttrack = cell(1,3);
d_ids = cell(1,3); uniqidtracks = cell(1,3);
%1/year
for i = 1:3
    %Get right LH and DrifterList
    lhtoproc = LHRoot(yea(i));
    x_p1=x_a{lhtoproc,1}; y_p1=y_a{lhtoproc,1};
    r_a1=r_a{lhtoproc,1} ;date1=date_a{lhtoproc,1};
    DRlist = DRlists{yea(i),1};
    %Create a logical array for storing Drifter data
    flagged = zeros(length(DRlist),1);
    %For all drifter positions in this year
    for j = 1:length(DRlist)
        %For all LH positions in this year
        for k = 1:length(x_p1)
            %same date
            if (DRlist(j,4) == date1(k))
                %grab 2x drifter radius in lat/lon
                latdegrad = (r_a1(k)/111);
                londegrad = (r_a1(k)/111.320*cosd(y_p1(k)));
                %same spacial area (2x radius)
                if (DRlist(j,2) >= (x_p1(k)-londegrad)) && (DRlist(j,2) <= (x_p1(k)+londegrad)) ...
                        && (DRlist(j,3) >= (y_p1(k)-latdegrad)) && (DRlist(j,3) <= (y_p1(k)+latdegrad))
                    flagged(j) = 1;
                end
            end
        end
    end
    %limit our data array to this scope to grab individual points
    DRtoplot{1,i} = DRlist(logical(flagged),:);
    
    %limit our ids to this scope to grab whole drifter tracks
    d_ids{1,i} = unique(DRlist(logical(flagged),1));
    newflagged = zeros(length(DRlist),1);
    for l = 1:length(DRlist)
        if ismember(DRlist(l,1), d_ids{1,i})
            newflagged(l) = 1;
            
        end
    end
    DRwholetrack{1,i} = DRlist(logical(newflagged),:);
    
    %find first appearance of each drifter
    storedids = zeros(length(DRwholetrack{1,i}),1);
    firstflag = zeros(length(DRwholetrack{1,i}),1);
    for l = 1:length(DRwholetrack{1,i})
        if ~ismember(DRwholetrack{1,i}(l,1), storedids)
            firstflag(l) = 1;
        end
        storedids(l) = DRwholetrack{1,i}(l,1);
    end
    DRfirsttrack{1,i} = DRwholetrack{1,i}(logical(firstflag),:);
    
    %get a matrix of all of the different lines here so we can fit colors
    %to them
    uniqid = cell(1,length(d_ids{1,i}));
    for l = 1:length(d_ids{1,i})
        thisflag = zeros(length(DRwholetrack{1,i}),1);
        for m = 1:length(DRwholetrack{1,i})
            if (DRwholetrack{1,i}(m,1) == d_ids{1,i}(l))
                thisflag(m) = 1;
            end
        end
        uniqid{1,l} = sortrows(DRwholetrack{1,i}(logical(thisflag),:),[4 2]);
    end
    uniqidtracks{1,i} = uniqid;
end

%% Plot everything
figure('units', 'normalized', 'outerposition', [0 0 1 1]);
tiledlayout(1,3,'TileSpacing','none')
anno = cell(1,3); anno{1,1} = "(a) 2006"; anno{1,2} = "(b) 1994"; anno{1,3} = "(c) 1998";

%Plot 3 tiles (Full - Half - Local)
for nTiles = 1:3
    
    t = nexttile;
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    m_coast('patch',[.5 .5 .5]);
    if nTiles == 1
        m_grid('box','fancy','fontsize',32, 'xtick', [44 52 60 68 76]);
    else
        m_grid('box','fancy','fontsize',32, 'yticklabels',[], 'xtick', [44 52 60 68 76]);
    end
    hold on
    m_text(41,23,anno{1,nTiles},'color','w','fontsize',32);
    x_p1 = x_a{LHRoot(yea(nTiles)),1};
    y_p1 = y_a{LHRoot(yea(nTiles)),1};
    %plot the trajectories of eddies
    m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 4);
    hold on
    m_plot(x_p1(1),y_p1(1), '*k', 'MarkerSize', 28, 'LineWidth', 2);
    m_plot(x_p1(1),y_p1(1), 'ok', 'MarkerSize', 28, 'LineWidth', 2);
    %--------------------------------------
    %Uncomment the below for a scatter plot
    %--------------------------------------
    %     %plot the nearpoints of the drifters
    %     m_scatter(DRtoplot{1,nTiles}(:,2), DRtoplot{1,nTiles}(:,3), 12, 'ob', 'LineWidth', 3);
    %     %plot the trajectories of the drifters
    %     m_scatter(DRwholetrack{1,nTiles}(:,2), DRwholetrack{1,nTiles}(:,3), 4, 'or');
    %     %plot the firstpoints of the drifters
    %     m_plot(DRfirsttrack{1,nTiles}(:,2), DRfirsttrack{1,nTiles}(:,3), '*r', 'MarkerSize', 12, 'LineWidth', 2);
    %     m_plot(DRfirsttrack{1,nTiles}(:,2), DRfirsttrack{1,nTiles}(:,3), 'or', 'MarkerSize', 12, 'LineWidth', 2);
    %--------------------------------------
    %Uncomment the below for a line plot
    %--------------------------------------
    c = turbo(length(d_ids{1,nTiles}));
    for i = 1:length(d_ids{1,nTiles})
        m_plot(uniqidtracks{1,nTiles}{1,i}(:,2), uniqidtracks{1,nTiles}{1,i}(:,3), 'Color', c(i,:), 'Linewidth', 1)
        m_plot(uniqidtracks{1,nTiles}{1,i}(1,2), uniqidtracks{1,nTiles}{1,i}(1,3),...
            'Color', c(i,:), 'Marker', '*', 'LineStyle', 'none', 'MarkerSize', 12, 'LineWidth', 2);
        m_plot(uniqidtracks{1,nTiles}{1,i}(1,2), uniqidtracks{1,nTiles}{1,i}(1,3),...
            'Color', c(i,:), 'Marker', 'o', 'LineStyle', 'none', 'MarkerSize', 12, 'LineWidth', 2);
    end
    m_scatter(DRtoplot{1,nTiles}(:,2), DRtoplot{1,nTiles}(:,3), 12, 'ok', 'LineWidth', 3);
    %--------------------------------------
    set(gca,'fontsize',32);
    hold on
end

%% Save Figure
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc