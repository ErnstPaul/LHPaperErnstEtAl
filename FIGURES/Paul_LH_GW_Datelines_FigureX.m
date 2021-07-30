%% Paul_LH_GW_Datelines_Figure4.m (version 1.4)
%Author: Paul Ernst
%Date Created: 6/21/2021
%Date of Last Update: 6/29/2021
%Update History:
%PE 6/29/2021 - Cleaned up script
%PE 6/28/2021 - Added SEF
%PE 6/25/2021 - Added SES
%PE 6/22/2021 - Modified algorithms to be threshold-independent
%PE 6/21/2021 - Created
%--------------------------------------
%Purpose: Correlates dates of LH, LHW, SES, SEF, MOK, and GW
%Inputs: FinalEddyIDLists.mat (from Paul_FinalEddyTracking.m), MOK dates,
%        Traj files (from eddy steps)
%Outputs: Time series of dates (plot), and significance values for above
%--------------------------------------
%% Inputs
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/EXTRACTION/EDDY_TRAJECTORIES')
addpath(strcat(basepath, 'FUNCTIONS'));
%dd [space] mm
mok = ["03 06", "28 05", "10 06", "09 06", "12 06", "03 06", "22 05", "01 06",...
    "26 05", "09 06", "13 06", "03 06", "07 06", "26 05", "28 05", "31 05", "23 05", "31 05",...
    "29 05", "05 06", "01 06", "06 06", "05 06", "08 06", "30 05", "29 05", "08 06"]; %MOK dates in datetime strings
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002",...
    "2003","2004","2005","2006","2007","2008","2009","2010","2011","2012",...
    "2013","2014","2015","2016","2017","2018","2019"]; %Years
load('FinalEddyIDLists.mat');
load('AE_Filtered_Trajectories.mat')
%% Process data
%declaring and reading things in
daythreshLH = 200;
x_a = AE_traj(:,2); y_a = AE_traj(:,3); r_a = AE_traj(:,6); ...
    area_a = AE_traj(:,7); amp_a=AE_traj(:,8); eke_a=AE_traj(:,9); are_a = AE_traj(:,9); date_a=AE_traj(:,14);
moknum = zeros(1,27); dateLH = zeros(1,27); dateLHW = zeros(1,27); ...
    gwLonelyOnset = zeros(1,27); sesLonelyOnset = zeros(1,27); sefLonelyOnset = zeros(1,27); ...
    maxEKEIndSES = zeros(1,27); maxEKEIndSEF = zeros(1,27); maxEKEIndGW = zeros(1,27);
r = cell(1,27); x_x = cell(1,27); y_y = cell(1,27); radiusGW = cell(1,27);... 
    radiusSES = cell(1,27); radiusSEF = cell(1,27); lonelinessGW = cell(1,27); ...
    lonelinessSES = cell(1,27); lonelinessSEF = cell(1,27);
%Loop through all years
for i = 1:length(years)
    %--------------------------------------------------------------------------
    %Extract MoK into day of year
    mokdatestr(i) = datetime(str2double(years(i)),...
        str2double(extractAfter(mok(i),3)),...
        str2double(extractBefore(mok(i),3)));
    moknum(i) = day(mokdatestr(i), 'dayofyear');
    
    %--------------------------------------------------------------------------
    %Extract LH Root Onset into day of year
    %Onset defined as formation date given its formation as a closed contour
    %is what is important (spins off from CKW)
    LHW = LHRoot(i);
    date=date_a{LHW,1};
    date2=datestr(date(1));
    daynf=str2double(date2(1:2));
    month=date2(4:6);
    [monthint, ~] = monthconversion(month);
    year=str2double(date2(8:11));
    date3 = datetime([year monthint daynf]);
    dateLH(i) = day(date3,'dayofyear');
    %center around the new year
    if (dateLH(i) > daythreshLH)
        if (mod(i,4) == 0)
            leap = 366;
        else
            leap = 365;
        end
        dateLH(i) = dateLH(i)-leap;
    end
    
    %--------------------------------------------------------------------------
    %Extract LHW Root Onset into day of year
    %Onset defined as formation date given its separation is what is
    %important (spins out on the Rossby Wave)
    LHW = LHWRoot(i);
    date=date_a{LHW,1};
    date2=datestr(date(1));
    daynf=str2double(date2(1:2));
    month=date2(4:6);
    [monthint, ~] = monthconversion(month);
    year=str2double(date2(8:11));
    date3 = datetime([year monthint daynf]);
    dateLHW(i) = day(date3,'dayofyear');
    %center around the new year
    if (dateLHW(i) > daythreshLH)
        if (mod(i,4) == 0)
            leap = 366;
        else
            leap = 365;
        end
        dateLHW(i) = dateLHW(i)-leap;
    end
    
    %--------------------------------------------------------------------------
    %Extract SES Root Onset into day of year
    %Onset defined as when SES becomes most prevalent in this time period
    %(max of cost function related to lonelinessSES)
    clear date date2 date3 month daynf dateSESSC year
    upperdaybound = day(datetime([2000 09 15]),'dayofyear');
    lowerdaybound = day(datetime([2000 07 15]),'dayofyear');
    SES = SESRoot(i);
    r{1,i}=eke_a{SES,1};
    areaSES=are_a{SES,1};
    r{1,i} = mat2gray(r{1,i});
    rr = r{1,i};
    x_x{1,i}=x_a{SES,1};
    y_y{1,i}=y_a{SES,1};
    radiusSES{1,i} = r_a{SES,1};
    
    %Datetime strings for this guy
    date=date_a{SES,1};
    for j = 1:length(date)
        date2(j,:)=datestr(date(j));
        daynf(j)=str2double(date2(j,1:2));
        month(j,:)=date2(j,4:6);
        [monthint(j), ~] = monthconversion(month(j,:));
        year(j)=str2double(date2(j,8:11));
        date3(j) = datetime([year(j) monthint(j) daynf(j)]);
        dateSESSC(j) = day(date3(j),'dayofyear');
    end
    
    %Comment this section out if you've already calc'd it
    %Should this be a function? Probably. Do I care? Yes. Am I lazy? Also
    %yes. Something something "temporary" solution, so sue me
    %We're looking for the number of eddies around the center of the SES
    monthbounds = ["Jul","Aug","Sep"]; %timewise filter
    lonelinessSES{1,i} = zeros(1,length(rr));
    %loop through all dates of the SES
    tic
    for nDates = 1:length(rr)
        %setting adaptive bounds
        currad = radiusSES{1,i}(nDates);
        latoffset = currad/110.573;
        lonoffset = currad/(cosd(y_y{1,i}(nDates))*111.32);
        yCenter = y_y{1,i}(nDates);
        xCenter = x_x{1,i}(nDates);
        lonecount = 0;
        %make sure our center is in the right place
        if ((xCenter > 54) &&...
                (xCenter < 60) &&...
                (yCenter > 5) &&...
                (yCenter < 12))
            NL = yCenter+(3.11*latoffset);
            SL = yCenter-(3.11*latoffset);
            EL = xCenter+(3.11*lonoffset);
            WL = xCenter-(3.11*lonoffset);
            %is this a date in the monthbounds already?
            if ismember(month(nDates,:), monthbounds)
                %loop through all eddies to find matches, datewise
                for nEddy = 1:length(AE_traj)
                    if(nEddy ~= SES)
                        date_temp=date_a{nEddy,1};
                        [agreement, index_temp] = ismember(date(nDates),date_temp);
                        %do we have them on the same date?
                        if agreement
                            x_1=x_a{nEddy,1};
                            y_1=y_a{nEddy,1};
                            eddyX = x_1(index_temp);
                            eddyY = y_1(index_temp);
                            %disp([num2str(eddyX) + " " + num2str(eddyY) + " vs. SES: " + num2str(NL) + " "  + num2str(SL) + " "  + num2str(EL) + " "  + num2str(WL)]);
                            % is in our spatial domain?
                            if ((eddyX > WL) &&...
                                    (eddyX < EL) &&...
                                    (eddyY > SL) &&...
                                    (eddyY < NL))
                                %increment count (it is in our domain)
                                %disp([int2str(nEddy) + " is matching spacewise"])
                                lonecount = lonecount + 1;
                            end
                            
                        end
                    end
                end
            end
        end
        lonelinessSES{1,i}(nDates) = lonecount;
    end
    disp([toc + " Seconds since last loop; SES " + int2str(i)]);
    
    %Cost function:
    %Highest Area, Lowest Lonliness
    eke = ((gradient(r{1,i}) - mean(gradient(r{1,i})))...
        ./std(gradient(r{1,i}))).^2;
    lone = ((gradient(lonelinessSES{1,i}) - mean(gradient(lonelinessSES{1,i})))...
        ./std(gradient(lonelinessSES{1,i}))).^2;
    area = ((gradient(areaSES) - mean(gradient(areaSES)))...
        ./std(gradient(areaSES))).^2;
    costcurve = mat2gray(sqrt(eke + lone + area));
    %Get it in proper format
    [~,maxEKEIndSES(i)] = max(r{1,i});
    maxEKEIndSES(i) = dateSESSC(maxEKEIndSES(i));
    %Making sure we're getting the rising half of the eddy
    if ((maxEKEIndSES(i) < upperdaybound) && (maxEKEIndSES(i) > lowerdaybound))
        upperdaybounduse = maxEKEIndSES(i);
    else
        upperdaybounduse = upperdaybound;
    end
    %Set min bound based off of if the index is in date array
    if ~ismember(lowerdaybound,dateSESSC)
        minbound = 1;
    else
        [~,minbound] = ismember(lowerdaybound,dateSESSC);
    end
    %Set max bound based off of if the index is in date array
    if ~ismember(upperdaybounduse,dateSESSC)
        maxbound = length(dateSESSC);
    else
        [~,maxbound] = ismember(upperdaybounduse,dateSESSC);
    end
    %Find the maximum of the curve in the designated area
    [~,realcost] = max(costcurve(minbound:maxbound));
    realcost = realcost + minbound - 1;
    sesLonelyOnset(i) = dateSESSC(realcost);

    %--------------------------------------------------------------------------
    %Extract SEF Root Onset into day of year
    %Onset defined as when SEF becomes most prevalent in this time period
    %(max of cost function related to lonelinessSEF)
    clear date date2 date3 month daynf dateSEFSC year
    upperdaybound = day(datetime([2000 11 15]),'dayofyear');
    lowerdaybound = day(datetime([2000 09 01]),'dayofyear');
    SEF = SEFRoot(i);
    r{1,i}=eke_a{SEF,1};
    areaSEF=area_a{SEF,1};
    r{1,i} = mat2gray(r{1,i});
    rr = r{1,i};
    x_x{1,i}=x_a{SEF,1};
    y_y{1,i}=y_a{SEF,1};
    radiusSEF{1,i} = r_a{SEF,1};
    
    %Datetime strings for this guy
    date=date_a{SEF,1};
    for j = 1:length(date)
        date2(j,:)=datestr(date(j));
        daynf(j)=str2double(date2(j,1:2));
        month(j,:)=date2(j,4:6);
        [monthint(j), ~] = monthconversion(month(j,:));
        year(j)=str2double(date2(j,8:11));
        date3(j) = datetime([year(j) monthint(j) daynf(j)]);
        dateSEFSC(j) = day(date3(j),'dayofyear');
    end
    
    %Comment this section out if you've already calc'd it
    %We're looking for the number of eddies around the center of the SEF
    monthbounds = ["Sep","Oct","Nov"]; %timewise filter
    lonelinessSEF{1,i} = zeros(1,length(rr));
    %loop through all dates of the SEF
    tic
    for nDates = 1:length(rr)
        %setting adaptive bounds
        currad = radiusSEF{1,i}(nDates);
        latoffset = currad/110.573;
        lonoffset = currad/(cosd(y_y{1,i}(nDates))*111.32);
        yCenter = y_y{1,i}(nDates);
        xCenter = x_x{1,i}(nDates);
        lonecount = 0;
        %make sure our center is in the right place
        if ((xCenter > 54) &&...
                (xCenter < 60) &&...
                (yCenter > 5) &&...
                (yCenter < 15))
            NL = yCenter+(3.11*latoffset);
            SL = yCenter-(3.11*latoffset);
            EL = xCenter+(3.11*lonoffset);
            WL = xCenter-(3.11*lonoffset);
            %is this a date in the monthbounds already?
            if ismember(month(nDates,:), monthbounds)
                %loop through all eddies to find matches, datewise
                for nEddy = 1:length(AE_traj)
                    if(nEddy ~= SEF)
                        date_temp=date_a{nEddy,1};
                        [agreement, index_temp] = ismember(date(nDates),date_temp);
                        %do we have them on the same date?
                        if agreement
                            x_1=x_a{nEddy,1};
                            y_1=y_a{nEddy,1};
                            eddyX = x_1(index_temp);
                            eddyY = y_1(index_temp);
                            %disp([num2str(eddyX) + " " + num2str(eddyY) + " vs. SEF: " + num2str(NL) + " "  + num2str(SL) + " "  + num2str(EL) + " "  + num2str(WL)]);
                            % is in our spatial domain?
                            if ((eddyX > WL) &&...
                                    (eddyX < EL) &&...
                                    (eddyY > SL) &&...
                                    (eddyY < NL))
                                %increment count (it is in our domain)
                                %disp([int2str(nEddy) + " is matching spacewise"])
                                lonecount = lonecount + 1;
                            end
                            
                        end
                    end
                end
            end
        end
        lonelinessSEF{1,i}(nDates) = lonecount;
    end
    disp([toc + " Seconds since last loop; SEF " + int2str(i)]);
    
    %Cost function:
    %Highest Area, Lowest Lonliness
    eke = ((gradient(r{1,i}) - mean(gradient(r{1,i})))...
        ./std(gradient(r{1,i}))).^2;
    lone = ((gradient(lonelinessSEF{1,i}) - mean(gradient(lonelinessSEF{1,i})))...
        ./std(gradient(lonelinessSEF{1,i}))).^2;
    area = ((gradient(areaSEF) - mean(gradient(areaSEF)))...
        ./std(gradient(areaSEF))).^2;
    costcurve = mat2gray(sqrt(eke + lone + area));
    %Get it in proper format
    [~,maxEKEIndSEF(i)] = max(r{1,i});
    maxEKEIndSEF(i) = dateSEFSC(maxEKEIndSEF(i));
    %Making sure we get the rising part of this curve
    if ((maxEKEIndSEF(i) < upperdaybound) && (maxEKEIndSEF(i) > lowerdaybound))
        upperdaybounduse = maxEKEIndSEF(i);
    else
        upperdaybounduse = upperdaybound;
    end
    %Set min bound based off of if the index is in date array
    if ~ismember(lowerdaybound,dateSEFSC)
        minbound = 1;
    else
        [~,minbound] = ismember(lowerdaybound,dateSEFSC);
    end
    %Set max bound based off of if the index is in date array
    if ~ismember(upperdaybounduse,dateSEFSC)
        maxbound = length(dateSEFSC);
    else
        [~,maxbound] = ismember(upperdaybounduse,dateSEFSC);
    end
    if i == 6 %Yes this is hardcoded, this one eddy from this one year
              %f***s the algorithm because it stretches over 3 years
              %There is no easy way to code for this without manually
              %setting this to the appropriate index (from the appropriate
              %year). Take note, if your eddy stretches over 600 days lol
        maxbound = 351;
    end
    %Find the maximum of the curve in the designated area
    [~,realcost] = max(costcurve(minbound:maxbound));
    realcost = realcost + minbound - 1;
    sefLonelyOnset(i) = dateSEFSC(realcost);
    
    %--------------------------------------------------------------------------
    %Extract GW Root Onset into day of year
    %Need to compute a lonelinessGW cost function with EKE:
    %Grab EKE and positions
    clear date date2 date3 month daynf dateGWSC year
    upperdaybound = day(datetime([2000 06 27]),'dayofyear');
    lowerdaybound = day(datetime([2000 04 18]),'dayofyear');
    GW = GWRoot(i);
    r{1,i}=eke_a{GW,1};
    areaGW=area_a{GW,1};
    r{1,i} = mat2gray(r{1,i});
    rr = r{1,i};
    x_x{1,i}=x_a{GW,1};
    y_y{1,i}=y_a{GW,1};
    radiusGW{1,i} = r_a{GW,1};
    
    %Grab the dates for this year in date-time format
    date=date_a{GW,1};
    for j = 1:length(date)
        date2(j,:)=datestr(date(j));
        daynf(j)=str2double(date2(j,1:2));
        month(j,:)=date2(j,4:6);
        [monthint(j), ~] = monthconversion(month(j,:));
        year(j)=str2double(date2(j,8:11));
        date3(j) = datetime([year(j) monthint(j) daynf(j)]);
        dateGWSC(j) = day(date3(j),'dayofyear');
    end
    
    %Comment this section out if you've already calc'd it
    %We're looking for the number of eddies around the center of the GW
    monthbounds = ["Apr","May","Jun"]; %timewise filter
    lonelinessGW{1,i} = zeros(1,length(rr));
    %loop through all dates of the GW
    tic
    for nDates = 1:length(rr)
        %setting adaptive bounds
        currad = radiusGW{1,i}(nDates);
        latoffset = currad/110.573;
        lonoffset = currad/(cosd(y_y{1,i}(nDates))*111.32);
        yCenter = y_y{1,i}(nDates);
        xCenter = x_x{1,i}(nDates);
        lonecount = 0;
        %make sure our center is in the right place
        if ((xCenter > 50) &&...
                (xCenter < 55) &&...
                (yCenter > 5) &&...
                (yCenter < 10))
            NL = yCenter+(3.11*latoffset);
            SL = yCenter-(3.11*latoffset);
            EL = xCenter+(3.11*lonoffset);
            WL = xCenter-(3.11*lonoffset);
            %is this a date in the monthbounds already?
            if ismember(month(nDates,:), monthbounds)
                %loop through all eddies to find matches, datewise
                for nEddy = 1:length(AE_traj)
                    if(nEddy ~= GW)
                        date_temp=date_a{nEddy,1};
                        [agreement, index_temp] = ismember(date(nDates),date_temp);
                        %do we have them on the same date?
                        if agreement
                            x_1=x_a{nEddy,1};
                            y_1=y_a{nEddy,1};
                            eddyX = x_1(index_temp);
                            eddyY = y_1(index_temp);
                            %disp([num2str(eddyX) + " " + num2str(eddyY) + " vs. GW: " + num2str(NL) + " "  + num2str(SL) + " "  + num2str(EL) + " "  + num2str(WL)]);
                            % is in our spatial domain?
                            if ((eddyX > WL) &&...
                                    (eddyX < EL) &&...
                                    (eddyY > SL) &&...
                                    (eddyY < NL))
                                %increment count (it is in our domain)
                                %disp([int2str(nEddy) + " is matching spacewise"])
                                lonecount = lonecount + 1;
                            end
                            
                        end
                    end
                end
            end
        end
        lonelinessGW{1,i}(nDates) = lonecount;
    end
    disp([toc + " Seconds since last loop; GW " + int2str(i)]);
    
    %Cost function:
    %Highest Area, Lowest Lonliness
    eke = ((gradient(r{1,i}) - mean(gradient(r{1,i})))...
        ./std(gradient(r{1,i}))).^2;
    lone = ((gradient(lonelinessGW{1,i}) - mean(gradient(lonelinessGW{1,i})))...
        ./std(gradient(lonelinessGW{1,i}))).^2;
    area = ((gradient(areaGW) - mean(gradient(areaGW)))...
        ./std(gradient(areaGW))).^2;
    costcurve = mat2gray(sqrt(eke + lone + area));
    %Get it in proper format
    [~,maxEKEIndGW(i)] = max(r{1,i});
    maxEKEIndGW(i) = dateGWSC(maxEKEIndGW(i));
    %Making sure we get the rising part of this curve
    if ((maxEKEIndGW(i) < upperdaybound) && (maxEKEIndGW(i) > lowerdaybound))
        upperdaybounduse = maxEKEIndGW(i);
    else
        upperdaybounduse = upperdaybound;
    end
    %Set min bound based off of if the index is in date array
    if ~ismember(lowerdaybound,dateGWSC)
        minbound = 1;
    else
        [~,minbound] = ismember(lowerdaybound,dateGWSC);
    end
    %Set max bound based off of if the index is in date array
    if ~ismember(upperdaybounduse,dateGWSC)
        maxbound = length(dateGWSC);
    else
        [~,maxbound] = ismember(upperdaybounduse,dateGWSC);
    end
    %Find the maximum of the curve in the designated area
    [~,realcost] = max(costcurve(minbound:maxbound));
    realcost = realcost + minbound - 1;
    gwLonelyOnset(i) = dateGWSC(realcost);
end

%% Save individual loneliness matrices for validity checking
save('SESLonliness.mat', 'sesLonelyOnset', 'lonelinessSES');
save('SEFLonliness.mat', 'sefLonelyOnset', 'lonelinessSEF');
save('GWLonliness.mat', 'gwLonelyOnset', 'lonelinessGW');
dateGW = gwLonelyOnset; dateSES = sesLonelyOnset; dateSEF = sefLonelyOnset;
proptimeGW = dateGW-dateLHW; proptimeGW2 = dateGW-dateLH; proptimeSES = dateSES-dateLH;
distanceSEF = dateSEF-dateSES;
save('dateCorrelationFinal.mat', 'gwLonelyOnset', 'dateLH', ...
    'dateLHW', 'sesLonelyOnset', 'sefLonelyOnset', 'proptimeGW', 'proptimeGW2', ...
    'proptimeSES', 'distanceSEF', 'maxEKEIndGW', 'maxEKEIndSES', 'maxEKEIndSEF')

%% Grab significance values
%feed things in here
load('dateCorrelationFinal.mat')

P1 = zeros(1,46);
% LHW Formation
[~,P] = corrcoef(dateLHW,moknum);
P1(1) = P(1,2);
[~,P] = corrcoef(dateLHW,dateSES);
P1(2) = P(1,2);
[~,P] = corrcoef(dateLHW,dateSEF);
P1(3) = P(1,2);
[~,P] = corrcoef(dateLHW,dateGW);
P1(4) = P(1,2);
[~,P] = corrcoef(dateLHW,maxEKEIndGW);
P1(5) = P(1,2);
[~,P] = corrcoef(dateLHW,dateLH);
P1(6) = P(1,2);
[~,P] = corrcoef(dateLHW,proptimeGW2);
P1(7) = P(1,2);
[~,P] = corrcoef(dateLHW,proptimeSES);
P1(8) = P(1,2);
[~,P] = corrcoef(dateLHW,distanceSEF);
P1(9) = P(1,2);

% LH Formation
[~,P] = corrcoef(dateLH,moknum);
P1(10) = P(1,2);
[~,P] = corrcoef(dateLH,dateSES);
P1(11) = P(1,2);
[~,P] = corrcoef(dateLH,dateSEF);
P1(12) = P(1,2);
[~,P] = corrcoef(dateLH,dateGW);
P1(13) = P(1,2);
[~,P] = corrcoef(dateLH,maxEKEIndGW);
P1(14) = P(1,2);
[~,P] = corrcoef(dateLH,proptimeGW);
P1(15) = P(1,2);
[~,P] = corrcoef(dateLH,distanceSEF);
P1(16) = P(1,2);

% GW Onset
[~,P] = corrcoef(dateGW,moknum);
P1(17) = P(1,2);
[~,P] = corrcoef(dateGW,dateSES);
P1(18) = P(1,2);
[~,P] = corrcoef(dateGW,dateSEF);
P1(19) = P(1,2);
[~,P] = corrcoef(dateGW,maxEKEIndGW);
P1(20) = P(1,2);
[~,P] = corrcoef(dateGW,proptimeSES);
P1(21) = P(1,2);
[~,P] = corrcoef(dateGW,distanceSEF);
P1(22) = P(1,2);

% GW Max
[~,P] = corrcoef(maxEKEIndGW,moknum);
P1(23) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,dateSES);
P1(24) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,dateSEF);
P1(25) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,proptimeGW);
P1(26) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,proptimeGW2);
P1(27) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,proptimeSES);
P1(28) = P(1,2);
[~,P] = corrcoef(maxEKEIndGW,distanceSEF);
P1(29) = P(1,2);

% SES Onset
[~,P] = corrcoef(dateSES,moknum);
P1(30) = P(1,2);
[~,P] = corrcoef(dateSES,dateSEF);
P1(31) = P(1,2);
[~,P] = corrcoef(dateSES,proptimeGW);
P1(32) = P(1,2);
[~,P] = corrcoef(dateSES,proptimeGW2);
P1(33) = P(1,2);

% SEF Onset
[~,P] = corrcoef(dateSEF,moknum);
P1(34) = P(1,2);
[~,P] = corrcoef(dateSEF,proptimeGW);
P1(35) = P(1,2);
[~,P] = corrcoef(dateSEF,proptimeGW2);
P1(36) = P(1,2);
[~,P] = corrcoef(dateSEF,proptimeSES);
P1(37) = P(1,2);

%Proptimes
[~,P] = corrcoef(proptimeSES,proptimeGW);
P1(38) = P(1,2);
[~,P] = corrcoef(proptimeSES,proptimeGW2);
P1(39) = P(1,2);
[~,P] = corrcoef(distanceSEF,proptimeGW);
P1(40) = P(1,2);
[~,P] = corrcoef(distanceSEF,proptimeGW2);
P1(41) = P(1,2);

%EKE Maxes for SES and SEF
[~,P] = corrcoef(maxEKEIndSES,maxEKEIndSEF);
P1(42) = P(1,2);
[~,P] = corrcoef(maxEKEIndSES,maxEKEIndGW);
P1(43) = P(1,2);
[~,P] = corrcoef(maxEKEIndSEF,maxEKEIndGW);
P1(44) = P(1,2);
[~,P] = corrcoef(maxEKEIndSES,dateLHW);
P1(45) = P(1,2);
[~,P] = corrcoef(maxEKEIndSEF,dateGW);
P1(46) = P(1,2);

%Print the values
disp("---------------Start----------------");
for i = 1:length(P1)
    if (P1(i) < 0.05)
        disp([int2str(i) + " (" + num2str(P1(i)) + ") " + "is significant!"]);
    elseif (P1(i) < 0.10)
        disp([int2str(i) + " (" + num2str(P1(i)) + ") " + " is close!"]);
    end
end
disp("----------------End---------------");

%% Produce Figure
figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%Using TiledLayout for this so we can stuff it in a for-loop
t = tiledlayout(6,1,'TileSpacing','tight');
inter = 1:27;
annpos = cell(1,6);  annpos{1,1} = [2, -55]; annpos{1,2} = [2, -55]; annpos{1,3} = [4, 125];...
     annpos{1,5} = [3, 280]; annpos{1,4} = [7, 250]; annpos{1,6} = [4, 310];
anno = cell(1,6); anno{1,1} = "(a) LHW Onset"; anno{1,2} = "(b) LH Onset"; anno{1,3} = "(c) GW Spinup"; ...
     anno{1,5} = "(e) GW Max EKE";  anno{1,4} = "(d) SES Spinup"; anno{1,6} = "(f) SEF Spinup";
tilemat = cell(1,6); tilemat{1,1} = dateLHW; tilemat{1,2} = dateLH; tilemat{1,3} = dateGW;...
     tilemat{1,5} = maxEKEIndGW; tilemat{1,4} = dateSES; tilemat{1,6} = dateSEF;
%Loop through plots to be made
for nTiles = 1:6
    nexttile
    curve1 = tilemat{1,nTiles} + std(tilemat{1,nTiles});
    curve2 = tilemat{1,nTiles} - std(tilemat{1,nTiles});
    x2 = [1:length(tilemat{1,nTiles}), fliplr(1:length(tilemat{1,nTiles}))];
    inBetween = [curve1, fliplr(curve2)];
    plot(1:length(tilemat{1,nTiles}), tilemat{1,nTiles}, '-b', 'LineWidth', 2);
    hold on
    patch(x2,inBetween,'blue','FaceAlpha',.4);
    grid on
    xlim([1 27])
    xticks(inter);
    xticklabels(years);
    set(gca,'fontsize',24);
    set(gca,'LineWidth',2);
    text('Parent',gca,'FontSize',28,'String',anno{1,nTiles},...
        'Position',annpos{1,nTiles});
end
xlabel(t,'Year','FontSize', 40)
ylabel(t,'Days Since January 1st', 'FontSize', 40)

%Save at a high resolution
titlestring = "Figure4_DatelinesFinal.png";
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG

