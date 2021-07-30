%% Paul_LH_StandardFigureNEMOPanels.m (version 1.2)
%Author: Paul Ernst
%Date Created: 7/8/2021
%Date of Last Update: 7/12/2021
%Update History:
%PE 7/26/2021 - Added functionality for limited year brackets (e.g 1-2-4).
%PE 7/12/2021 - Added more core functionality (e.g. plot orientations).
%PE 7/8/2021 - Created
%--------------------------------------
%Purpose: Creates the 8-panel subfigure for the LH paper.
%
%Inputs: NEMO + CMEMS Calculations; AE_trajs; Root eddy IDs
%        A date (dayofyear) and an ID (eddy ID)
% SEE CONFIG FILE FOR FULL SETTINGS OF EDDIES SHOWN IN PAPER.
%Outputs:
%8 panels (1a 2b 3c 4d)
%         (5e 6f 7g 8h)
%Panel 1: 2D ADT (cm) Jet backing; Geostrophic Quivers / mid-cross-section-line overlaid.
%Panel 2: 2D SSS (g/kg) Jet backing; Geostrophic Quivers / midline overlaid.
%Panel 3: 2D SST (degrees C, CT) Jet backing; GQ/midline overlaid.
%Panel 4: 2D Spiciness0, Jet backing; GQ/midline overlaid.
%Panel 5: 3D Potential Denity (kg/m^3), Jet backing; with PD contours overlaid.
%Panel 6: 3D ASalinity (g/kg), Jet backing; with swirl velocity contours overlaid.
%Panel 7: 3D CTemperature (degrees C), Jet backing; with swirl velocity contours.
%Panel 8: 3D Vertical Velocity (m/s), RedBlue backing; with vertical velocity contours overlaid.
%--------------------------------------
%Steps (averaged over length(years) years):
%0: Input 1xlength(years) matrix of dates, get lat/lon center and radius from it
%1: Process the lat/lon center and radius into a box.
%2: Process the date.
%3: Grab the data for that region at that time from both CMEMS/NEMO:
%   CMEMS: U, V, ADT
%   NEMO: U, V, T, SAL, Depth
%4: Process the data into other necessary pieces:
%   NEMO: CT, AS, Spiciness0, Potential Density [Pressure]
%5: Plot all pieces on each panel in sequence.
%--------------------------------------
%% "Static" Inputs (once set, no need to redo)
warning ('off','all');
tic
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
addpath(strcat(basepath, 'GSW/')) %getting our GSW functions online
addpath(strcat(basepath, 'GSW/html/')) %getting our GSW functions online pt 2.
addpath(strcat(basepath, 'GSW/library/')) %getting our GSW functions online pt 3.
addpath(strcat(basepath, 'GSW/pdf')) %getting our GSW functions online pt 4.
addpath(strcat(basepath, 'GSW/thermodynamics_from_t')) %getting our GSW functions online pt 5.
addpath(strcat(basepath, 'FUNCTIONS/')); %fun with functions, where is our "nearestpoint" function mostly
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
load('AE_Filtered_Trajectories.mat') %load AE trajectories
load('ADTs.mat'); load('dateCorrelationFinal.mat'); %loading ADT/date data
load('FinalEddyIDLists.mat') %loading lists of eddies
input_dir = "/Volumes/NEMO1/GLORYS12V1/"; %input for GLORYS12V1
% years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
%     "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"]; %years
% yearsN = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27]; %years since 1992
years = ["2006"];
yearsN = [14];
months = ["/01";"/02";"/03";"/04";"/05";"/06";"/07";"/08";"/09";"/10";"/11";"/12"]; %months
disp("Static inputs loaded after " + toc + " seconds.");
%% "Dynamic" inputs (change based on what you want specifically)
titlestring = 'Ernst-LHWMFull1-FigureX.tiff'; %what are we naming our final figure?
date2use = [16]; %string of dates in dayofyear format, same length as years
edd2use = LHRoot; %IDs of these eddies
radscale = 2; %how far out from the radius are we going for our "surroundings" (recommended value is 2)
quiversp = 2; %how much we space the quivers (recommended value is 3)
outflag = 0; %change to 1 to remove outliers; change to 0 to keep outliers
outcount = 5; %number of valid counts below which is considered an outlier for interpolation
disp("Dynamic inputs loaded after " + toc + " seconds.");
%--------------------------------------
% 2d plots, change IN THE PLOT SECTION: Annotation Position, Text Colors
%--------------------------------------
% annpos2d = cell(1,4); (...)
% textcolor2d = cell(1,4); (...)
%--------------------------------------
% 3d plots, change IN THE PLOT SECTION: Annotation Position, Color Axis,
%Contour Levels, Lims and Ticks
%--------------------------------------
% annpos3d3d = cell(1,4); (...)
% cax3d = cell(1,4); (...)
% lev3d = cell(1,4); (...)
% xlim([WL EL]) %lon. limits from WL to EL
% xticks(50:2:58); %lon. ticks from WL to EL
% xticklabels(["50°E", "52°E", "54°E", "56°E", "58°E"]); %labels WL-EL
% SEE CONFIG FILE FOR FULL SETTINGS OF EDDIES SHOWN IN PAPER.
%% Getting other properties based on date (x, y, rad)
x_a = AE_traj(:,2); y_a = AE_traj(:,3); r_a = AE_traj(:,6); date_a=AE_traj(:,14);
daythreshLH = 200;
loncenter = zeros(1,length(years)); latcenter = zeros(1,length(years)); radius = zeros(1,length(years));
for i = 1:length(years)
    if (mod(yearsN(i),4) == 0)
        leap = 366;
    else
        leap = 365;
    end
    %loop thru all of the dates
    edd = edd2use(yearsN(i));
    date=date_a{edd,1};
    %find the index of the one we end up using
    for j = 1:length(date)
        date2=datestr(date(j));
        daynf=str2double(date2(1:2));
        month=date2(4:6);
        [monthint, ~] = monthconversion(month);
        year=str2double(date2(8:11));
        date3 = datetime([year monthint daynf]);
        dateLL = day(date3,'dayofyear');
        %center around the new year
        if (dateLL > daythreshLH)
            dateLL = dateLL-leap;
        end
        %if our date here matches the date we used in the other function
        if ((dateLL == date2use(i)) || (dateLL+leap == date2use(i)))
            %grab these values
            loncenter(i) = x_a{edd,1}(j); latcenter(i) = y_a{edd,1}(j);
            radius(i) = r_a{edd,1}(j);
            break
        end
    end
