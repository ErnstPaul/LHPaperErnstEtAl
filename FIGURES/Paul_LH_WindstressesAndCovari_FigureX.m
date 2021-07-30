%% Paul_LH_WindstressesAndCovari_FigureX.m (version 2.0)
%Author: Paul Ernst
%Date Created: 7/20/2021
%Date of Last Update: 7/20/2021
%Update History:
%PE 7/28/2021 - Added Covariance testing and plotting functionality
%PE 7/20/2021 - Created
%--------------------------------------
%Purpose: Puts together a full figure of wind stress curls for LH
%Inputs: Full UV wind files from https://www.ncdc.noaa.gov/data-access/marineocean-data/blended-global/blended-sea-winds
%Outputs: One figure, 3 columns, 6 rows: Jan/Feb/Mar/Apr/May/Jun
%Pcolor: Wind Stress Curl
%Contours: ADT (literally ctrl+F and replace "ADT" with "ADT" or vice-versa
%--------------------------------------
tic
titlestring = "Ernst-WSCCovari-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath(strcat(basepath, 'FUNCTIONS'));
load('WindStresses.mat'); load('JetWhiteCenter.mat') %literally jet but white centered
Xwind = X;
Ywind = Y;
load("ADTs.mat")
load("StandardFigureTrajectoryPanelLH.mat")
load("dateCorrelationFinal.mat", "dateLH");
lenTrue = length(Stress);
%Dataset here does not include 2017-2019
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016"];%,"2017","2018", "2019"];
halfyears = ["1994", "1999", "2003", "2011", "2013"];%, "2019];
localyears = ["1997", "1998", "2004", "2010"];
fullyears = ["1993","1995", "1996", "2000", "2001", "2002", "2005", "2006", "2007", "2008", "2009", "2012"...
    "2014", "2015", "2016"];%, "2017", "2018"];
halfyearsN = [2, 7, 11, 19, 21, 27];
localyearsN = [5, 6, 12, 18];
fullyearsN = [1, 3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
    22, 23, 24, 25, 26];
latlonbounds = [25, 3, 80, 40]; % [N, S, E, W] lat long boundaries
yearmetadata = [1993101, 20161231]; %[YYYYMMDD, YYYYMMDD] start and end dates of the data
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
row1d = "0101"; %jan
row1dt = day(datetime(2000, 01, 01),'dayofyear');
row2d = "0201"; %feb
row2dt = day(datetime(2000, 02, 01),'dayofyear');
row3d = "0301"; %mar
row3dt = day(datetime(2000, 03, 01),'dayofyear');
row4d = "0401"; %apr
row4dt = day(datetime(2000, 04, 01),'dayofyear');
row5d = "0501"; %may
row5dt = day(datetime(2000, 05, 01),'dayofyear');
row6d = "0601"; %june
row6dt = day(datetime(2000, 06, 01),'dayofyear');
rows = [row1dt, row2dt, row3dt, row4dt, row5dt, row6dt];
nRows = length(rows);

disp("Input data read after " + toc + " seconds.");
%% Grab and process date from LH for later
%half-local-full
% datecell = cell(1,3); datecell{1,1} = toplotTrajLH{3,3}; datecell{1,2} = toplotTrajLH{3,1}(1:138);...
%     datecell{1,3} = toplotTrajLH{3,2}(1:90);
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
        if ind == length(datecell{1,i})
            toplotx(i,j) = 0;
            toploty(i,j) = 0;
        else
            toplotx(i,j) = mean(xcell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
            toploty(i,j) = mean(ycell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
        end
    end
end

%Find the index point for LH on those given dates
%then use that index point to shunt the x's and y's at that same date
% for i = 1:3
%     for j = 1:nRows
%         ind = nearestpoint(rows(j),datecell{1,i});
%         %if this is the same, then this shouldn't exist
%         if ind == length(datecell{1,i})
%             toplotx(i,j) = 0;
%             toploty(i,j) = 0;
%         else
%             toplotx(i,j) = mean(xcell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
%             toploty(i,j) = mean(ycell{1,i}(ind:min(length(datecell{1,i}),ind+7)));
%         end
%     end
% end

disp("LH data processed after " + toc + " seconds.");

%% Remove NaNs from Windstress Curl Matrix for summation later
Xwind = Xwind(1:160,1);
Ywind = Ywind(1:180,1);
%cycle through matrix, turning NaNs into 0s
%I'd love to do this more efficiently, but to preserve order our hands are
%tied
for i = 1:lenTrue
    for j = 1:length(Xwind)+1
        for k = 1:length(Ywind)+1
            if isnan(StressCurl{1,i}(k,j))
                StressCurl{1,i}(k,j) = 0;
            end
        end
    end
end

disp("NaN WSC data removed after " + toc + " seconds.");

%% Process Data
%loops like this are just so I can close the code when looking at overall
%organization, no functional purpose

colFull = cell(4,nRows); %ADT/U/V/Stress held for these years
colHalf = cell(4,nRows); %Half years
colLocal = cell(4,nRows); %Local years
for i = 1:nRows
    for j = 1:3
        colFull{j,i} = zeros(length(X),length(Y));
        colHalf{j,i} = zeros(length(X),length(Y));
        colLocal{j,i} = zeros(length(X),length(Y));
    end
    j = 4;
    colFull{j,i} = zeros(length(Xwind),length(Ywind));
    colHalf{j,i} = zeros(length(Xwind),length(Ywind));
    colLocal{j,i} = zeros(length(Xwind),length(Ywind));
end
leapsum = 0;
%Loop thru all years: sorting by month and day (extractBetween)
%then placing in appropriate year afterwards
%need a shitton of these matrices because this dataset is a piece of shit
sumF4 = zeros(160,180,6); sumH4 = zeros(160,180,6); sumL4 = zeros(160,180,6);
for i = 1:length(years)
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
            if ismember(years(i), fullyears)
                for k = 1:7
                    colFull{1,1} = colFull{1,1} + ADTFinal{i,j+k};
                    colFull{2,1} = colFull{2,1} + UFinal{i,j+k};
                    colFull{3,1} = colFull{3,1} + VFinal{i,j+k};
                    colFull{4,1} = colFull{4,1} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumF4(:,:,1) = sumF4(:,:,1) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,1} = colHalf{1,1} + ADTFinal{i,j+k};
                    colHalf{2,1} = colHalf{2,1} + UFinal{i,j+k};
                    colHalf{3,1} = colHalf{3,1} + VFinal{i,j+k};
                    colHalf{4,1} = colHalf{4,1} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,1) = sumH4(:,:,1) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,1} = colLocal{1,1} + ADTFinal{i,j+k};
                    colLocal{2,1} = colLocal{2,1} + UFinal{i,j+k};
                    colLocal{3,1} = colLocal{3,1} + VFinal{i,j+k};
                    colLocal{4,1} = colLocal{4,1} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,1) = sumL4(:,:,1) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
            
            % ROW 2
        elseif monthday == row2d %matches first date
            if ismember(years(i), fullyears)
                for k = 1:7
                    colFull{1,2} = colFull{1,2} + ADTFinal{i,j+k};
                    colFull{2,2} = colFull{2,2} + UFinal{i,j+k};
                    colFull{3,2} = colFull{3,2} + VFinal{i,j+k};
                    colFull{4,2} = colFull{4,2} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumF4(:,:,2) = sumF4(:,:,2) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,2} = colHalf{1,2} + ADTFinal{i,j+k};
                    colHalf{2,2} = colHalf{2,2} + UFinal{i,j+k};
                    colHalf{3,2} = colHalf{3,2} + VFinal{i,j+k};
                    colHalf{4,2} = colHalf{4,2} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,2) = sumH4(:,:,2) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,2} = colLocal{1,2} + ADTFinal{i,j+k};
                    colLocal{2,2} = colLocal{2,2} + UFinal{i,j+k};
                    colLocal{3,2} = colLocal{3,2} + VFinal{i,j+k};
                    colLocal{4,2} = colLocal{4,2} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,2) = sumL4(:,:,2) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
            
            %ROW 3
        elseif monthday == row3d %matches first date
            if ismember(years(i), fullyears) %if this is the precursor to a full year
                for k = 1:7
                    colFull{1,3} = colFull{1,3} + ADTFinal{i,j+k};
                    colFull{2,3} = colFull{2,3} + UFinal{i,j+k};
                    colFull{3,3} = colFull{3,3} + VFinal{i,j+k};
                    colFull{4,3} = colFull{4,3} + transpose(StressCurl{1,leapsum+j}(1:180,1:160));
                    sumF4(:,:,3) = sumF4(:,:,3) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,3} = colHalf{1,3} + ADTFinal{i,j+k};
                    colHalf{2,3} = colHalf{2,3} + UFinal{i,j+k};
                    colHalf{3,3} = colHalf{3,3} + VFinal{i,j+k};
                    colHalf{4,3} = colHalf{4,3} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,3) = sumH4(:,:,3) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,3} = colLocal{1,3} + ADTFinal{i,j+k};
                    colLocal{2,3} = colLocal{2,3} + UFinal{i,j+k};
                    colLocal{3,3} = colLocal{3,3} + VFinal{i,j+k};
                    colLocal{4,3} = colLocal{4,3} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,3) = sumL4(:,:,3) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
            
            %ROW 4
        elseif monthday == row4d %matches first date
            if ismember(years(i), fullyears) %if this is the precursor to a full year
                for k = 1:7
                    colFull{1,4} = colFull{1,4} + ADTFinal{i,j+k};
                    colFull{2,4} = colFull{2,4} + UFinal{i,j+k};
                    colFull{3,4} = colFull{3,4} + VFinal{i,j+k};
                    colFull{4,4} = colFull{4,4} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumF4(:,:,4) = sumF4(:,:,4) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,4} = colHalf{1,4} + ADTFinal{i,j+k};
                    colHalf{2,4} = colHalf{2,4} + UFinal{i,j+k};
                    colHalf{3,4} = colHalf{3,4} + VFinal{i,j+k};
                    colHalf{4,4} = colHalf{4,4} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,4) = sumH4(:,:,4) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,4} = colLocal{1,4} + ADTFinal{i,j+k};
                    colLocal{2,4} = colLocal{2,4} + UFinal{i,j+k};
                    colLocal{3,4} = colLocal{3,4} + VFinal{i,j+k};
                    colLocal{4,4} = colLocal{4,4} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,4) = sumL4(:,:,4) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
            
            %ROW 5
        elseif monthday == row5d %matches first date
            if ismember(years(i), fullyears) %if this is a full year
                for k = 1:7
                    colFull{1,5} = colFull{1,5} + ADTFinal{i,j+k};
                    colFull{2,5} = colFull{2,5} + UFinal{i,j+k};
                    colFull{3,5} = colFull{3,5} + VFinal{i,j+k};
                    colFull{4,5} = colFull{4,5} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumF4(:,:,5) = sumF4(:,:,5) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,5} = colHalf{1,5} + ADTFinal{i,j+k};
                    colHalf{2,5} = colHalf{2,5} + UFinal{i,j+k};
                    colHalf{3,5} = colHalf{3,5} + VFinal{i,j+k};
                    colHalf{4,5} = colHalf{4,5} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,5) = sumH4(:,:,5) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,5} = colLocal{1,5} + ADTFinal{i,j+k};
                    colLocal{2,5} = colLocal{2,5} + UFinal{i,j+k};
                    colLocal{3,5} = colLocal{3,5} + VFinal{i,j+k};
                    colLocal{4,5} = colLocal{4,5} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,5) = sumL4(:,:,5) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
            
            %ROW 6
        elseif monthday == row6d %matches first date
            if ismember(years(i), fullyears) %if this is a full year
                for k = 1:7
                    colFull{1,6} = colFull{1,6} + ADTFinal{i,j+k};
                    colFull{2,6} = colFull{2,6} + UFinal{i,j+k};
                    colFull{3,6} = colFull{3,6} + VFinal{i,j+k};
                    colFull{4,6} = colFull{4,6} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumF4(:,:,6) = sumF4(:,:,6) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), halfyears)
                for k = 1:7
                    colHalf{1,6} = colHalf{1,6} + ADTFinal{i,j+k};
                    colHalf{2,6} = colHalf{2,6} + UFinal{i,j+k};
                    colHalf{3,6} = colHalf{3,6} + VFinal{i,j+k};
                    colHalf{4,6} = colHalf{4,6} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumH4(:,:,6) = sumH4(:,:,6) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            elseif ismember(years(i), localyears)
                for k = 1:7
                    colLocal{1,6} = colLocal{1,6} + ADTFinal{i,j+k};
                    colLocal{2,6} = colLocal{2,6} + UFinal{i,j+k};
                    colLocal{3,6} = colLocal{3,6} + VFinal{i,j+k};
                    colLocal{4,6} = colLocal{4,6} + transpose(StressCurl{1,leapsum+j+k}(1:180,1:160));
                    sumL4(:,:,6) = sumL4(:,:,6) + isnan(transpose(StressCurl{1,leapsum+j+k}(1:180,1:160)));
                end
            end
        end
    end
    %add the years together because blended winds sucks l a r g e nards
    %and by that I mean that it's literally all days in sequence...somehow
    leapsum = leapsum + leap;
