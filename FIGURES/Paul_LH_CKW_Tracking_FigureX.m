%% Paul_LH_CKW_Tracking_FigureX.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/20/2021
%Date of Last Update: 7/30/2021
%Update History:
%PE 7/30/2021 - Updated name and comments.
%PE 7/20/2021 - Created
%--------------------------------------
%Purpose: Creates a side-by-side schematic for CKW tracking in each of the
%three LH tracking regimes
%Inputs: CMEMS altimetry data from this time period. (SLA, VGOS, UGOS)
%Outputs: One schematic of SLA figures, year over year:
%3 Columns (Local, Half, Full)
%6 Rows (Oct 13, Nov 3, Nov 24, Dec 15, Jan 5th, Jan 26th)
%From: 70 East to 90 East; 3 North to 25 North
%With U/V vectors
%--------------------------------------
%Note: SLAs.mat and EKEs.mat are both required, produced by those Schematic
%files above. Run both of those ones first.
%% Inputs: SLA
tic
titlestring = "Ernst-CKW-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
addpath(strcat(basepath, 'FUNCTIONS'));
% WE EXCLUDE 1993 AND 2019 BECAUSE WE DON'T HAVE FULL YEAR DATA FOR EITHER
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018"];
halfyears = ["1994", "1999", "2003", "2011", "2013"];
localyears = ["1997", "1998", "2004", "2010"];
fullyears = ["1995", "1996", "2000", "2001", "2002", "2005", "2006", "2007", "2008", "2009", "2012"...
    "2014", "2015", "2016", "2017", "2018"];
halfyearsN = [2, 7, 11, 19, 21, 27];
localyearsN = [5, 6, 12, 18];
fullyearsN = [1, 3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
    22, 23, 24, 25, 26];
latlonbounds = [25, 3, 95, 60]; % [N, S, E, W] lat long boundaries
yearmetadata = [19940101, 20191231]; %[YYYYMMDD, YYYYMMDD] start and end dates of the data
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%load data needed
load("SLAs.mat") %SLA
load("whiteorangecmap.mat") %colormap for the figure
load("StandardFigureTrajectoryPanelLH.mat") %data for LH position
load("dateCorrelationFinal.mat", "dateLH"); %data for LH date
nRows = 6;
row1d = "1013"; %oct 13
row1dt = day(datetime(2000, 10, 13),'dayofyear');
row2d = "1103"; %nov 3
row2dt = day(datetime(2000, 11, 03),'dayofyear');
row3d = "1124"; %nov 24
row3dt = day(datetime(2000, 11, 24),'dayofyear');
row4d = "1215"; %dec 15
row4dt = day(datetime(2000, 12, 15),'dayofyear')-365;
row5d = "0105"; %jan 5
row5dt = day(datetime(2000, 01, 05),'dayofyear');
row6d = "0126"; %jan 26
row6dt = day(datetime(2000, 01, 26),'dayofyear');
quivsp = 5;
rows = [row1dt, row2dt, row3dt, row4dt, row5dt, row6dt];
nRows = length(rows);
%% LH Processing
xcell = cell(1,3); xcell{1,1} = toplotTrajLH{1,3}; xcell{1,2} = toplotTrajLH{1,1};...
    xcell{1,3} = toplotTrajLH{1,2};
ycell = cell(1,3); ycell{1,1} = toplotTrajLH{2,3}; ycell{1,2} = toplotTrajLH{2,1};...
    ycell{1,3} = toplotTrajLH{2,2};