end
disp("Dates processed after " + toc + " seconds.");
%% Boxing, Dating and ADT/U/V grabbing for CMEMS
%loop thru all years
avgADTmat = cell(1,length(years)); avgUmat = cell(1,length(years)); avgVmat = cell(1,length(years));
lenmax = 0;
effectiveYearCMEMS = zeros(1,length(years)); effectiveDate = zeros(1,length(years));
effectiveYearNEMO = zeros(1,length(years));
NL = zeros(1,length(years)); SL = zeros(1,length(years)); EL = zeros(1,length(years)); WL = zeros(1,length(years));
NLadt = zeros(1,length(years)); SLadt = zeros(1,length(years)); ELadt = zeros(1,length(years)); WLadt = zeros(1,length(years));
for i = 1:length(years)
    %Boxing
    latoffset = radius(1,i)*radscale/110.573;
    lonoffset = radius(1,i)*radscale/(cosd(latcenter(1,i))*111.32);
    EL(1,i) = loncenter(1,i) + lonoffset; WL(1,i) = loncenter(1,i) - lonoffset;
    NL(1,i) = latcenter(1,i) + latoffset; SL(1,i) = latcenter(1,i) - latoffset;
    %Boxing for ADT reading purposes
    NLadt(1,i) = nearestpoint(NL(1,i), Y);   SLadt(1,i) = nearestpoint(SL(1,i), Y);
    ELadt(1,i) = nearestpoint(EL(1,i), X);   WLadt(1,i) = nearestpoint(WL(1,i), X);
    %is leap year?
    if (mod(yearsN(i),4) == 0)
        leap = 366;
    else
        leap = 365;
    end
    %process date
    if (date2use(i) <= 0)
        effectiveYearCMEMS(1,i) = yearsN(i)-1;
        effectiveYearNEMO(1,i) = i-1;
        effectiveDate(1,i) = leap+date2use(i);
    else
        effectiveYearCMEMS(1,i) = yearsN(i);
        effectiveYearNEMO(1,i) = i;
        effectiveDate(1,i) = date2use(i);
    end
    %acquire data
    avgADTmat{1,i} = ADTFinal{effectiveYearCMEMS(1,i), effectiveDate(1,i)}(WLadt(1,i):ELadt(1,i),SLadt(1,i):NLadt(1,i));
    lenmax = max(lenmax, length(avgADTmat{1,i}));
    avgUmat{1,i} = UFinal{effectiveYearCMEMS(1,i), effectiveDate(1,i)}(WLadt(1,i):ELadt(1,i),SLadt(1,i):NLadt(1,i));
    avgVmat{1,i} = VFinal{effectiveYearCMEMS(1,i), effectiveDate(1,i)}(WLadt(1,i):ELadt(1,i),SLadt(1,i):NLadt(1,i));