end

%Average each of the above over the number of years they have
for i = 1:nRows
    for j = 1:4
        if j == 1
            modi = 100;
        else
            modi = 1;
        end
        if j ~= 4
            colFull{j,i} = colFull{j,i}/(length(fullyears)*7).*modi;
            colHalf{j,i} = colHalf{j,i}/(length(halfyears)*7).*modi;
            colLocal{j,i} = colLocal{j,i}/(length(localyears)*7).*modi;
        else
            %Dividing Full Windstress (NaN avoidance)
            inbetween = ones(160,180).*length(fullyears).*7;
            divmatfull = sumF4(:,:,nRows)+inbetween;
            colFull{j,i} = colFull{j,i}./divmatfull;
            %Dividing Half Windstress (NaN avoidance)
            inbetween = ones(160,180).*length(halfyears).*7;
            divmathalf = sumH4(:,:,nRows)+inbetween;
            colHalf{j,i} = colHalf{j,i}./divmathalf;
            %Dividing Local Windstress (NaN avoidance)
            inbetween = ones(160,180).*length(localyears).*7;
            divmatlocal = sumL4(:,:,nRows)+inbetween;
            colLocal{j,i} = colLocal{j,i}./divmatlocal;
        end
    end
end

disp("Surface data processed and sorted after " + toc + " seconds.");

