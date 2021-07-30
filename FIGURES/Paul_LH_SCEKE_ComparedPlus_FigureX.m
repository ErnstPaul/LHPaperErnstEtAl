%% Paul_LH_SCEKE_ComparedPlus_FigureX.m (version 1.1)
%Author: Paul Ernst
%Date Created: 7/23/2021
%Date of Last Update: 7/23/2021
%Update History:
%PE 7/27/2021 - Added Legend
%PE 7/23/2021 - Created
%--------------------------------------
%Purpose: Creates yearwise plot of SC region characteristics vs LH
%Inputs: AE_trajs from steps, CE_trajs from steps, LHRoot from final ID, EKEs.m from
%EKEschematics
%Outputs:
%5 plots: Eddy Amp/Radius/EKE for each type of year (3 lines; 3 plots)
%         EKE of Somali Current for each type of year (3 lines; 1 plot)
%         EKE of GW and LH, plotted over time (6 lines, 1 plot)
%--------------------------------------
%% Inputs
tic
%title of figure
titlestring = "Ernst-SCLHCompEx-FigureX.tiff";
%Where are our eddy trajectories located
main_rep='/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/EXTRACTION/EDDY_TRAJECTORIES';
%What's our base path
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
%Add sub-folders of necessary things
addpath(strcat(basepath, 'm_map/'));
addpath(strcat(basepath, 'm_map/private'));
addpath(strcat(basepath, 'export_figs'));
addpath(strcat(basepath, 'FUNCTIONS/'));
%All years
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
%File contains EKEs, names of dates, and an X/Y grid, produced separately
%in EKE Schematic file
load('EKEs.mat')
%Produced from final eddy ID tracking, only need LH and GW Roots
load('FinalEddyIDLists', 'LHRoot', 'GWRoot');
%Indices
% halfyearsN = [2, 7, 11, 19, 21, 27];
% localyearsN = [5, 6, 12, 18];
% fullyearsN = [1, 3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
%     22, 23, 24, 25, 26];
%Indices for example years
halfyearsN = [2];
localyearsN = [6];
fullyearsN = [14];
%Years
% halfyears = [1994, 1999, 2003, 2011, 2013];
% localyears = [1997, 1998, 2004, 2010];
% fullyears = [1995, 1996, 2000, 2001, 2002, 2005, 2006, 2007, 2008, 2009, 2012,...
%     2014, 2015, 2016, 2017, 2018];
%Example years
halfyears = [1994];
localyears = [1998];
fullyears = [2006];
%Produced by eddy tracking steps
load([main_rep '/AE_Filtered_Trajectories.mat'])
load([main_rep '/CE_Filtered_Trajectories.mat'])
latlonbounds = [11, 0, 58, 40]; % [N, S, E, W] lat long boundaries of somali current
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);

%% Process SC EKE
% Loop through and grab EKE for each type of year (1x365 avg.)
% Need to average over time (year by year) and then over area

fullEKEs = processeke(fullyearsN, latlonbounds, EKE, X, Y);
halfEKEs = processeke(halfyearsN, latlonbounds, EKE, X, Y);
localEKEs = processeke(localyearsN, latlonbounds, EKE, X, Y);

%% Process Eddy Properties
%Median: Radius, Amplitude, and EKE for each type of year
%Requires tallying for each individual timestep of each individual year,
%then finding the average of the medians across the years down to (1x365)

%Amp-Rad-EKE: Full
fullProps = cell(1,3);
fullProps{1,1} = sumeddies(AE_traj, CE_traj, 'amplitude', latlonbounds, fullyears);
fullProps{1,2} = sumeddies(AE_traj, CE_traj, 'radius', latlonbounds, fullyears);
fullProps{1,3} = sumeddies(AE_traj, CE_traj, 'eke', latlonbounds, fullyears);

%Amp-Rad-EKE: Half
halfProps = cell(1,3);
halfProps{1,1} = sumeddies(AE_traj, CE_traj, 'amplitude', latlonbounds, halfyears);
halfProps{1,2} = sumeddies(AE_traj, CE_traj, 'radius', latlonbounds, halfyears);
halfProps{1,3} = sumeddies(AE_traj, CE_traj, 'eke', latlonbounds, halfyears);