end
disp("Surface data read after " + toc + " seconds.");
%% Interpolate up to max length: CMEMS
%get average grid for interpolation purposes
ELavg = mean(EL); WLavg = mean(WL); NLavg = mean(NL); SLavg = mean(SL);
Xdiff = (ELavg-WLavg)/(lenmax-1); Ydiff = (NLavg-SLavg)/(lenmax-1);
Xg = WLavg:Xdiff:ELavg; Yg = SLavg:Ydiff:NLavg;
[Xq, Yq] = meshgrid(Xg,Yg);
avgADTsum = 0; avgUsum = 0; avgVsum = 0;
adtcount = 0; ucount = 0; vcount = 0;
countbasemat = ones(size(Xq));
for i = 1:length(years)
    %get initial grid, also for interpolation purposes
    [n, m] = size(avgADTmat{1,i});
    if (n ~= m)
        minval = min([n m]);
    else
        minval = n;
    end
    Xdiff = (EL(1,i)-WL(1,i))/(minval-1); Ydiff = (NL(1,i)-SL(1,i))/(minval-1);
    XdiffMax = (EL(1,i)-WL(1,i))/(lenmax-1); YdiffMax = (NL(1,i)-SL(1,i))/(lenmax-1);
    Xn = WL(1,i):Xdiff:EL(1,i); Yn = SL(1,i):Ydiff:NL(1,i);
    [Xm, Ym] = ndgrid(Xn,Yn); %grid of points to nan onto
    Xnb = WL(1,i):XdiffMax:EL(1,i); Ynb = SL(1,i):YdiffMax:NL(1,i);
    [Xmb, Ymb] = meshgrid(Xnb,Ynb); %grid of points to interpolate onto
    Xmb = transpose(Xmb); Ymb = transpose(Ymb);
    
    %interpolate between points: ADT
    mat2use = avgADTmat{1,i}(1:minval,1:minval);
    interpose = interp2(Xn, Yn, mat2use,Xmb,Ymb, 'linear'); %interpolate
    adtcount = adtcount + (countbasemat.*~isnan(interpose));
    interpose(isnan(interpose)) = 0; %remove NaN values so we don't wreck the sums
    avgADTsum = avgADTsum + interpose;
    
    %interpolate between points: surface U
    mat2use = avgUmat{1,i}(1:minval,1:minval);
    interpose = interp2(Xn, Yn, mat2use,Xmb,Ymb, 'linear'); %interpolate
    ucount = ucount + (countbasemat.*~isnan(interpose));
    interpose(isnan(interpose)) = 0; %remove NaN values so we don't wreck the sums
    avgUsum = avgUsum + interpose;
    
    %interpolate between points: surface V
    mat2use = avgVmat{1,i}(1:minval,1:minval);
    interpose = interp2(Xn, Yn, mat2use,Xmb,Ymb, 'linear'); %interpolate
    vcount = vcount + (countbasemat.*~isnan(interpose));
    interpose(isnan(interpose)) = 0; %remove NaN values so we don't wreck the sums
    avgVsum = avgVsum + interpose;
end
%averaging sums
avgADTsum = avgADTsum./adtcount; avgUsum = avgUsum./ucount; avgVsum = avgVsum./vcount;
%removing inconsistent values
if outflag
    avgADTsum(adtcount<outcount) = NaN;
    avgUsum(ucount<outcount) = NaN;
    avgVsum(vcount<outcount) = NaN;
end
avgADTsum = reshape(avgADTsum, size(interpose));
avgUsum = reshape(avgUsum, size(interpose));
avgVsum = reshape(avgVsum, size(interpose));
disp("Surface data interpolated after " + toc + " seconds.");
%% GLORYS Boxing and Naming
input_final = cell(31,length(months),length(years));
%Loop through all years/months/days to construct naming cell array to
%access later on when grabbing data from folders. Adjust above indices if
%you add any years to the dataset.
for i = 1:length(years)
    input_dirs(1,i) =  [input_dir + years(i)];
    for j = 1:length(months)
        input_dirs_months(i,j) = [input_dirs(1,i) + months(j)];
        intermediate = dir(input_dirs_months(i,j));
        for k = 3:length(intermediate)
            input_final{k-2,j,i} = [input_dirs_months(i,j) + "/" + convertCharsToStrings(intermediate(k).name)];
        end
    end
end

%Get the adaptive lat/lon bounds for this
latsTest = double(ncread(input_final{1,1,1}, 'latitude'));
lonsTest = double(ncread(input_final{1,1,1}, 'longitude'));
NLglo = zeros(1,length(years)); SLglo = zeros(1,length(years)); ELglo = zeros(1,length(years)); WLglo = zeros(1,length(years));
for i = 1:length(years)
    NLglo(1,i) = nearestpoint(NL(1,i), latsTest);   SLglo(1,i) = nearestpoint(SL(1,i), latsTest);
    ELglo(1,i) = nearestpoint(EL(1,i), lonsTest);   WLglo(1,i) = nearestpoint(WL(1,i), lonsTest);
end
disp("Subsurface data structures constructed after " + toc + " seconds.");
%% Read data from GLORYS directories
% latsGlo = ncread(input_final{1,1,1}, 'latitude', SLglo, NLglo-SLglo);
% lonsGlo = ncread(input_final{1,1,1}, 'longitude', WLglo, ELglo-WLglo);
% depths = ncread(input_final{1,1,1}, 'depth');
ptemps = cell(1,length(years)); sals = cell(1,length(years)); udep = cell(1,length(years)); vdep = cell(1,length(years));
lenmaxGlo = 0;
%Loop through all years
for i = 1:length(years)
    [mm, dd] = ddd2mmdd(effectiveYearCMEMS(i), effectiveDate(i));
    %cycle through the days/months we need here, and nothing else
    if ~isempty(input_final{dd,mm,effectiveYearNEMO(i)})
        %e.g. 602 is the start point of the variable you want to
        %read; 718 is how far BEYOND that point you go (so this
        %will end 718 after 602 = 1320.
        %Change if you want to read different depths, geographic
        %areas, etc.
        %Also we want eastward/northward velocities in 3D.
        %[WLglo(i),SLglo(i),1,1], [ELglo(i)-WLglo(i), NLglo(i)-SLglo(i), 50, 1]
        ptemps{1,i} = ncread(input_final{dd,mm,effectiveYearNEMO(i)}, 'thetao', [WLglo(i),SLglo(i),1,1], [ELglo(i)-WLglo(i), NLglo(i)-SLglo(i), 50, 1]);%[2642,602,1,1],[958,718,length(years),1]);
        lenmaxGlo = max(lenmaxGlo, length(ptemps{1,i}));
        sals{1,i} = ncread(input_final{dd,mm,effectiveYearNEMO(i)}, 'so', [WLglo(i),SLglo(i),1,1], [ELglo(i)-WLglo(i), NLglo(i)-SLglo(i), 50, 1]);
        udep{1,i} = ncread(input_final{dd,mm,effectiveYearNEMO(i)}, 'uo', [WLglo(i),SLglo(i),1,1], [ELglo(i)-WLglo(i), NLglo(i)-SLglo(i), 50, 1]);
        vdep{1,i} = ncread(input_final{dd,mm,effectiveYearNEMO(i)}, 'vo', [WLglo(i),SLglo(i),1,1], [ELglo(i)-WLglo(i), NLglo(i)-SLglo(i), 50, 1]);
    end