%% Covariance Testing
covariFull = cell(1,nRows);
covariHalf = cell(1,nRows);
covariLocal = cell(1,nRows);
%Construct grid spacing for this X and Y
spaceGridx = round(length(X)/10);
spaceGridy = round(length(Y)/10);
%loop over: Row, then Spacial Grid
for i = 1:nRows
    for j = 1:length(X)
        for k = 1:length(Y)
            %Hoping for a 1/10x1/10 grid to covar on, we'll settle for less
            xBridge = max(j-spaceGridx,1):min(j+spaceGridx,length(X));
            yBridge = max(k-spaceGridy,1):min(k+spaceGridy,length(Y));
            %Perform Covar
            inbetweenFull = nancov(colFull{4,i}(xBridge,yBridge), colFull{1,i}(xBridge,yBridge));
            covariFull{1,i}(j,k) = inbetweenFull(2);
            inbetweenHalf = nancov(colHalf{4,i}(xBridge,yBridge), colHalf{1,i}(xBridge,yBridge));
            covariHalf{1,i}(j,k) = inbetweenHalf(2);
            inbetweeLocal = nancov(colLocal{4,i}(xBridge,yBridge), colLocal{1,i}(xBridge,yBridge));
            covariLocal{1,i}(j,k) = inbetweeLocal(2);
        end
    end
    %Normalize covars: positive full
    covariFull{1,i} = normPosNeg(covariFull{1,i});
    covariHalf{1,i} = normPosNeg(covariHalf{1,i});
    covariLocal{1,i} = normPosNeg(covariLocal{1,i});
