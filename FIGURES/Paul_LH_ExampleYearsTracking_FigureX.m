%% Paul_LH_ExampleYearsTracking_FigureX.m (version 1.1)
%Author: Paul Ernst
%Date Created: 7/22/2021
%Date of Last Update: 7/30/2021
%Update History:
%PE 7/30/2021 - Updated name and added comments
%PE 7/22/2021 - Created
%--------------------------------------
%Purpose: Creates a side-by-side schematic for CKW tracking for one specific year in each of the
%three LH tracking regimes
%Inputs: CMEMS altimetry data from this time period. (ADT, VGOS, UGOS)
%Outputs: One schematic of ADT figures, year over year:
%3 Columns (Localyear, Halfyear, Fullyear)
%3 Rows (Formation (Jan 16), Middle (Mar 26), Death (Jul 21)
%From: 70 East to 90 East; 3 North to 25 North
%With U/V vectors
%--------------------------------------
%Note: ADTs.mat required, produced by those Schematic
%files above. Run both of those ones first.
%% Inputs: ADT
tic
titlestring = "Ernst-ExampleADT-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath(strcat(basepath, 'FUNCTIONS'));
load('AE_Filtered_Trajectories.mat') %load AE trajectories
load('FinalEddyIDLists', 'LHRoot');
% WE EXCLUDE 1993 AND 2019 BECAUSE WE DON'T HAVE FULL YEAR DATA FOR EITHER
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
halfyears = ["1994"];
localyears = ["1998"];
fullyears = ["2006"];
halfyearsN = [2];
localyearsN = [6];
fullyearsN = [14];
latlonbounds = [25, 3, 80, 40]; % [N, S, E, W] lat long boundaries
yearmetadata = [19930101, 20191231]; %[YYYYMMDD, YYYYMMDD] start and end dates of the data
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
load("ADTs.mat")
load("whiteorangecmap.mat")
load("StandardFigureTrajectoryPanelLH.mat")
load("dateCorrelationFinal.mat", "dateLH");
row1d = "0115"; %jan 15th
row1dt = day(datetime(2000, 1, 15),'dayofyear');
row2d = "0326"; %march 26th
row2dt = day(datetime(2000, 3, 26),'dayofyear');
row3d = "0721"; %july 21st?
row3dt = day(datetime(2000, 7, 21),'dayofyear');
quivsp = 3;
rows = [row1dt, row2dt, row3dt];
nRows = length(rows);

%% LH Processing
x_p=AE_traj(:,2); y_p=AE_traj(:,3); d_p = AE_traj(:,14);
xcell = cell(1,3); xcell{1,1} = x_p{LHRoot(fullyearsN),1}; xcell{1,2} = x_p{LHRoot(halfyearsN),1};...
    xcell{1,3} = x_p{LHRoot(localyearsN),1};
ycell = cell(1,3); ycell{1,1} = y_p{LHRoot(fullyearsN),1}; ycell{1,2} = y_p{LHRoot(halfyearsN),1};...
    ycell{1,3} = y_p{LHRoot(localyearsN),1};
toplotx = zeros(3,3); toploty = zeros(3,3);
%Construct date array
datecell = cell(1,3); datecell{1,1} = d_p{LHRoot(fullyearsN),1};
datecell{1,2} = d_p{LHRoot(halfyearsN),1};
datecell{1,3} = d_p{LHRoot(localyearsN),1};

%Get the dates in the correct format
datecell{1,1} = correctdate(datecell{1,1});
datecell{1,2} = correctdate(datecell{1,2});
datecell{1,3} = correctdate(datecell{1,3});

% Find the index point for LH on those given dates
% then use that index point to shunt the x's and y's at that same date
for i = 1:3
    for j = 1:nRows
        ind = nearestpoint(rows(j),datecell{1,i});
        %if this is the same, then this shouldn't exist
        if (ind == length(datecell{1,i})) || (ind == 1)
            toplotx(i,j) = 0;
            toploty(i,j) = 0;
        else
            toplotx(i,j) = xcell{1,i}(ind);
            toploty(i,j) = ycell{1,i}(ind);
        end
    end
end

%% Process Data: ADT
%loops like this are just so I can close the code when looking at overall
%organization, no functional purpose
colFull = cell(3,nRows); %ADT/U/V held for these years
colHalf = cell(3,nRows); %Half years
colLocal = cell(3,nRows); %Local years
for i = 1:nRows
    for j = 1:3
        colFull{j,i} = zeros(length(X),length(Y));
        colHalf{j,i} = zeros(length(X),length(Y));
        colLocal{j,i} = zeros(length(X),length(Y));
    end
end
%Loop thru all years: sorting by month and day (extractBetween)
%then placing in appropriate year afterwards
for i = 1:(length(years))
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        %If it's in the right month, grab it
        monthday = extractBetween(names4later(i,j), 5, 8);
        % ROW 1
        if monthday == row1d %matches first date
            if ismember(years(i), fullyears) %if this is the precursor to a full year
                colFull{1,1} = colFull{1,1} + ADTFinal{i,j};
                colFull{2,1} = colFull{2,1} + UFinal{i,j};
                colFull{3,1} = colFull{3,1} + VFinal{i,j};
            elseif ismember(years(i), halfyears)
                colHalf{1,1} = colHalf{1,1} + ADTFinal{i,j};
                colHalf{2,1} = colHalf{2,1} + UFinal{i,j};
                colHalf{3,1} = colHalf{3,1} + VFinal{i,j};
            elseif ismember(years(i), localyears)
                colLocal{1,1} = colLocal{1,1} + ADTFinal{i,j};
                colLocal{2,1} = colLocal{2,1} + UFinal{i,j};
                colLocal{3,1} = colLocal{3,1} + VFinal{i,j};
            end
            
            % ROW 2
        elseif monthday == row2d %matches first date
            if ismember(years(i), fullyears) %if this is the precursor to a full year
                colFull{1,2} = colFull{1,2} + ADTFinal{i,j};
                colFull{2,2} = colFull{2,2} + UFinal{i,j};
                colFull{3,2} = colFull{3,2} + VFinal{i,j};
            elseif ismember(years(i), halfyears)
                colHalf{1,2} = colHalf{1,2} + ADTFinal{i,j};
                colHalf{2,2} = colHalf{2,2} + UFinal{i,j};
                colHalf{3,2} = colHalf{3,2} + VFinal{i,j};
            elseif ismember(years(i), localyears)
                colLocal{1,2} = colLocal{1,2} + ADTFinal{i,j};
                colLocal{2,2} = colLocal{2,2} + UFinal{i,j};
                colLocal{3,2} = colLocal{3,2} + VFinal{i,j};
            end
            
            %ROW 3
        elseif monthday == row3d %matches first date
            if ismember(years(i), fullyears) %if this is the precursor to a full year
                colFull{1,3} = colFull{1,3} + ADTFinal{i,j};
                colFull{2,3} = colFull{2,3} + UFinal{i,j};
                colFull{3,3} = colFull{3,3} + VFinal{i,j};
            elseif ismember(years(i), halfyears)
                colHalf{1,3} = colHalf{1,3} + ADTFinal{i,j};
                colHalf{2,3} = colHalf{2,3} + UFinal{i,j};
                colHalf{3,3} = colHalf{3,3} + VFinal{i,j};
            elseif ismember(years(i), localyears)
                colLocal{1,3} = colLocal{1,3} + ADTFinal{i,j};
                colLocal{2,3} = colLocal{2,3} + UFinal{i,j};
                colLocal{3,3} = colLocal{3,3} + VFinal{i,j};
            end
        end
    end
end

%Average each of the above over the number of years they have
for i = 1:nRows
    for j = 1:3
        if j == 1
            mod = 100;
        else
            mod = 1;
        end
        colFull{j,i} = colFull{j,i}/length(fullyears).*mod;
        colHalf{j,i} = colHalf{j,i}/length(halfyears).*mod;
        colLocal{j,i} = colLocal{j,i}/length(localyears).*mod;
    end
end

%% Make Figure
%Construct grid
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end

figure('units', 'normalized', 'outerposition', [0 0.0652777777777778 0.796484375 0.917361111111111])
t = tiledlayout(3,3,'TileSpacing','none');
% 3 Panels per column
%----------------------------------------------------------------------------
% FULL YEAR COLUMN
anno = cell(1,3); anno{1,1} = "(a) January 15, 2006"; anno{1,2} = "(b) March 26, 2006"; ...
    anno{1,3} = "(c) July 21, 2006";
for i = 1:nRows
    %1, 4, 7, 10, 13, 16
    nexttile((1+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    m_pcolor(Xgrid,Ygrid,colFull{1,i})
    shading flat
    h1 = m_quiver(Xgrid(1:quivsp:end,1:quivsp:end),Ygrid(1:quivsp:end,1:quivsp:end),colFull{2,i}...
        (1:quivsp:end,1:quivsp:end),colFull{3,i}(1:quivsp:end,1:quivsp:end),0,'-k');
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.5)
    set(h1,'LineWidth',.75)
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',26,'xticklabels',[],'ytick', [4 10 16 22], 'xtick', [44 52 60 68 76]);
    else
        m_grid('box', 'fancy','fontsize',26, 'xtick', [44 52 60 68 76],'ytick', [4 10 16 22]);
    end
    if i == 1
        m_text(75,20,'1 m/s','color','w','fontsize',24)
    end
    %LH PLOT
    m_plot(toplotx(1,i),toploty(1,i), '*k', 'MarkerSize', 28, 'LineWidth', 2);
    m_plot(toplotx(1,i),toploty(1,i), 'ok', 'MarkerSize', 28, 'LineWidth', 2);
    hold on
    colormap(jet)
    % Anno
    hold on
    m_text(41,23,anno{1,i},'color','w','fontsize',24);
    caxis([40 110]);
%     xlabel("Longitude")
%     ylabel("Latitude")
    set(gca,'fontsize',28);
end

%----------------------------------------------------------------------------
% HALF YEAR COLUMN
anno = cell(1,3); anno{1,1} = "(d) January 15, 1994"; anno{1,2} = "(e) March 26, 1994"; ...
    anno{1,3} = "(f) July 21, 1994";
for i = 1:nRows
    nexttile((2+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    m_pcolor(Xgrid,Ygrid,colHalf{1,i})
    shading flat
    h1 = m_quiver(Xgrid(1:quivsp:end,1:quivsp:end),Ygrid(1:quivsp:end,1:quivsp:end),colHalf{2,i}...
        (1:quivsp:end,1:quivsp:end),colHalf{3,i}(1:quivsp:end,1:quivsp:end),0,'-k');
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.5)
    %set(h1,'LineWidth',.75)
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',26,'yticklabels',[],'xticklabels',[],'ytick', [4 10 16 22], 'xtick', [44 52 60 68 76]);
    else
        m_grid('box', 'fancy','fontsize',26,'yticklabels',[], 'xtick', [44 52 60 68 76],'ytick', [4 10 16 22]);
    end
    %LH PLOT
    m_plot(toplotx(2,i),toploty(2,i), '*k', 'MarkerSize', 28, 'LineWidth', 2);
    m_plot(toplotx(2,i),toploty(2,i), 'ok', 'MarkerSize', 28, 'LineWidth', 2);
    hold on
    % Anno
    hold on
    m_text(41,23,anno{1,i},'color','w','fontsize',24);
    caxis([40 110]);
%     xlabel("Longitude")
    set(gca,'fontsize',28);
end

%----------------------------------------------------------------------------
% LOCAL YEAR COLUMN
anno = cell(1,3); anno{1,1} = "(g) January 15, 1998"; anno{1,2} = "(h) March 26, 1998"; ...
    anno{1,3} = "(i) July 21, 1998";
for i = 1:nRows
    ax = nexttile((3+3*(i-1)));
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    m_pcolor(Xgrid,Ygrid,colLocal{1,i})
    shading flat
    h1 = m_quiver(Xgrid(1:quivsp:end,1:quivsp:end),Ygrid(1:quivsp:end,1:quivsp:end),colLocal{2,i}...
        (1:quivsp:end,1:quivsp:end),colLocal{3,i}(1:quivsp:end,1:quivsp:end),0,'-k');
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.5)
    set(h1,'LineWidth',.75)
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',26,'yticklabels',[],'xticklabels',[],'ytick', [4 10 16 22], 'xtick', [44 52 60 68 76]);
    else
        m_grid('box', 'fancy','fontsize',26,'yticklabels',[], 'xtick', [44 52 60 68 76],'ytick', [4 10 16 22]);
    end
    %LH PLOT
    m_plot(toplotx(3,i),toploty(3,i), '*k', 'MarkerSize', 28, 'LineWidth', 2);
    m_plot(toplotx(3,i),toploty(3,i), 'ok', 'MarkerSize', 28, 'LineWidth', 2);
    hold on
    % Anno
    m_text(41,23,anno{1,i},'color','w','fontsize',24);
    caxis([40 110]);
%     xlabel("Longitude")
    set(gca,'fontsize',28);
end
colorbar(gca,'Position',...
    [0.960773499999759 0.226247987117552 0.0156855485534539 0.553945249597424], 'FontSize', 24);
%cb.Layout.Tile = 'east';
annotation(gcf,'arrow',[0.315825476293245 0.331535066208926],...
    [0.87090499194847 0.87090499194847],'Color',[1 1 1],'LineWidth',2,...
    'HeadLength',15);

% Save Figure
%Using Export_Fig for max resolution (magnified, AA'd)
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc

%% Correct date function

function [datelist] = correctdate(datesin)
datelist = zeros(1,length(datesin));
for i = 1:length(datesin)
    date2=datestr(datesin(i));
    daynf=str2double(date2(1:2));
    month=date2(4:6);
    [monthint, ~] = monthconversion(month);
    year=str2double(date2(8:11));
    date3 = datetime([year monthint daynf]);
    datelist(i) = day(date3,'dayofyear');
    %center around the new year
    if (datelist(i) > 300)
        if (mod(i,4) == 0)
            leap = 366;
        else
            leap = 365;
        end
        datelist(i) = datelist(i)-leap;
    end
end
end