end
depthsGlo = transpose(double(ncread(input_final{dd,mm,effectiveYearNEMO(i)}, 'depth')));
disp("Subsurface data read after " + toc + " seconds.");
%% Interpolate up to max length: GLORYS
%get average grid for interpolation purposes
depths = 1:50;
ELavg = mean(EL); WLavg = mean(WL); NLavg = mean(NL); SLavg = mean(SL);
Xdiff = (ELavg-WLavg)/(lenmaxGlo-1); Ydiff = (NLavg-SLavg)/(lenmaxGlo-1);
Xg = WLavg:Xdiff:ELavg; Yg = SLavg:Ydiff:NLavg;
[XqGlo, YqGlo, ZqGlo] = meshgrid(Xg,Yg,depths);
ptempssum = 0; salssum = 0; udepsum = 0; vdepsum = 0;
ptempscount = 0; salscount = 0; udepcount = 0; vdepcount = 0;
countbasematGlo = ones(size(XqGlo));
for i = 1:length(years)
    %get initial grid, also for interpolation purposes
    [n, m, ~] = size(ptemps{1,i});
    if (n ~= m)
        minval = min([n m]);
    else
        minval = n;
    end
    Xdiff = (EL(1,i)-WL(1,i))/(minval-1); Ydiff = (NL(1,i)-SL(1,i))/(minval-1);
    XdiffMax = (EL(1,i)-WL(1,i))/(lenmaxGlo-1); YdiffMax = (NL(1,i)-SL(1,i))/(lenmaxGlo-1);
    Xn = WL(1,i):Xdiff:EL(1,i); Yn = SL(1,i):Ydiff:NL(1,i);
    Xnb = WL(1,i):XdiffMax:EL(1,i); Ynb = SL(1,i):YdiffMax:NL(1,i);
    [Xmb, Ymb, Zmb] = meshgrid(Xnb,Ynb,depths); %grid of points to interpolate onto
    
    %interpolate between points (ptemps)
    interpose = interp3(Xn, Yn, depths, ptemps{1,i}(1:minval,1:minval,:),Xmb,Ymb,Zmb, 'linear');
    ptempscount = ptempscount + (countbasematGlo.*~isnan(interpose));
    interpose(isnan(interpose)) = 0; %remove NaN values so we don't wreck the sums
    ptempssum = ptempssum + interpose;
    
    %interpolate between points (sals)
    interpose = interp3(Xn, Yn, depths, sals{1,i}(1:minval,1:minval,:),Xmb,Ymb,Zmb, 'linear');
    salscount = salscount + (countbasematGlo.*~isnan(interpose));
    interpose(isnan(interpose)) = 0;
    salssum = salssum + interpose;
    
    %interpolate between points (udep)
    interpose = interp3(Xn, Yn, depths, udep{1,i}(1:minval,1:minval,:),Xmb,Ymb,Zmb, 'linear');
    udepcount = udepcount + (countbasematGlo.*~isnan(interpose));
    interpose(isnan(interpose)) = 0;
    udepsum = udepsum + interpose;
    
    %interpolate between points (vdep)
    interpose = interp3(Xn, Yn, depths, vdep{1,i}(1:minval,1:minval,:),Xmb,Ymb,Zmb, 'linear');
    vdepcount = vdepcount + (countbasematGlo.*~isnan(interpose));
    interpose(isnan(interpose)) = 0;
    vdepsum = vdepsum + interpose;
    
end
%averaging sums
ptempssum = ptempssum./ptempscount; salssum = salssum./salscount;
udepsum = udepsum./udepcount; vdepsum = vdepsum./vdepcount;
%removing outlier values
if outflag
    ptempssum(ptempscount<outcount) = NaN;
    salssum(salscount<outcount) = NaN;
    udepsum(udepcount<outcount) = NaN;
    vdepsum(vdepcount<outcount) = NaN;
end
ptempssum = reshape(ptempssum, size(interpose));
salssum = reshape(salssum, size(interpose));
udepsum = reshape(udepsum, size(interpose));
vdepsum = reshape(vdepsum, size(interpose));
disp("Subsurface data interpolated after " + toc + " seconds.");
%% By now we have all of the raw data mats that we need
%but we do need some derived quantities: Pressure, AS, CT, pDensity,
%vertical velocity, ADT in cm, Spiciness0

%ADT to cm
avgADTsum = avgADTsum.*100;

%Pressure from DepthGLO
midind = round(length(YqGlo)/2); %find the midline
midlineLat = YqGlo(midind,1,1); %grab the midline lat
pressureGlo = gsw_p_from_z(gsw_depth_from_z(depthsGlo),midlineLat);
midlineLat2D = nearestpoint(midlineLat, Yq);
midlineLat3D = nearestpoint(midlineLat, YqGlo(:,:,1));

%AS from salsGLO
pressureGrid = ones(size(XqGlo));
%constructing pressuregrid
for i = 1:length(XqGlo)
    for j = 1:length(XqGlo)
        pressureGrid(i,j,:) = transpose(squeeze(pressureGrid(i,j,:))).*pressureGlo;
    end
end
[SAGlo, ~] = gsw_SA_from_SP(salssum, pressureGrid, XqGlo, YqGlo);
SAGloSurf = squeeze(SAGlo(:,:,1));

%CT from ptempsGLO
CTGlo = gsw_CT_from_pt(SAGlo,ptempssum);
CTGloSurf = squeeze(CTGlo(:,:,1));

%pDensity from AS and CT
rhoGlo = gsw_rho(SAGlo, CTGlo, 0);

%Vertical Velocity from equation 2, Greaser et al., 2020
for i = 1:length(XqGlo)
    for j = 1:length(XqGlo)
        wdepsum(i,j,:) = (gradient(squeeze(udepsum(i,j,:))) + gradient(squeeze(vdepsum(i,j,:)))).*-1;
    end
end

%Spiciness from AS and CT
SpiceGlo = gsw_spiciness0(SAGlo, CTGlo);
SpiceGloSurf = squeeze(SpiceGlo(:,:,1));

disp("Derivative data calculated after " + toc + " seconds.");
%% Plotting using Tiledlayout
%8 panels (1a 2b 3c 4d)
%         (5e 6f 7g 8h)
%Panel 1: 2D ADT (cm) Jet backing; Geostrophic Quivers / mid-cross-section-line overlaid.
%Panel 2: 2D SSS (g/kg) Jet backing; Geostrophic Quivers / midline overlaid.
%Panel 3: 2D SST (degrees C, CT) Jet backing; GQ/midline overlaid.
%Panel 4: 2D Spiciness0, Jet backing; GQ/midline overlaid.
%Panel 5: 3D Potential Denity (kg/m^3), Jet backing; with PD contours overlaid.
%Panel 6: 3D ASalinity (g/kg), Jet backing; with swirl velocity contours overlaid.
%Panel 7: 3D CTemperature (degrees C), Jet backing; with swirl velocity contours.
%Panel 8: 3D Vertical Velocity (m/s), RedBlue backing; with vertical velocity contours overlaid.

figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%Using TiledLayout for this so we can stuff it in a for-loop
t = tiledlayout(2,4,'TileSpacing','compact');

% Begin with 2d plots on top row
% CHANGE ANNPOS2D IF YOU CHANGE ANYTHING (annotation position in lon-lat)
annpos2d = cell(1,4);  annpos2d{1,1} = [72.4, 10]; annpos2d{1,2} = [72.4, 10]; ...
    annpos2d{1,3} = [72.4, 10]; annpos2d{1,4} = [72.4, 10];
anno2d = cell(1,4); anno2d{1,1} = "(a)"; anno2d{1,2} = "(b)"; anno2d{1,3} = "(c)"; anno2d{1,4} = "(d)";
tilemat2d = cell(1,4); tilemat2d{1,1} = transpose(avgADTsum); tilemat2d{1,2} = SAGloSurf;...
    tilemat2d{1,3} = CTGloSurf; tilemat2d{1,4} = SpiceGloSurf;
xmat2d = cell(1,4); xmat2d{1,1} = Xq; xmat2d{1,2} = XqGlo(:,:,1); xmat2d{1,3} = XqGlo(:,:,1);...
    xmat2d{1,4} = XqGlo(:,:,1);
ymat2d = cell(1,4); ymat2d{1,1} = Yq; ymat2d{1,2} = YqGlo(:,:,1); ymat2d{1,3} = YqGlo(:,:,1);...
    ymat2d{1,4} = YqGlo(:,:,1);
title2d = cell(1,4); title2d{1,1} = "ADT (cm)"; title2d{1,2} = "SSS (g kg^-^1)";...
    title2d{1,3} = "SST (°C)"; title2d{1,4} = "Spiciness";
% CHANGE CAX2D IF YOU CHANGE ANYTHING (color axis)
% cax2d = cell(1,4); cax2d{1,1} = [40 110]; cax2d{1,2} = [35.3 36]; cax2d{1,3} = [25 28];...
%     cax2d{1,4} = [5.2 6.2];
textcolor2d = cell(1,4); textcolor2d{1,1} = 'w'; textcolor2d{1,2} = 'k'; textcolor2d{1,3} = 'k';...
    textcolor2d{1,4} = 'k';
%Loop through plots to be made: 2d surface
for nTiles = 1:4
    ax = nexttile;
    m_proj('mercator','longitude',[WLavg ELavg],'latitude',[SLavg NLavg])
    hold on
    m_pcolor(xmat2d{1,nTiles}, ymat2d{1,nTiles}, transpose(tilemat2d{1,nTiles})) %property
    shading interp
    colormap(ax,'jet')
    h1 = m_quiver(Xq(1:quiversp:end,1:quiversp:end),Yq(1:quiversp:end,1:quiversp:end)...
        ,avgUsum(1:quiversp:end,1:quiversp:end)...
        ,avgVsum(1:quiversp:end,1:quiversp:end),'-k'); %geostrophic vectors
    set(h1,'AutoScale','on', 'AutoScaleFactor', 1.6)
    set(h1,'LineWidth',1.6)
    m_plot([WLavg ELavg], [midlineLat, midlineLat], '--w', 'LineWidth', 6); %midline
    hold on
    m_coast('patch',[.5 .5 .5]);
    hold on
    m_grid('box', 'fancy','fontsize',26);
    hold on
    colorbar('southoutside')
    set(gca,'fontsize',24);
    set(gca,'LineWidth',2);
    %caxis(ax, cax2d{1,nTiles});
    m_text(annpos2d{1,nTiles}(1), annpos2d{1,nTiles}(2), anno2d{1,nTiles}, 'fontsize', 32, 'Color', textcolor2d{1,nTiles});
    title(title2d{1,nTiles});
    ax = gca;
    if ismember(nTiles,[2 3])
        set(gca,'ytick',[])
    elseif nTiles == 4
        ax.YAxisLocation = 'right';
    end
end

disp("2D Plotting finished after " + toc + " seconds.");

% End with 3d tiles on bottom row
% CHANGE ANNPOS3D IF YOU CHANGE ANYTHING (annotation position in data)
annpos3d = cell(1,4);  annpos3d{1,1} = [76.1, -337.5]; annpos3d{1,2} = [76.1, -337.5];...
    annpos3d{1,3} = [76.1, -337.5]; annpos3d{1,4} = [76.1, -337.5];
anno3d = cell(1,4); anno3d{1,1} = "(e)"; anno3d{1,2} = "(f)"; anno3d{1,3} = "(g)"; anno3d{1,4} = "(h)";
tilemat3d = cell(1,4); tilemat3d{1,1} = rhoGlo(midlineLat3D,:,:); tilemat3d{1,2} = SAGlo(midlineLat3D,:,:);...
    tilemat3d{1,3} = CTGlo(midlineLat3D,:,:); tilemat3d{1,4} = wdepsum(midlineLat3D,:,:);
title3d = cell(1,4); title3d{1,1} = "Potential Density (kg m^-^3)"; title3d{1,2} = "Absolute Salinity (g kg^-^1)";...
    title3d{1,3} = "Conservative Temperature (°C)"; title3d{1,4} = "Vertical Velocity (m s^-^1)";
colormap3d = cell(1,4); colormap3d{1,1} = 'jet'; colormap3d{1,2} = 'jet'; colormap3d{1,3} = 'jet';...
    colormap3d{1,4} = redblue;
contourmat3d = cell(1,4); contourmat3d{1,1} = rhoGlo(midlineLat3D,:,:); contourmat3d{1,2} = vdepsum(midlineLat3D,:,:);...
    contourmat3d{1,3} = vdepsum(midlineLat3D,:,:); contourmat3d{1,4} = wdepsum(midlineLat3D,:,:);
% CHANGE CAX3D IF YOU CHANGE ANYTHING (color axis)
cax3d = cell(1,4); cax3d{1,1} = [1020 1027]; cax3d{1,2} = [31.5 35.4]; cax3d{1,3} = [10 30];...
    cax3d{1,4} = [-.06 .06];
% CHANGE LEV3D IF YOU CHANGE ANYTHING (contour level interval)
lev3d = cell(1,4); lev3d{1,1} = [1]; lev3d{1,2} = [0.1]; lev3d{1,3} = [0.1];...
    lev3d{1,4} = [0.05];
rnd3d = cell(1,4); rnd3d{1,1} = [0]; rnd3d{1,2} = [1]; rnd3d{1,3} = [1];...
    rnd3d{1,4} = [1];
textcolor3d = cell(1,4); textcolor3d{1,1} = 'w'; textcolor3d{1,2} = 'w'; textcolor3d{1,3} = 'w';...
    textcolor3d{1,4} = 'k';
%Loop through plots to be made: 3d surface
for nTiles = 1:4
    ax = nexttile;
    pcolor((squeeze(XqGlo(midlineLat3D,:,1))), gsw_depth_from_z(depthsGlo), transpose(squeeze(tilemat3d{1,nTiles}))) %property
    hold on
    shading interp
    colormap(ax,colormap3d{1,nTiles})
    minx = squeeze(min(min(contourmat3d{1,nTiles})));
    maxx = squeeze(max(max(contourmat3d{1,nTiles})));
    levels =  round(minx,rnd3d{1,nTiles}):lev3d{1,nTiles}:round(maxx,rnd3d{1,nTiles});
    levels = levels(levels~=0);
    [C, h] = contour((squeeze(XqGlo(midlineLat3D,:,1))), gsw_depth_from_z(depthsGlo),...
        transpose(squeeze(contourmat3d{1,nTiles})),levels,...
        'Color', 'k', 'ShowText', 'on', 'LineWidth', 3);
    clabel(C,h,'FontWeight','bold')
    clabel(C,h,'FontSize',12);
    colorbar('southoutside')
    set(gca,'fontsize',24);
    set(gca,'LineWidth',2);
    ylim([-375 0])
    yticks([-300, -200, -100, 0])
    yticklabels(["300" "200" "100" "0"])
    xlim([WLavg ELavg])
    xticks(72:1:76);
    xticklabels(["72°E", "73°E", "74°E", "75°E", "76°E"]);
    text('Parent',gca,'FontSize',32,'String',anno3d{1,nTiles},...
        'Position',annpos3d{1,nTiles},'Color', textcolor3d{1,nTiles});
    caxis(ax, cax3d{1,nTiles});
    title(title3d{1,nTiles});
    if nTiles==1
        ylabel("Depth (m)")
    elseif ismember(nTiles,[2 3])
        yticks([]);
    else
        ax.YAxisLocation = 'right';
    end
end

disp("3D Plotting finished after " + toc + " seconds.");

%% Save at a high resolution
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG

disp("Figure completed and saved after " + toc + " seconds.");
%% Function for converting dayofyear to month+day
function [mm,dd] = ddd2mmdd(year, ddd)
v = datevec(datenum(year, ones(size(year)), ddd));
mm = v(:,2); dd = v(:,3);
end

%% Function for redblue colormap
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