end
disp("Covariances calculated after " + toc + " seconds.");
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

%Construct separate grid for WSC
Xwgrid = zeros(length(Xwind),length(Ywind));
Ywgrid = zeros(length(Xwind),length(Ywind));
for p = 1:length(Ywind)
    Xwgrid(:,p) = Xwind(:,1);
end
for p = 1:length(Xwind)
    Ywgrid(p,:) = Ywind(:,1);
end

figure('units', 'normalized', 'outerposition', [0 0.0652777777777778 0.4359375 0.917361111111111])
t = tiledlayout(6,3,'TileSpacing','none');
% 6 Panels per column
%----------------------------------------------------------------------------
% FULL YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(a) January"; anno{1,2} = "(b) February"; ...
    anno{1,3} = "(c) March"; anno{1,4} = "(d) April"; ...
    anno{1,5} = "(e) May"; anno{1,6} = "(f) June";
for i = 1:nRows
    %1, 4, 7, 10, 13, 16
    nexttile((1+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    %m_pcolor(Xwgrid,Ywgrid,colFull{4,i}) %wind pcolor
    m_pcolor(Xwgrid,Ywgrid,covariFull{1,i}) %wind covari
    shading flat
    m_contour(Xgrid,Ygrid,colFull{1,i}, [70 75 80 85 90], 'color', 'k','LineWidth',1.25) %adt contours
    %m_contour(Xgrid,Ygrid,colFull{1,i}, [5 7.5 10 12.5 15], 'color', 'k','LineWidth',1.25) % sla contours
    m_plot(toplotx(1,i),toploty(1,i), '*k', 'MarkerSize', 22, 'LineWidth', 2); %g if pcolor, k if covari
    m_plot(toplotx(1,i),toploty(1,i), 'ok', 'MarkerSize', 22, 'LineWidth', 2);
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',22,'xticklabels',[], 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    else
        m_grid('box', 'fancy','fontsize',22, 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    end
    hold on
    %colormap(redblue) %wind pcolor
    colormap(JetWhiteCenter) %wind covari
    % Anno
    hold on
    m_text(41,23,anno{1,i},'color','w','fontsize',22);
    set(gca,'fontsize',24);
    %caxis([-0.0000001 0.0000001]); %wind pcolor
    caxis([-1 1]); %wind covari
    %     xlabel("Longitude")
    %     ylabel("Latitude")
end

%----------------------------------------------------------------------------
% HALF YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(g) January"; anno{1,2} = "(h) February"; ...
    anno{1,3} = "(i) March"; anno{1,4} = "(j) April"; ...
    anno{1,5} = "(k) May"; anno{1,6} = "(l) June";
for i = 1:nRows
    nexttile((2+3*(i-1)))
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    %m_pcolor(Xwgrid,Ywgrid,colHalf{4,i}) %wind pcolor
    m_pcolor(Xwgrid,Ywgrid,covariHalf{1,i}) %wind covari
    m_contour(Xgrid,Ygrid,colHalf{1,i}, [70 75 80 85 90], 'color', 'k','LineWidth',1.25) %adt contours
    %m_contour(Xgrid,Ygrid,colHalf{1,i}, [5 7.5 10 12.5 15], 'color', 'k','LineWidth',1.25) % sla contours
    m_plot(toplotx(2,i),toploty(2,i), '*k', 'MarkerSize', 22, 'LineWidth', 2);
    m_plot(toplotx(2,i),toploty(2,i), 'ok', 'MarkerSize', 22, 'LineWidth', 2);
    shading flat
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[],'xticklabels',[], 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    else
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[], 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    end
    hold on
    % Anno
    hold on
    m_text(41,23,anno{1,i},'color','w','fontsize',22);
    set(gca,'fontsize',24);
    %caxis([-0.0000001 0.0000001]); %wind pcolor
    caxis([-1 1]); %wind covari
    %     xlabel("Longitude")
end

%----------------------------------------------------------------------------
% LOCAL YEAR COLUMN
anno = cell(1,6); anno{1,1} = "(m) January"; anno{1,2} = "(n) February"; ...
    anno{1,3} = "(o) March"; anno{1,4} = "(p) April"; ...
    anno{1,5} = "(q) May"; anno{1,6} = "(r) June";
for i = 1:nRows
    ax = nexttile((3+3*(i-1)));
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    hold on
    %m_pcolor(Xwgrid,Ywgrid,colLocal{4,i})
    m_pcolor(Xwgrid,Ywgrid,covariLocal{1,i}) %wind covari
    shading flat
    m_contour(Xgrid,Ygrid,colLocal{1,i}, [70 75 80 85 90], 'color', 'k','LineWidth',1.25) % adt contours
    %m_contour(Xgrid,Ygrid,colLocal{1,i}, [5 7.5 10 12.5 15], 'color', 'k','LineWidth',1.25) % sla contours
    m_plot(toplotx(3,i),toploty(3,i), '*k', 'MarkerSize', 22, 'LineWidth', 2);
    m_plot(toplotx(3,i),toploty(3,i), 'ok', 'MarkerSize', 22, 'LineWidth', 2);
    m_coast('patch',[.5 .5 .5]);
    if i ~= nRows
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[],'xticklabels',[], 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    else
        m_grid('box', 'fancy','fontsize',22,'yticklabels',[], 'xtick', [45 55 65 75],'ytick', [4 10 16 22]);
    end
    hold on
    % Anno
    m_text(41,23,anno{1,i},'color','w','fontsize',22);
    set(gca,'fontsize',24);
    %caxis([-0.0000001 0.0000001]); %wind pcolor
    caxis([-1 1]); %wind covari
    %     xlabel("Longitude")
end
colorbar(gca,'Position',...
    [0.9210481444333 0.223832528180354 0.0296687014448362 0.55877616747182], 'FontSize', 20);
%cb.Layout.Tile = 'east';

disp("Plotting done after " + toc + " seconds.");

%% Save Figure
%Using Export_Fig for max resolution (magnified, AA'd)
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl','-nocrop'); %saves to local directory as PNG

disp("Figure saved and exported after " + toc + " seconds.");

%% Normalize positive and negative matrices

function returnmat = normPosNeg(inputmat)
tempmat = inputmat;

%Process positive normalizing
posLog = tempmat>0;
posMat = tempmat.*posLog;
posMat(abs(posMat)>4*nanstd(posMat)) = NaN; %remove outliers
posMat = posMat./max(max(posMat));

%Process negative normalizing
negLog = tempmat<0;
negMat = tempmat.*negLog;
negMat(abs(negMat)>3*nanstd(negMat)) = NaN; %remove outliers
negMat = negMat./max(max(abs(negMat)));

%Add the two together
returnmat = posMat + negMat;

%Revert outlier specifications post-calculation
returnmat = inpaint_nans(returnmat,3);
% [x, y] = size(returnmat);
% spaceGridx = round(x/20);
% spaceGridy = round(y/20);
% for i = 1:x
%     for j = 1:y
%         if isnan(returnmat(i,j))
%             xBridge = max(i-spaceGridx,1):min(i+spaceGridx,x);
%             yBridge = max(j-spaceGridy,1):min(j+spaceGridy,y);
%             if isnan(inputmat(i,j))
%                 continue;
%             elseif (inputmat(i,j)>0)
%                 returnmat(i,j) = nanmean(nanmean(posMat(xBridge,yBridge)));
%             elseif (inputmat(i,j)<0)
%                 returnmat(i,j) = nanmean(nanmean(negMat(xBridge,yBridge)));
%             end
%         end
%     end
% end
 end

%% redblue colormap
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