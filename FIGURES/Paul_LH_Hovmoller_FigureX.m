%% Paul_LH_Hovmoller_FigureX.m (version 1.0)
%Author: Paul Ernst
%Date Created: 7/20/2021
%Date of Last Update: 7/20/2021
%Update History:
%PE 7/20/2021 - Created
%--------------------------------------
%Purpose: Puts together a tri-panel-plot of hovmollers
%Inputs: SLA or SLA, Average Eddy Tracks
%Outputs: One figure, 3 columns, 1 row (Full/Half/Local)
%--------------------------------------
tic
titlestring = "Ernst-HovLHAvg-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/FUNCTIONS');
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
load("StandardFigureTrajectoryPanelLH"); load('FinalEddyIDLists', 'LHRoot');
load("dateCorrelationFinal.mat", "dateLH"); load('AE_Filtered_Trajectories.mat'); %load AE trajectories
%AVERAGE INPUTS
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
halfyearsN = [2, 7, 11, 19, 21, 27];
localyearsN = [5, 6, 12, 18];
fullyearsN = [1,3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
    22, 23, 24, 25,26];
%EXAMPLE INPUTS
% years = ["1994", "1998", "2006"];
% halfyearsN = [1];
% localyearsN = [2];
% fullyearsN = [3];
%
latlonbounds = [9 7 79.8 49.4];
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
datearray = 1993:2019;
timebounds = [0101 0730];
load('SLAs.mat', 'SLAFinal', 'names4later', 'X', 'Y')
%% Grab and process date from LH for later: AVERAGE
%half-local-full
xcell = cell(1,3); xcell{1,1} = toplotTrajLH{1,3}; xcell{1,2} = toplotTrajLH{1,1};...
    xcell{1,3} = toplotTrajLH{1,2};
datecell = cell(1,3); datecell{1,1} = round(mean(dateLH(fullyearsN))):(length(xcell{1,1})+round(mean(dateLH(fullyearsN))))-1;
datecell{1,2} = round(mean(dateLH(halfyearsN))):(length(xcell{1,2})+round(mean(dateLH(halfyearsN))))-1;
datecell{1,3} = round(mean(dateLH(localyearsN))):(length(xcell{1,3})+round(mean(dateLH(localyearsN))))-1;
toplotdate = cell(1,3);
toplotx = cell(1,3);
%Find the index point for LH on those given dates
%then use that index point to shunt the x's and y's at that same date
for i = 1:3
    ind = nearestpoint(1,datecell{1,i});
    toplotdate{1,i} = datecell{1,i}(ind:end);
    toplotx{1,i} = xcell{1,i}(ind:end);
end

%% Grab and process date from LH for later: EXAMPLES
% x_p=AE_traj(:,2); date_a=AE_traj(:,14);
% yea = [14 2 6];
% toplotx = cell(1,3); toplotdate = cell(1,3);
% %find january 1st on these lines and get the goods
% for i = 1:3
%         date=date_a{LHRoot(yea(i)),1};
%         date2=datestr(date);
%         [datelen, ~] = size(date2);
%         for j = 1:datelen
%             date3 = convertCharsToStrings(date2(j,:));
%             day = extractBefore(date3,3);
%             month = extractBetween(date3,4,6);
%             if (strcmp(day, "01") && strcmp(month, "Jan"))
%                 startdex = j;
%                 break;
%             end
%         end
%     toplotx{1,i} = double(x_p{LHRoot(yea(i)),1}(startdex:end));
%     toplotdate{1,i} = 1:(datelen-startdex+1);
% end

%% Process SLA Averages Across Space and Time
%finding bounds
NLp = nearestpoint(latlonbounds(1), Y);
SLp = nearestpoint(latlonbounds(2), Y);
ELp = nearestpoint(latlonbounds(3), X);
WLp = nearestpoint(latlonbounds(4), X);
%average across time and space
SLATotal = cell(1,3); % each one holds a day-by-day averaged matrix (~200 by 160?)
%find date length
count = 0;
for i = 1:1
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        intname = str2double(extractBetween(names4later(i,j),5,8));
        if ((intname >= timebounds(1)) && (intname <= timebounds(2)))
            count = count + 1;
        end
    end
end
%set matrix
for i = 1:3
    SLATotal{1,i} = zeros((ELp-WLp+1),count);
end
%iterate across years
count = 1;
for j = 1:365
    intname = str2double(extractBetween(names4later(1,j),5,8));
    if ((intname >= timebounds(1)) && (intname <= timebounds(2)))
        %spacewise avg
        for i = 1:length(years)
            %timewise avg
            if ismember(i, fullyearsN)
                SLATotal{1,1}(:,count) = SLATotal{1,1}(:,count) + nanmean(SLAFinal{i,j}(WLp:ELp,SLp:NLp),2);
            elseif ismember(i, halfyearsN)
                SLATotal{1,2}(:,count) = SLATotal{1,2}(:,count) + nanmean(SLAFinal{i,j}(WLp:ELp,SLp:NLp),2);
            elseif ismember(i, localyearsN)
                SLATotal{1,3}(:,count) = SLATotal{1,3}(:,count) + nanmean(SLAFinal{i,j}(WLp:ELp,SLp:NLp),2);
            end
        end
        SLATotal{1,1}(:,count) = SLATotal{1,1}(:,count)./length(fullyearsN);
        SLATotal{1,2}(:,count) = SLATotal{1,2}(:,count)./length(halfyearsN);
        SLATotal{1,3}(:,count) = SLATotal{1,3}(:,count)./length(localyearsN);
        count = count + 1;
    end
end
count = count-1;
save("AverageHovmollerData.mat", 'SLATotal', 'count', 'X', 'ELp', 'WLp')
%% Create plots
figure('units', 'normalized', 'outerposition', [0 0.0652777777777778 0.691796875 0.917361111111111])
t = tiledlayout(1,3,'TileSpacing','tight');

%loop thru tiles
anno = cell(1,3); anno{1,1} = "(a)"; anno{1,2} = "(b)"; anno{1,3} = "(c)";
annox = [77, 75, 74.953121801433]; annoy = [205, 207, 196.415633937083];
for i = 1:3
    ax = nexttile;
    s = pcolor(X(WLp:ELp),1:count,transpose(SLATotal{1,i}.*100));
    s.FaceColor = 'interp';
    s.EdgeColor = 'none';
    hold on
    [C, h] = contour(X(WLp:ELp),1:count,transpose(SLATotal{1,i}.*100), '-k', 'ShowText', 'on', 'LineWidth', 2);
    clabel(C,h,'FontWeight','bold', 'FontSize', 12)
    hold on
    s.EdgeColor = 'none';
    xlim([WL+.1 EL-.1]);
    ylim([1 count]);
    yticks(1:30:210);
    yticklabels(["Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul."]);
    caxis([-20 20]); %sla Cmap
    %caxis([60 95]); %adt Cmap
    xticklabels([50 55 60 65 70 75 80])
    text(annox(i),annoy(i),anno{1,i}, 'Color', 'k', 'FontSize', 40);
    ax = gca;
    colormap(redblue);
    set(gca,'FontSize',26)
    view(0,90);
    grid on
    if i == 1
        ylabel("Month")
    end
    xlabel("Longitude (°E)")
    
    %Need to correct for average start date of LH
    hundreds = 100.* ones(length(toplotdate{1,i}),1);
    plot3(toplotx{1,i},toplotdate{1,i},hundreds, 'LineStyle', '-', 'Color', 'g', 'LineWidth', 4);
end
cb = colorbar(gca,'Position',...
    [0.948051948051948 0.21658615136876 0.0220214568040654 0.59098228663446], 'FontSize', 24);
%cb.Layout.Tile = 'east';

%% Save Figure
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc

%%
function c = redblue(m)
%REDBLUE    Shades of red and blue color map
%   REDBLUE(M), is an M-by-3 matrix that defines a colormap.
%   The colors begin with bright blue, range through shades of
%   blue to white, and then through shades of red to bright red.
%   REDBLUE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(redblue)
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG,
%   COLORMAP, RGBPLOT.
%   Adam Auton, 9th October 2009
if nargin < 1, m = size(get(gcf,'colormap'),1); end
if (mod(m,2) == 0)
    % From [0 0 1] to [1 1 1], then [1 1 1] to [1 0 0];
    m1 = m*0.5;
    r = (0:m1-1)'/max(m1-1,1);
    g = r;
    r = [r; ones(m1,1)];
    g = [g; flipud(g)];
    b = flipud(r);
else
    % From [0 0 1] to [1 1 1] to [1 0 0];
    m1 = floor(m*0.5);
    r = (0:m1-1)'/max(m1,1);
    g = r;
    r = [r; ones(m1+1,1)];
    g = [g; 1; flipud(g)];
    b = flipud(r);
end
c = [r g b];
end