toplotx = zeros(3,6); toploty = zeros(3,6);
%Construct date array
datecell = cell(1,3); datecell{1,1} = round(mean(dateLH(fullyearsN))):(length(xcell{1,1})+round(mean(dateLH(fullyearsN))))-1;
datecell{1,2} = round(mean(dateLH(halfyearsN))):(length(xcell{1,2})+round(mean(dateLH(halfyearsN))))-1;
datecell{1,3} = round(mean(dateLH(localyearsN))):(length(xcell{1,3})+round(mean(dateLH(localyearsN))))-1;
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
            toplotx(i,j) = mean(xcell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
            toploty(i,j) = mean(ycell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
        end
    end
end

%% Process Data: ADT
%loops like this are just so I can close the code when looking at overall
%organization, no functional purpose
colFull = cell(3,nRows); %SLA/U/V held for these years
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
for i = 1:(length(years)-1)
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
            if ismember(years(i+1), fullyears) %if this is the precursor to a full year
                colFull{1,1} = colFull{1,1} + SLAFinal{i,j};
                colFull{2,1} = colFull{2,1} + UFinal{i,j};
                colFull{3,1} = colFull{3,1} + VFinal{i,j};
            elseif ismember(years(i+1), halfyears)
                colHalf{1,1} = colHalf{1,1} + SLAFinal{i,j};
                colHalf{2,1} = colHalf{2,1} + UFinal{i,j};
                colHalf{3,1} = colHalf{3,1} + VFinal{i,j};
            elseif ismember(years(i+1), localyears)
                colLocal{1,1} = colLocal{1,1} + SLAFinal{i,j};
                colLocal{2,1} = colLocal{2,1} + UFinal{i,j};
                colLocal{3,1} = colLocal{3,1} + VFinal{i,j};
            end
            
            % ROW 2
        elseif monthday == row2d %matches first date
            if ismember(years(i+1), fullyears) %if this is the precursor to a full year
                colFull{1,2} = colFull{1,2} + SLAFinal{i,j};
                colFull{2,2} = colFull{2,2} + UFinal{i,j};
                colFull{3,2} = colFull{3,2} + VFinal{i,j};
            elseif ismember(years(i+1), halfyears)
                colHalf{1,2} = colHalf{1,2} + SLAFinal{i,j};
                colHalf{2,2} = colHalf{2,2} + UFinal{i,j};
                colHalf{3,2} = colHalf{3,2} + VFinal{i,j};
            elseif ismember(years(i+1), localyears)
                colLocal{1,2} = colLocal{1,2} + SLAFinal{i,j};
                colLocal{2,2} = colLocal{2,2} + UFinal{i,j};
                colLocal{3,2} = colLocal{3,2} + VFinal{i,j};
            end
            
            %ROW 3
        elseif monthday == row3d %matches first date
            if ismember(years(i+1), fullyears) %if this is the precursor to a full year
                colFull{1,3} = colFull{1,3} + SLAFinal{i,j};
                colFull{2,3} = colFull{2,3} + UFinal{i,j};
                colFull{3,3} = colFull{3,3} + VFinal{i,j};
            elseif ismember(years(i+1), halfyears)
                colHalf{1,3} = colHalf{1,3} + SLAFinal{i,j};
                colHalf{2,3} = colHalf{2,3} + UFinal{i,j};
                colHalf{3,3} = colHalf{3,3} + VFinal{i,j};
            elseif ismember(years(i+1), localyears)
                colLocal{1,3} = colLocal{1,3} + SLAFinal{i,j};
                colLocal{2,3} = colLocal{2,3} + UFinal{i,j};
                colLocal{3,3} = colLocal{3,3} + VFinal{i,j};
            end
            
            %ROW 4
        elseif monthday == row4d %matches first date
            if ismember(years(i+1), fullyears) %if this is the precursor to a full year
                colFull{1,4} = colFull{1,4} + SLAFinal{i,j};
                colFull{2,4} = colFull{2,4} + UFinal{i,j};
                colFull{3,4} = colFull{3,4} + VFinal{i,j};
            elseif ismember(years(i+1), halfyears)
                colHalf{1,4} = colHalf{1,4} + SLAFinal{i,j};
                colHalf{2,4} = colHalf{2,4} + UFinal{i,j};
                colHalf{3,4} = colHalf{3,4} + VFinal{i,j};
            elseif ismember(years(i+1), localyears)
                colLocal{1,4} = colLocal{1,4} + SLAFinal{i,j};
                colLocal{2,4} = colLocal{2,4} + UFinal{i,j};
                colLocal{3,4} = colLocal{3,4} + VFinal{i,j};
            end
            
            %ROW 5
        elseif monthday == row5d %matches first date
            if ismember(years(i), fullyears) %if this is a full year
                colFull{1,5} = colFull{1,5} + SLAFinal{i,j};
                colFull{2,5} = colFull{2,5} + UFinal{i,j};
                colFull{3,5} = colFull{3,5} + VFinal{i,j};
            elseif ismember(years(i), halfyears)
                colHalf{1,5} = colHalf{1,5} + SLAFinal{i,j};
                colHalf{2,5} = colHalf{2,5} + UFinal{i,j};
                colHalf{3,5} = colHalf{3,5} + VFinal{i,j};
            elseif ismember(years(i), localyears)
                colLocal{1,5} = colLocal{1,5} + SLAFinal{i,j};
                colLocal{2,5} = colLocal{2,5} + UFinal{i,j};
                colLocal{3,5} = colLocal{3,5} + VFinal{i,j};
            end
            
            %ROW 6
        elseif monthday == row6d %matches first date
            if ismember(years(i), fullyears) %if this is a full year
                colFull{1,6} = colFull{1,6} + SLAFinal{i,j};
                colFull{2,6} = colFull{2,6} + UFinal{i,j};
                colFull{3,6} = colFull{3,6} + VFinal{i,j};
            elseif ismember(years(i), halfyears)
                colHalf{1,6} = colHalf{1,6} + SLAFinal{i,j};
                colHalf{2,6} = colHalf{2,6} + UFinal{i,j};
                colHalf{3,6} = colHalf{3,6} + VFinal{i,j};
            elseif ismember(years(i), localyears)
                colLocal{1,6} = colLocal{1,6} + SLAFinal{i,j};
                colLocal{2,6} = colLocal{2,6} + UFinal{i,j};
                colLocal{3,6} = colLocal{3,6} + VFinal{i,j};
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
row1d = "1013"; %oct 13
row2d = "1103"; %nov 3
row3d = "1124"; %nov 24
row4d = "1215"; %dec 15
row5d = "0105"; %jan 5
row6d = "0126"; %jan 26
figure('units', 'normalized', 'outerposition', [0 0.0652777777777778 0.389453125 0.917361111111111])
t = tiledlayout(6,3,'TileSpacing','none');
% 6 Panels per column
%m_quiver(84, 12, 4.5, 0, 'color', 'k')
%----------------------------------------------------------------------------
% FULL YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(a) October 13"; anno{1,2} = "(b) November 3"; ...
    anno{1,3} = "(c) November 24"; anno{1,4} = "(d) December 15"; ...
    anno{1,5} = "(e) January 5"; anno{1,6} = "(f) January 26";
for i = 1:nRows
    %1, 4, 7, 10, 13, 16
    nexttile((1+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    m_pcolor(Xgrid,Ygrid,colFull{1,i})
    shading flat
    %quiver spacing
    h1 = m_quiver(Xgrid(1:quivsp:end,1:quivsp:end),Ygrid(1:quivsp:end,1:quivsp:end),colFull{2,i}...
        (1:quivsp:end,1:quivsp:end),colFull{3,i}(1:quivsp:end,1:quivsp:end),0,'-k');
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.5)
    set(h1,'LineWidth',.75)
    m_coast('patch',[.5 .5 .5]);
    %getting the grid right
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',22,'xticklabels',[], 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    else
        m_grid('box', 'fancy','fontsize',22, 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    end
    if i == 1
        m_text(75,20,'3 m/s','color','w','fontsize',14)
    end
    %LH PLOT
    m_plot(toplotx(1,i),toploty(1,i), '*g', 'MarkerSize', 22, 'LineWidth', 2);
    m_plot(toplotx(1,i),toploty(1,i), 'og', 'MarkerSize', 22, 'LineWidth', 2);
    hold on
    colormap(CustomColormap)
    % Anno
    hold on
    m_text(73,23.5,anno{1,i},'color','w','fontsize',18);
    set(gca,'fontsize',24);
    caxis([0 12]);
%     xlabel("Longitude")
%     ylabel("Latitude")
end

%----------------------------------------------------------------------------
% HALF YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(g) October 13"; anno{1,2} = "(h) November 3"; ...
    anno{1,3} = "(i) November 24"; anno{1,4} = "(j) December 15"; ...
    anno{1,5} = "(k) January 5"; anno{1,6} = "(l) January 26";
for i = 1:nRows
    nexttile((2+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    m_pcolor(Xgrid,Ygrid,colHalf{1,i})
    shading flat
    h1 = m_quiver(Xgrid(1:quivsp:end,1:quivsp:end),Ygrid(1:quivsp:end,1:quivsp:end),colHalf{2,i}...
        (1:quivsp:end,1:quivsp:end),colHalf{3,i}(1:quivsp:end,1:quivsp:end),0,'-k');
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.5)
    set(h1,'LineWidth',.75)
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[],'xticklabels',[], 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    else
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[], 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    end
    %LH PLOT
    m_plot(toplotx(2,i),toploty(2,i), '*g', 'MarkerSize', 22, 'LineWidth', 2);
    m_plot(toplotx(2,i),toploty(2,i), 'og', 'MarkerSize', 22, 'LineWidth', 2);
    hold on
    % Anno
    hold on
    m_text(73,23.5,anno{1,i},'color','w','fontsize',18);
    set(gca,'fontsize',24);
    caxis([0 12]);
%     xlabel("Longitude")
end

%----------------------------------------------------------------------------
% LOCAL YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(m) October 13"; anno{1,2} = "(n) November 3"; ...
    anno{1,3} = "(o) November 24"; anno{1,4} = "(p) December 15"; ...
    anno{1,5} = "(q) January 5"; anno{1,6} = "(r) January 26";
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
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[],'xticklabels',[], 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    else
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[], 'xtick', [66 74 82 90],'ytick', [6 12 18 24]);
    end
    %LH PLOT
    m_plot(toplotx(3,i),toploty(3,i), '*g', 'MarkerSize', 22, 'LineWidth', 2);
    m_plot(toplotx(3,i),toploty(3,i), 'og', 'MarkerSize', 22, 'LineWidth', 2);
    hold on
    % Anno
    m_text(73,23.5,anno{1,i},'color','w','fontsize',18);
    set(gca,'fontsize',24);
    caxis([0 12]);
%     xlabel("Longitude")
end
colorbar(gca,'Position',...
    [0.9210481444333 0.223832528180354 0.0296687014448362 0.55877616747182], 'FontSize', 24);
annotation(gcf,'arrow',[0.217738178598295 0.24974924774323],...
    [0.882982286634461 0.882982286634461],'Color','w','LineWidth',2,...
    'HeadLength',15);

%% Save Figure
%Using Export_Fig for max resolution (magnified, AA'd)
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc

