%% Paul_SCEKEComparison_Figure3.m (version 1.0)
%Author: Paul Ernst
%Date Created: 6/9/2021
%Date of Last Update: 6/9/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Creates plot of EKE per season in the SC region, compared over
%year and to EKE from Eddies alone
%Inputs: EKEs.mat (see EKE_Schematic); traj matfiles (see steps files)
%Outputs: 4 Line graphs from 1993-2019 with 2 lines each
%--------------------------------------
%% Inputs
main_rep='/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/EXTRACTION/EDDY_TRAJECTORIES';
titlestring = "Figure3_EKECompared.png";
pathtodata = '/Volumes/Lacie-SAN/SAN2/CMEMS/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/';
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath(strcat(basepath, 'FUNCTIONS'));
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
load('EKEs.mat')
load([main_rep '/AE_Filtered_Trajectories.mat'])
load([main_rep '/CE_Filtered_Trajectories.mat'])
latlonbounds = [11, 0, 58, 40]; % [N, S, E, W] lat long boundaries of somali current
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%% Process Data
%% Loop through all years: normal EKE
clear SumFinal
clear WinFinal
clear MarFinal
clear OctFinal
SumMon = ["06", "07", "08", "09"];
sumcount = 0;
WinMon = ["11", "12", "01", "02"];
wincount = 0;
Mar = ["03"];
marcount = 0;
Oct = ["10"];
octcount = 0;
for i = 1:27
    if (mod(i,4) == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        month = extractBetween(names4later(i,j), 5, 6);
        if ismember(month, SumMon)
            sumcount = sumcount + 1;
            SumFinal(sumcount,1) = EKE(i,j);
        elseif ismember(month, WinMon)
            wincount = wincount + 1;
            WinFinal(wincount,1) = EKE(i,j);
        elseif ismember(month, Mar)
            marcount = marcount + 1;
            MarFinal(marcount,1) = EKE(i,j);
        elseif ismember(month, Oct)
            octcount = octcount + 1;
            OctFinal(octcount,1) = EKE(i,j);
        end
    end
end

%% Sum over Somali Current: normal EKE
lamin=nearestpoint(SL, Y);
lamax=nearestpoint(NL, Y);
lomin=nearestpoint(WL, X);
lomax=nearestpoint(EL, X);

%sum over somali current per category
addemupSum = zeros(sumcount,1);
for i = 1:sumcount
    currdata = SumFinal{i,1};
    currdata = currdata(lomin:lomax,lamin:lamax);
    addemupSum(i,1) = sum(sum(currdata,'omitnan'));
end

addemupWin = zeros(wincount,1);
for i = 1:wincount
    currdata = WinFinal{i,1};
    currdata = currdata(lomin:lomax,lamin:lamax);
    addemupWin(i,1) = sum(sum(currdata,'omitnan'));
end

addemupMar = zeros(marcount,1);
for i = 1:marcount
    currdata = MarFinal{i,1};
    currdata = currdata(lomin:lomax,lamin:lamax);
    addemupMar(i,1) = sum(sum(currdata,'omitnan'));
end

addemupOct = zeros(octcount,1);
for i = 1:octcount
    currdata = OctFinal{i,1};
    currdata = currdata(lomin:lomax,lamin:lamax);
    addemupOct(i,1) = sum(sum(currdata,'omitnan'));
end

totalgrid = (lomax-lomin) * (lamax-lamin); 
%Average across area
addemupSum = addemupSum./totalgrid.*10000;
addemupWin = addemupWin./totalgrid.*10000;
addemupMar = addemupMar./totalgrid.*10000;
addemupOct = addemupOct./totalgrid.*10000;

%% Get sum from Eddies
%grab data
Xa=AE_traj(:,2); Ya=AE_traj(:,3);
Xc=CE_traj(:,2); Yc=CE_traj(:,3);
% areac = CE_traj(:,7); areaa = AE_traj(:,7);
date_a=AE_traj(:,14);
date_c=CE_traj(:,14);
ekea=AE_traj(:,9);
ekec=CE_traj(:,9);
%Logic for loops below
numCE = length(Xc);
numAE = length(Xa);
[ind1,which] = max([numCE,numAE]);
ind2 = min([numCE,numAE]);
diff = ind1-ind2;
%sort by area, then by date, and if in area, add to the corresponding
%matrix for that day
eddySum = zeros(sumcount,2); %first variable: running sum, second variable: running count
eddyWin = zeros(wincount,2);
eddyMar = zeros(marcount,2);
eddyOct = zeros(octcount,2);
SumInterval = 122; SumOnset = 151;
WinInterval = 120; WinOnset = 304; Winterval2 = 59;
MarInterval = 31; MarOnset = 59;
OctInterval = 31; OctOnset = 273;
%Loop through all dates
tic
for i = 1:ind2
    Xc1 = (Xc{i,1}); Yc1 = (Yc{i,1}); Xa1=(Xa{i,1}); Ya1=(Ya{i,1});
    
    %Processing: CE, loop through all points in this CE
    for j = 1:length(Xc1)
        Xc2 = Xc1(j); Yc2 = Yc1(j);
        %In boundary
        if ((Xc2 > WL) && (Xc2 < EL) && (Yc2 > SL) && (Yc2 < NL))
            date=date_c{i,1};
            date2 = date(j);
            date3=datestr(date2);
            daynf=str2double(date3(1,1:2));
            month=date3(1,4:6);
            [monthint, month] = monthconversion(month);
            year=str2double(date3(1,8:11));
            if year == 2020
                break;
            end
            if (mod((year-1992),4) == 0)
                leapadd = 1;
            else
                leapadd =0;
            end
            date4 = datetime([year monthint daynf]);
            date5 = day(date4,'dayofyear');
            yearspast = year-1993;
            %convert to datetime, convert to days of year
            % Index: #years past 1993 * #days in season + Days in season so
            % far
            if ismember(month, SumMon)
                ekec1 = ekec{i,1}(j);
                %areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
                %ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                index = yearspast*SumInterval+date5-SumOnset-leapadd;
                eddySum(index,1) = eddySum(index,1) + ekec1;
                eddySum(index,2) = eddySum(index,2) + 1;
                %Winter needs extra logic cuz it crosses years
            elseif ismember(month, WinMon)
                ekec1 = ekec{i,1}(j);
%                 areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                if date5 < 100
                    index = yearspast*WinInterval+date5+1*floor(yearspast/4);
                else
                    index = yearspast*WinInterval + Winterval2 + date5-WinOnset-leapadd+1*floor(yearspast/4);
                end
                eddyWin(index,1) = eddyWin(index,1) + ekec1;
                eddyWin(index,2) = eddyWin(index,2) + 1;
            elseif ismember(month, Mar)
                ekec1 = ekec{i,1}(j);
%                 areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                index = yearspast*MarInterval+date5-MarOnset-leapadd;
                eddyMar(index,1) = eddyMar(index,1) + ekec1;
                eddyMar(index,2) = eddyMar(index,2) + 1;
            elseif ismember(month, Oct)
                ekec1 = ekec{i,1}(j);
%                 areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                index = yearspast*OctInterval+date5-OctOnset-leapadd;
                eddyOct(index,1) = eddyOct(index,1) + ekec1;
                eddyOct(index,2) = eddyOct(index,2) + 1;
            end
        end
    end
    
    %Processing: AE
    for j = 1:length(Xa1)
        Xa2 = Xa1(j); Ya2 = Ya1(j);
        %In boundary
        if ((Xa2 > WL) && (Xa2 < EL) && (Ya2 > SL) && (Ya2 < NL))
            date=date_a{i,1};
            date2 = date(j);
            date3=datestr(date2);
            daynf=str2double(date3(1,1:2));
            month=date3(1,4:6);
            [monthint, month] = monthconversion(month);
            year=str2double(date3(1,8:11));
            if year == 2020
                break;
            end
            if (mod((year-1992),4) == 0)
                leapadd = 1;
            else
                leapadd =0;
            end
            date4 = datetime([year monthint daynf]);
            date5 = day(date4,'dayofyear');
            yearspast = year-1993;
            %convert to datetime, convert to days of year
            % Index: #years past 1993 * #days in season + Days in season so
            % far
            if ismember(month, SumMon)
                ekea1 = ekea{i,1}(j);
%                 areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                index = yearspast*SumInterval+date5-SumOnset-leapadd;
                eddySum(index,1) = eddySum(index,1) + ekea1;
                eddySum(index,2) = eddySum(index,2) + 1;
            elseif ismember(month, WinMon)
                ekea1 = ekea{i,1}(j);
%                 areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                if date5 < 100
                    index = yearspast*WinInterval+date5+1*floor(yearspast/4);
                else
                    index = yearspast*WinInterval + Winterval2 + date5-WinOnset-leapadd+1*floor(yearspast/4);
                end
                eddyWin(index,1) = eddyWin(index,1) + ekea1;
                eddyWin(index,2) = eddyWin(index,2) + 1;
            elseif ismember(month, Mar)
                ekea1 = ekea{i,1}(j);
%                 areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                index = yearspast*MarInterval+date5-MarOnset-leapadd;
                eddyMar(index,1) = eddyMar(index,1) + ekea1;
                eddyMar(index,2) = eddyMar(index,2) + 1;
            elseif ismember(month, Oct)
                ekea1 = ekea{i,1}(j);
%                 areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                 ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                index = yearspast*OctInterval+date5-OctOnset-leapadd;
                eddyOct(index,1) = eddyOct(index,1) + ekea1;
                eddyOct(index,2) = eddyOct(index,2) + 1;
            end
        end
    end
end
toc
if (which == 1) %CE>AE num, this is an CE loop
    for i = (ind2+1):(ind2+diff) %Pick up at next index from loop one
        Xc1 = (Xc{i,1}); Yc1 = (Yc{i,1});
        %Processing: CE, loop through all points in this CE
        for j = 1:length(Xc1)
            Xc2 = Xc1(j); Yc2 = Yc1(j);
            %In boundary
            if ((Xc2 > WL) && (Xc2 < EL) && (Yc2 > SL) && (Yc2 < NL))
                date=date_c{i,1};
                date2 = date(j);
                date3=datestr(date2);
                daynf=str2double(date3(1,1:2));
                month=date3(1,4:6);
                [monthint, month] = monthconversion(month);
                year=str2double(date3(1,8:11));
                if year == 2020
                    break;
                end
                if (mod((year-1992),4) == 0)
                    leapadd = 1;
                else
                    leapadd =0;
                end
                date4 = datetime([year monthint daynf]);
                date5 = day(date4,'dayofyear');
                yearspast = year-1993;
                %convert to datetime, convert to days of year
                % Index: #years past 1993 * #days in season + Days in season so
                % far
                if ismember(month, SumMon)
                    ekec1 = ekec{i,1}(j);
%                     areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                    index = yearspast*SumInterval+date5-SumOnset-leapadd;
                    eddySum(index,1) = eddySum(index,1) + ekec1;
                    eddySum(index,2) = eddySum(index,2) + 1;
                    %Winter needs extra logic cuz it crosses years
                elseif ismember(month, WinMon)
                    ekec1 = ekec{i,1}(j);
%                     areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                    if date5 < 100
                        index = yearspast*WinInterval+date5+1*floor(yearspast/4);
                    else
                        index = yearspast*WinInterval + Winterval2 + date5-WinOnset-leapadd+1*floor(yearspast/4);
                    end
                    eddyWin(index,1) = eddyWin(index,1) + ekec1;
                    eddyWin(index,2) = eddyWin(index,2) + 1;
                elseif ismember(month, Mar)
                    ekec1 = ekec{i,1}(j);
%                     areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                    index = yearspast*MarInterval+date5-MarOnset-leapadd;
                    eddyMar(index,1) = eddyMar(index,1) + ekec1;
                    eddyMar(index,2) = eddyMar(index,2) + 1;
                elseif ismember(month, Oct)
                    ekec1 = ekec{i,1}(j);
%                     areac1 = areac{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekec1 = ekec1*areac1; %to get eke across the entire eddy area
                    index = yearspast*OctInterval+date5-OctOnset-leapadd;
                    eddyOct(index,1) = eddyOct(index,1) + ekec1;
                    eddyOct(index,2) = eddyOct(index,2) + 1;
                end
            end
        end
    end
    
else %AE>CE num, this is an AE loop
    for i = (ind2+1):(ind2+diff)
        Xa1 = (Xa{i,1}); Ya1 = (Ya{i,1});
        %Processing: AE
        for j = 1:length(Xa1)
            Xa2 = Xa1(j); Ya2 = Ya1(j);
            %In boundary
            if ((Xa2 > WL) && (Xa2 < EL) && (Ya2 > SL) && (Ya2 < NL))
                date=date_a{i,1};
                date2 = date(j);
                date3=datestr(date2);
                daynf=str2double(date3(1,1:2));
                month=date3(1,4:6);
                [monthint, month] = monthconversion(month);
                year=str2double(date3(1,8:11));
                if year == 2020
                    break;
                end
                if (mod((year-1992),4) == 0)
                    leapadd = 1;
                else
                    leapadd =0;
                end
                date4 = datetime([year monthint daynf]);
                date5 = day(date4,'dayofyear');
                yearspast = year-1993;
                %convert to datetime, convert to days of year
                % Index: #years past 1993 * #days in season + Days in season so
                % far
                if ismember(month, SumMon)
                    ekea1 = ekea{i,1}(j);
%                     areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                    index = yearspast*SumInterval+date5-SumOnset-leapadd;
                    eddySum(index,1) = eddySum(index,1) + ekea1;
                    eddySum(index,2) = eddySum(index,2) + 1;
                elseif ismember(month, WinMon)
                    ekea1 = ekea{i,1}(j);
                    if date5 < 100
                        index = yearspast*WinInterval+date5+1*floor(yearspast/4);
                    else
                        index = yearspast*WinInterval + Winterval2 + date5-WinOnset-leapadd+1*floor(yearspast/4);
                    end
                    eddyWin(index,1) = eddyWin(index,1) + ekea1;
                    eddyWin(index,2) = eddyWin(index,2) + 1;
                elseif ismember(month, Mar)
                    ekea1 = ekea{i,1}(j);
%                     areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                    index = yearspast*MarInterval+date5-MarOnset-leapadd;
                    eddyMar(index,1) = eddyMar(index,1) + ekea1;
                    eddyMar(index,2) = eddyMar(index,2) + 1;
                elseif ismember(month, Oct)
                    ekea1 = ekea{i,1}(j);
%                     areaa1 = areaa{i,1}(j) * 1000000; %times a million to convert from km^2 to m^2
%                     ekea1 = ekea1*areaa1; %to get eke across the entire eddy area
                    index = yearspast*OctInterval+date5-OctOnset-leapadd;
                    eddyOct(index,1) = eddyOct(index,1) + ekea1;
                    eddyOct(index,2) = eddyOct(index,2) + 1;
                end
            end
        end
    end
end

% Average across all eddies, convert to cm from m [squared]
eddyWin(:,1) = (eddyWin(:,1) ./ eddyWin(:,2)).*10000;
eddyMar(:,1) = (eddyMar(:,1) ./ eddyMar(:,2)).*10000;
eddySum(:,1) = (eddySum(:,1) ./ eddySum(:,2)).*10000;
eddyOct(:,1) = (eddyOct(:,1) ./ eddyOct(:,2)).*10000;

%% Avg + STDev
[avgWin(:,1), avgWin(:,2)] = avgconversion(addemupWin(1:(3240)), WinInterval);
stdevWin = std(avgWin(:,1));
[avgMar(:,1), avgMar(:,2)] = avgconversion(addemupMar, MarInterval);
stdevMar = std(avgMar(:,1));
[avgSum(:,1), avgSum(:,2)] = avgconversion(addemupSum, SumInterval);
stdevSum = std(avgSum(:,1));
[avgOct(:,1), avgOct(:,2)] = avgconversion(addemupOct, OctInterval);
stdevOct = std(avgOct(:,1));
[avgWinE(:,1), avgWinE(:,2)] = avgconversion(eddyWin((1:(3240)),1), WinInterval);
stdevWinE = std(avgWinE(:,1));
[avgMarE(:,1), avgMarE(:,2)] = avgconversion(eddyMar(:,1), MarInterval);
stdevMarE = std(avgMarE(:,1));
[avgSumE(:,1), avgSumE(:,2)] = avgconversion(eddySum(:,1), SumInterval);
stdevSumE = std(avgSumE(:,1));
[avgOctE(:,1), avgOctE(:,2)] = avgconversion(eddyOct(:,1), OctInterval);
stdevOctE = std(avgOctE(:,1));

%% Plotting, once data is found everywhere
figure('units', 'normalized', 'outerposition', [0 0 1 1])
ha=tight_subplot(4,1,[.05,.1],.066,.066);

% WINTER: BLUE-MEAN
axes(ha(1))
maxy = max(avgWinE);
yyaxis left
%plot(addemupWin, 'Color', 'b', 'LineWidth', 3)
curve1 = avgWin(:,1) + stdevWin;
curve2 = avgWin(:,1) - stdevWin;
x2 = [1:length(avgWin(:,1)), fliplr(1:length(avgWin(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
plot(1:length(avgWin), avgWin(:,1), '-b', 'LineWidth', 2);
ylim([300 maxy(1)*1.2])
hold on
patch(x2,inBetween,'blue','FaceAlpha',.4);
ylabel("Total (cm^2/s^2)")

% WINTER: RED-EDDY
yyaxis right
curve1 = avgWinE(:,1) + stdevWinE;
curve2 = avgWinE(:,1) - stdevWinE;
x2 = [1:length(avgWinE(:,1)), fliplr(1:length(avgWinE(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
patch(x2,inBetween,'red','FaceAlpha',.4);
hold on
plot(1:length(avgWinE), avgWinE(:,1), '-r', 'LineWidth', 2);
%plot(eddyWin(:,1), 'Color', 'r', 'LineWidth', 3)
ylabel("Eddy Component (cm^2/s^2)")
%inter = (1:WinInterval:wincount);
inter = 1:27;
grid on
xticks(inter);
xticklabels(years);
%xlim([1 wincount-4])
xlim([1 27])
ylim([300 maxy(1)*1.2])
set(gca,'fontsize',18);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca,'LineWidth',2);


% MARCH: BLUE-MEAN
axes(ha(2))
maxy = max(avgMarE);
yyaxis left
curve1 = avgMar(:,1) + stdevMar;
curve2 = avgMar(:,1) - stdevMar;
x2 = [1:length(avgMar(:,1)), fliplr(1:length(avgMar(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
plot(1:length(avgMar), avgMar(:,1), '-b', 'LineWidth', 2);
ylim([0 maxy(1)*1.2])
hold on
patch(x2,inBetween,'blue','FaceAlpha',.4);
ylabel("Total (cm^2/s^2)")

% MARCH: RED-EDDY
yyaxis right
curve1 = avgMarE(:,1) + stdevMarE;
curve2 = avgMarE(:,1) - stdevMarE;
x2 = [1:length(avgMarE(:,1)), fliplr(1:length(avgMarE(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
patch(x2,inBetween,'red','FaceAlpha',.4);
hold on
plot(1:length(avgMarE), avgMarE(:,1), '-r', 'LineWidth', 2);
%plot(eddyMar(:,1), 'Color', 'r', 'LineWidth', 3)
ylabel("Eddy Component (cm^2/s^2)")
%inter = (1:MarInterval:wincount);
inter = 1:27;
grid on
xticks(inter);
xticklabels(years);
%xlim([1 wincount-4])
xlim([1 27])
ylim([0 maxy(1)*1.2])
set(gca,'fontsize',18);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca,'LineWidth',2);


% SUMMER: BLUE-MEAN
axes(ha(3))
maxy = max(avgSumE);
yyaxis left
curve1 = avgSum(:,1) + stdevSum;
curve2 = avgSum(:,1) - stdevSum;
x2 = [1:length(avgSum(:,1)), fliplr(1:length(avgSum(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
plot(1:length(avgSum), avgSum(:,1), '-b', 'LineWidth', 2);
ylim([700 maxy(1)*1.2])
hold on
patch(x2,inBetween,'blue','FaceAlpha',.4);
ylabel("Total (cm^2/s^2)")

% SUMMER: RED-EDDY
yyaxis right
curve1 = avgSumE(:,1) + stdevSumE;
curve2 = avgSumE(:,1) - stdevSumE;
x2 = [1:length(avgSumE(:,1)), fliplr(1:length(avgSumE(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
patch(x2,inBetween,'red','FaceAlpha',.4);
hold on
plot(1:length(avgSumE), avgSumE(:,1), '-r', 'LineWidth', 2);
%plot(eddySum(:,1), 'Color', 'r', 'LineWidth', 3)
ylabel("Eddy Component (cm^2/s^2)")
%inter = (1:SumInterval:wincount);
inter = 1:27;
grid on
xticks(inter);
xticklabels(years);
%xlim([1 wincount-4])
xlim([1 27]) 
ylim([700 maxy(1)*1.2])
set(gca,'fontsize',18);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca,'LineWidth',2);

% OCTOBER: BLUE-MEAN
axes(ha(4))
maxy = max(avgOctE);
yyaxis left
curve1 = avgOct(:,1) + stdevOct;
curve2 = avgOct(:,1) - stdevOct;
x2 = [1:length(avgOct(:,1)), fliplr(1:length(avgOct(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
plot(1:length(avgOct), avgOct(:,1), '-b', 'LineWidth', 2);
ylim([400 maxy(1)*1.2])
hold on
patch(x2,inBetween,'blue','FaceAlpha',.4);
ylabel("Total (cm^2/s^2)")

% OCTOBER: RED-EDDY
yyaxis right
curve1 = avgOctE(:,1) + stdevOctE;
curve2 = avgOctE(:,1) - stdevOctE;
x2 = [1:length(avgOctE(:,1)), fliplr(1:length(avgOctE(:,1)))];
inBetween = [transpose(curve1), fliplr(transpose(curve2))];
patch(x2,inBetween,'red','FaceAlpha',.4);
hold on
plot(1:length(avgOctE), avgOctE(:,1), '-r', 'LineWidth', 2);
%plot(eddyOct(:,1), 'Color', 'r', 'LineWidth', 3)
ylabel("Eddy Component (cm^2/s^2)")
%inter = (1:OctInterval:wincount);
inter = 1:27;
grid on
xticks(inter);
xticklabels(years);
%xlim([1 wincount-4])
xlim([1 27])
ylim([400 maxy(1)*1.2])
set(gca,'fontsize',18);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca,'LineWidth',2);
text('Parent',gca,'FontSize',28,'String','(d) October',...
    'Position',[1.59135913591359 2288.42501170932 0]);
text('Parent',gca,'FontSize',28,'String','(c) Summer',...
    'Position',[1.59135913591359 5288.11725678775 0]);
text('Parent',gca,'FontSize',28,'String','(b) March',...
    'Position',[1.59135913591359 8236.26839799886 0]);
text('Parent',gca,'FontSize',28,'String','(a) Winter',...
    'Position',[1.59135913591359 11132.8784353426 0]);


filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
%% Month Function
function [monthint, monthintstr] = monthconversion(monthstr)
if monthstr == "Jan"
    monthintstr = "01";
    monthint = 01;
elseif monthstr == "Feb"
    monthintstr = "02";
    monthint = 02;
elseif monthstr == "Mar"
    monthintstr = "03";
    monthint = 03;
elseif monthstr == "Apr"
    monthintstr = "04";
    monthint = 04;
elseif monthstr == "May"
    monthintstr = "05";
    monthint = 05;
elseif monthstr == "Jun"
    monthintstr = "06";
    monthint = 06;
elseif monthstr == "Jul"
    monthintstr = "07";
    monthint = 07;
elseif monthstr == "Aug"
    monthintstr = "08";
    monthint = 08;
elseif monthstr == "Sep"
    monthintstr = "09";
    monthint = 09;
elseif monthstr == "Oct"
    monthintstr = "10";
    monthint = 10;
elseif monthstr == "Nov"
    monthintstr = "11";
    monthint = 11;
elseif monthstr == "Dec"
    monthintstr = "12";
    monthint = 12;
end
end

%% Avg/STD Function
function [avmat, stdmat] = avgconversion(matrix, interval)
count = 0;
for i = 1:interval:length(matrix)
    count = count + 1;
    avmat(count) = mean(matrix(i:(i+interval-1)), 'omitnan');
    stdmat(count) = std(matrix(i:(i+interval-1)), 'omitnan');
end
end