%Amp-Rad-EKE: Local
localProps = cell(1,3);
localProps{1,1} = sumeddies(AE_traj, CE_traj, 'amplitude', latlonbounds, localyears);
localProps{1,2} = sumeddies(AE_traj, CE_traj, 'radius', latlonbounds, localyears);
localProps{1,3} = sumeddies(AE_traj, CE_traj, 'eke', latlonbounds, localyears);

%% Process LH and GW properties

%EKE: LH
fullLH = ideddyextraction(AE_traj, fullyearsN, 'eke', LHRoot, "LH");
halfLH = ideddyextraction(AE_traj, halfyearsN, 'eke', LHRoot, "LH");
localLH = ideddyextraction(AE_traj, localyearsN, 'eke', LHRoot, "LH");

%EKE: GW
fullGW = ideddyextraction(AE_traj, fullyearsN, 'eke', GWRoot, "GW");
halfGW = ideddyextraction(AE_traj, halfyearsN, 'eke', GWRoot, "GW");
localGW = ideddyextraction(AE_traj, localyearsN, 'eke', GWRoot, "GW");

%% Plotting
%4 plots: Eddy Amp/Radius/EKE for each type of year (3 lines; 3 plots)
%           Total for each type of year (3 lines; 1 plot)
figure('units', 'normalized', 'outerposition', [0 0 1 1])
t = tiledlayout(5,1,'TileSpacing','tight');
%Year in days
ye = 1:365;
%Annotations
anno = cell(1,5); anno{1,1} = "(a) Eddy Amplitude (median value, cm)";
anno{1,2} = "(b) Eddy Radius (median value, km)";
anno{1,3} = "(c) Eddy EKE (median value, cm^2 s^-^2)";
anno{1,4} = "(d) Somali Current EKE (mean value, cm^2 s^-^2)";
anno{1,5} = "(e) LH and GW EKE (cm^2 s^-^2)";

%Annotations' Y coordinates (X is fixed)
annoy = cell(1,5); annoy{1,1} = 36.3; annoy{1,2} = 363;
annoy{1,3} = 4530; annoy{1,4} = 1800; annoy{1,5} = 3500;

%First 3 plots
for nTiles = 1:3
    ax = nexttile;
    plot(ye, fullProps{1,nTiles}, '-b', 'LineWidth', 3);
    hold on
    plot(ye, halfProps{1,nTiles}, '-g', 'LineWidth', 3);
    plot(ye, localProps{1,nTiles}, '-r', 'LineWidth', 3);
    xlim([1 365]);
    text(3, annoy{1,nTiles}, anno{1,nTiles}, 'Fontsize', 32);
    xticks(1:30:360);
    if nTiles == 3
       yticks([0, 2500, 5000]); 
    end
    xticklabels([]);
    set(gca,'fontsize',32);
    grid on
    if nTiles == 1
        lgd = legend({'2006', '1994', '1998'}, 'FontSize', 28, 'Location', 'northeast');
        lgd.NumColumns = 3;
    end
end

%Fourth plot
ax = nexttile;
plot(ye, fullEKEs(1,:), '-b', 'LineWidth', 3);
hold on
plot(ye, halfEKEs(1,:), '-g', 'LineWidth', 3);
plot(ye, localEKEs(1,:), '-r', 'LineWidth', 3);
xlim([1 365]);
text(3, annoy{1,4}, anno{1,4}, 'Fontsize', 32);
xticks(1:30:360);
xticklabels([]);
set(gca,'fontsize',32);
grid on

%Fifth plot
ax = nexttile;
%LH - GW
%this order mismatch is for the legend's sake
plot(ye, fullLH(1,:), '-b', 'LineWidth', 3);
hold on
plot(ye, fullGW(1,:), '--b', 'LineWidth', 3);
plot(ye, halfLH(1,:), '-g', 'LineWidth', 3);
plot(ye, halfGW(1,:), '--g', 'LineWidth', 3);
plot(ye, localLH(1,:), '-r', 'LineWidth', 3);
plot(ye, localGW(1,:), '--r', 'LineWidth', 3);
xlim([1 365]);
text(3, annoy{1,5}, anno{1,5}, 'Fontsize', 32);
xticks(1:30:360);
xticklabels(["Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec"]);
set(gca,'fontsize',32);
grid on
lgd = legend({'LH 2006', 'GW 2006', 'LH 1994', 'GW 1994', 'LH 1998', 'GW 1998'}, 'FontSize', 28, 'Location', 'northeast');
lgd.NumColumns = 3;

% Save Figure
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc
%% EKE Processing Function
%Extract all the juicy EKE data from the region for this time period

function matEKEprocessed = processeke(yearsN, latlonbounds, matEKE, X, Y)

preprocessedEKEs = cell(1,365);
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);

%fill summation matrices with zeroes
for i = 1:365
    preprocessedEKEs{1,i} = zeros(size(matEKE{1,1}));
end

%grab the timewise average
for i = 1:length(yearsN)
    for j = 1:365
        preprocessedEKEs{1,j} = preprocessedEKEs{1,j} + matEKE{yearsN(i),j};
    end
end
for i = 1:365
    preprocessedEKEs{1,i} = preprocessedEKEs{1,i}./length(yearsN);
end

%grab the spacewise average
lamin=nearestpoint(SL, Y);
lamax=nearestpoint(NL, Y);
lomin=nearestpoint(WL, X);
lomax=nearestpoint(EL, X);

%sum over somali current per category
matEKEprocessed = zeros(1,365);
for i = 1:365
    currdata = preprocessedEKEs{1,i};
    currdata = currdata(lomin:lomax,lamin:lamax);
    matEKEprocessed(1,i) = sum(sum(currdata,'omitnan'));
end
totalgrid = (lomax-lomin) * (lamax-lamin);
%Average across area and convert to the units we want
matEKEprocessed = matEKEprocessed./totalgrid.*10000;
end

%% Eddy Processing Function
%Median: Radius, Amplitude, and EKE for each type of year
%Requires tallying for each individual timestep of each individual year,
%then finding the average of the medians across the years down to (1x365)

function eddyFinalProp = sumeddies(AE_traj, CE_traj, inputstr, latlonbounds, yearsN)
%grab data
Xa=AE_traj(:,2); Ya=AE_traj(:,3);
Xc=CE_traj(:,2); Yc=CE_traj(:,3);
date_a=AE_traj(:,14); date_c=CE_traj(:,14);
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);

%property defining
if strcmp(inputstr, 'amplitude')
    propa = AE_traj(:,8); propc = CE_traj(:,8);
    ekeflag = 0;
elseif strcmp(inputstr, 'radius')
    propa = AE_traj(:,6); propc = CE_traj(:,6);
    ekeflag = 0;
elseif strcmp(inputstr, 'eke')
    propa = AE_traj(:,9); propc = CE_traj(:,9);
    ekeflag = 1;
end

%Logic for loops below
numCE = length(Xc);
numAE = length(Xa);

%X by 365 preholding matrix
eddypreProp = cell(length(yearsN),365);

%Logic for processing AEs -- go through every AE
for i = 1:numAE
    Xa1 = (Xa{i,1}); Ya1 = (Ya{i,1});
    %Go through every date in this AE
    for j = 1:length(Xa1)
        Xa2 = Xa1(j); Ya2 = Ya1(j);
        %In spatial boundary
        if ((Xa2 > WL) && (Xa2 < EL) && (Ya2 > SL) && (Ya2 < NL))
            date=date_a{i,1};
            date2 = date(j);
            date3=datestr(date2);
            daynf=str2double(date3(1,1:2));
            month=date3(1,4:6);
            [monthint, ~] = monthconversion(month);
            year=str2double(date3(1,8:11));
            date4 = datetime([year monthint daynf]);
            date5 = day(date4,'dayofyear');
            %In temporal boundary
            [logi, indi] = ismember(year, yearsN);
            if (logi && date5 <= 365)
                eddypreProp{indi,date5} = horzcat(eddypreProp{indi, date5}, propa{i,1}(j));
            end
        end
    end
end

%Logic for processing CEs -- go through every CE
for i = 1:numCE
    Xc1 = (Xc{i,1}); Yc1 = (Yc{i,1});
    %Go through every date in this CE
    for j = 1:length(Xc1)
        Xc2 = Xc1(j); Yc2 = Yc1(j);
        %In spatial boundary
        if ((Xc2 > WL) && (Xc2 < EL) && (Yc2 > SL) && (Yc2 < NL))
            date=date_c{i,1};
            date2 = date(j);
            date3=datestr(date2);
            daynf=str2double(date3(1,1:2));
            month=date3(1,4:6);
            [monthint, ~] = monthconversion(month);
            year=str2double(date3(1,8:11));
            date4 = datetime([year monthint daynf]);
            date5 = day(date4,'dayofyear');
            %In temporal boundary
            [logi, indi] = ismember(year, yearsN);
            if (logi && date5 <= 365)
                eddypreProp{indi,date5} = horzcat(eddypreProp{indi, date5}, propc{i,1}(j));
            end
        end
    end
end

% Now we have an X by 365 by Y matrix; need to median across the Y's and
% average across the X's to get a 1x365
eddyFinalProp = zeros(1,365);
med = zeros(length(yearsN),365);
for i = 1:length(yearsN)
    for j = 1:365
        %Median
        med(i,j) = median(eddypreProp{i,j});
    end
end
%average the medians and return
for i = 1:365
    eddyFinalProp(1,i) = mean(med(:,i));
end

if ekeflag
    eddyFinalProp = eddyFinalProp.*10000;
end

end

%% LH/GW Processing Function

function avgEddy = ideddyextraction(AE_traj, yearsN, inputstr, Root, inputed)
%grab data
Xa=AE_traj(:,2); Ya=AE_traj(:,3);
date_a=AE_traj(:,14);

%property defining
if strcmp(inputstr, 'amplitude')
    propa = AE_traj(:,8);
    ekeflag = 0;
elseif strcmp(inputstr, 'radius')
    propa = AE_traj(:,6);
    ekeflag = 0;
elseif strcmp(inputstr, 'eke')
    propa = AE_traj(:,9);
    ekeflag = 1;
end

if strcmp(inputed, 'LH')
    lhflag = 1;
else
    lhflag = 1;
end

%Logic for loops below
numRoots = length(yearsN);

%X by 365 preholding matrix
avgEddy = zeros(1,365);
eddycount = zeros(1,365);

%Logic for processing AEs -- go through every AE
for i = 1:numRoots
    Xa1 = (Xa{Root(yearsN(i)),1}); Ya1 = (Ya{Root(yearsN(i)),1});
    %Go through every date in this AE
    for j = 1:length(Xa1)
        Xa2 = Xa1(j); Ya2 = Ya1(j);
        date=date_a{Root(yearsN(i)),1};
        date2 = date(j);
        date3=datestr(date2);
        daynf=str2double(date3(1,1:2));
        month=date3(1,4:6);
        [monthint, ~] = monthconversion(month);
        year=str2double(date3(1,8:11));
        date4 = datetime([year monthint daynf]);
        date5 = day(date4,'dayofyear');
        if lhflag
            %fairly critical line that changes early dates to negatives
            if ((date5 > 300) && (j < 100))
                if (mod(yearsN(i),4) == 0)
                    leap = 366;
                else
                    leap = 365;
                end
                date5 = date5-leap;
            end
        end
        %not using negative dates
        if ((date5 > 0) && (date5 <= 365))
            avgEddy(1,date5) = avgEddy(1, date5) + propa{Root(yearsN(i)),1}(j);
            eddycount(1,date5) = eddycount(1,date5) + 1;
        end
    end
end
%Average across all times we saw this at this timestamp
if ekeflag
    modi = 10000;
else
    modi = 1;
end
avgEddy = avgEddy./eddycount.*modi;
end
