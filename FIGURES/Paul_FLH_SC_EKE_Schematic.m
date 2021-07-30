%% Paul_SC_EKE_Schematic.m (version 1.0)
%Author: Paul Ernst
%Date Created: 6/8/2021
%Date of Last Update: 6/8/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Creates a seasonal schematic for EKE during 1993-2019.
%Inputs: CMEMS altimetry data from this time period. (ADT, VGOS, UGOS)
%Outputs: One schematic of EKE averaged per season in this time.
%--------------------------------------
%% Inputs
titlestring = "PerSeasonEKESchematic.png";
pathtodata = '/Volumes/Lacie-SAN/SAN2/CMEMS/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/';
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath(strcat(basepath, 'FUNCTIONS'));
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
latlonbounds = [30, -15, 80, 40]; % [N, S, E, W] lat long boundaries
yearmetadata = [19930101, 20191231]; %[YYYYMMDD, YYYYMMDD] start and end dates of the data
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
Begin = yearmetadata(1);
End = yearmetadata(2);
yrb = fix(Begin/10000); datebeg = datenum(num2str(Begin),'yyyymmdd');
yre = fix(End/10000); dateend = datenum(num2str(End),'yyyymmdd');
EKEFinal = cell(27,366);
dates4later = string(zeros(length(years),366));
names4later = string(zeros(length(years),366));
%% Process Data
%% Loop through all years
for i = 1:length(years) %par
    input_str = (pathtodata + years(i) + '/');
    input_dir = convertStringsToChars(input_str);
    %% Construct name matrix
    count = 0;
    list_ADT = [];
    list_ADT = [list_ADT;dir([input_dir '/*.nc'])]; % make sure this directory exists
    %get date in proper format
    for qq = 1:length(list_ADT)
        dates4later(i,qq) = list_ADT(qq).name;
        dates4later(i,qq) = extractAfter(dates4later(i,qq),22);
        dates4later(i,qq) = extractBefore(dates4later(i,qq),9);
        names4later(i,qq) = dates4later(i,qq);
    end
    IND=[]; %Index
    for kop=1:length(list_ADT) %5800
        name = list_ADT(kop).name;
        ind = strfind(name,['4_' num2str(yrb)]);
        if isempty(ind)==0
            if datenum(name(ind+2:ind+9),'yyyymmdd')<datebeg
                IND = [IND kop];
            end
        end
        ind = strfind(name,['4_' num2str(yre)]);
        if isempty(ind)==0
            if datenum(name(ind+2:ind+9),'yyyymmdd')>dateend
                IND = [IND kop];
            end
        end
    end
    list_ADT(IND) = [];
    list_ADT1 = [];
    %clear list_ADT1
    for pok=1:length(list_ADT) %5800
        name =  list_ADT(pok).name;
        list_ADT1(pok,:) = [input_dir '/' name]; % not calling proper directory
    end
    list_ADT1 = char(list_ADT1);
    %% Loop through all days in a year
    [M,N] = size(list_ADT1);
    for j = 1:M %5800
        tic
        filename_ADT = list_ADT1(j,:);
        Longitudes=double(ncread(filename_ADT,'longitude'));
        Latitudes=double(ncread(filename_ADT,'latitude'));
        U=double(ncread(filename_ADT,'ugos'));
        V=double(ncread(filename_ADT,'vgos'));
        WL = 40;
        EL = 80;
        if WL<0; WL=WL+360; end
        if EL<0; EL=EL+360; end
        if WL==EL; WL=0; EL=360;end
        if WL<EL
            indlon = find(Longitudes>=WL & Longitudes<=EL);
            indlat = find(Latitudes>=SL & Latitudes<=NL);
            X = Longitudes(indlon);
            Y = Latitudes(indlat);
        else
            indlon = [find(Longitudes>=WL);find(Longitudes<=EL)];
            indlat = find(Latitudes>=SL & Latitudes<=NL);
            X = Longitudes(indlon);
            Y = Latitudes(indlat);
            X(X>180) = X(X>180)-360;
        end
        U = U(indlon,indlat);
        V = V(indlon,indlat);
        EKE{i,j}=(U.^2+V.^2)./2;
        disp(["Finished " + int2str(i) + " " + int2str(j)])
        toc
    end
end
disp(["Finished Processing"])
save("EKEs.mat", 'EKE', 'names4later', 'X', 'Y', '-v7.3')
%% Sort Data by Monsoon
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

%% Average over Monsoons
addemup = 0;
for i = 1:sumcount
    currdata = SumFinal{sumcount,1};
    addemup = currdata + addemup;
end
SumFinalAvg = addemup./sumcount;

addemup = 0;
for i = 1:wincount
    currdata = WinFinal{wincount,1};
    addemup = currdata + addemup;
end
winFinalAvg = addemup./wincount;

addemup = 0;
for i = 1:marcount
    currdata = MarFinal{marcount,1};
    addemup = currdata + addemup;
end
marFinalAvg = addemup./marcount;

addemup = 0;
for i = 1:octcount
    currdata = OctFinal{octcount,1};
    addemup = currdata + addemup;
end
octFinalAvg = addemup./octcount;

%% Make Figure
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end

figure('Position',[1 1 1065 1600])
ha=tight_subplot(2,2,[.01,.076],.066,.066);

% SUMMER
axes(ha(3))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,SumFinalAvg)
shading flat
m_coast('patch',[.7 .7 .7]);
m_grid('box', 'fancy','fontsize',20);
m_text(44,22,"(c) Summer",'Color','w','fontsize',26);
hold on
set(gca,'fontsize',20);
caxis([0 .5]);
colormap jet;
annotation(gcf,'ellipse',...
    [0.188732394366197 0.272946859903381 0.0469483568075114 0.036231884057971],...
    'LineWidth',4, 'Color', 'w');
annotation(gcf,'arrow',[0.133333333333333 0.183098591549296],...
    [0.214170692431562 0.286634460547504],'LineWidth',5, 'Color', 'w');
sc = m_text(48.3,-.5,"Somali Current", 'Color', 'w', 'fontsize', 14);
set(sc,'Rotation',60);
m_text(53.3,9.6,'GW','Color','w', 'fontsize', 18)
set(gcf,'PaperPositionMode','auto');

% WINTER
axes(ha(1))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,winFinalAvg)
shading flat
m_coast('patch',[.7 .7 .7]);
m_grid('box', 'fancy','fontsize',20);
hold on
h=colorbar('southoutside');
set(h, 'Position', [0.0657276995305164 0.037037037037037 0.867605633802817 0.0152979066022545]);
m_text(44,22,"(a) Winter",'Color','w','fontsize',26);
annotation(gcf,'ellipse',...
    [0.351173708920186 0.690821256038647 0.062910798122066 0.0563607085346216],...
    'LineWidth',4, 'Color', 'w');
m_text(70.5,8.5,"LH",'Color','w', 'fontsize', 18);
set(gca,'fontsize',20);
caxis([0 .5]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

% MARCH
axes(ha(2))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,marFinalAvg)
shading flat
m_coast('patch',[.7 .7 .7]);
m_grid('box', 'fancy','fontsize',20);
hold on
m_text(44,22,"(b) March",'Color','w','fontsize',26);
annotation(gcf,'arrow',[0.855399061032862 0.681690140845069],...
    [0.725442834138486 0.711755233494364],'LineWidth',5, 'Color', 'w');
tt = m_text(58.4, 6.7, "Rossby Wave", 'Color', 'w', 'fontsize',14);
set(tt,'Rotation',5);
set(gca,'fontsize',20);
caxis([0 .5]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

% OCTOBER
axes(ha(4))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,octFinalAvg)
shading flat
m_coast('patch',[.7 .7 .7]);
m_grid('box', 'fancy','fontsize',20);
hold on
m_text(44,22,"(d) October",'Color','w','fontsize',26);
set(gca,'fontsize',20);
colormap jet;
caxis([0 .5]);
set(gcf,'PaperPositionMode','auto');

filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename); %saves to local directory as PNG