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
% +
%% Paul_MonsoonADTSchematic.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/22/2021
%Date of Last Update: 5/22/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Creates daily-stepped movie of geostrophic currents and ADTs from
%1993 to 2019 in the region between 15 S and 30 N; 40 E to 80 E.
%Inputs: CMEMS altimetry data from this time period. (ADT, VGOS, UGOS)
%Outputs: Many individual daily figures; one full movie.
%--------------------------------------
%% This is a script that takes the two and stitches them together. Fun.
%% Inputs: ADT
titlestring = "Figure1_FullSchematic.png";
pathtodata = '/Volumes/Lacie-SAN/SAN2/CMEMS/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/';
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
addpath(strcat(basepath, 'FUNCTIONS'));
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
latlonbounds = [30, -10, 80, 40]; % [N, S, E, W] lat long boundaries
yearmetadata = [19930101, 20191231]; %[YYYYMMDD, YYYYMMDD] start and end dates of the data
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%% Process Data: ADT
for cute = 1:1
load("ADTs.mat")
load("EKEs.mat")
%Sort Data by Monsoon
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
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        month = extractBetween(names4later(i,j), 5, 6);
        if ismember(month, SumMon)
            sumcount = sumcount + 1;
            SumFinal(sumcount,1) = ADTFinal(i,j);
        elseif ismember(month, WinMon)
            wincount = wincount + 1;
            WinFinal(wincount,1) = ADTFinal(i,j);
        elseif ismember(month, Mar)
            marcount = marcount + 1;
            MarFinal(marcount,1) = ADTFinal(i,j);
        elseif ismember(month, Oct)
            octcount = octcount + 1;
            OctFinal(octcount,1) = ADTFinal(i,j);
        end
    end
end
%Average over Monsoons
addemup = 0;
for i = 1:sumcount
    currdata = SumFinal{sumcount,1};
    addemup = currdata + addemup;
end
SumFinalAvgADT = addemup./sumcount;

addemup = 0;
for i = 1:wincount
    currdata = WinFinal{wincount,1};
    addemup = currdata + addemup;
end
winFinalAvgADT = addemup./wincount;

addemup = 0;
for i = 1:marcount
    currdata = MarFinal{marcount,1};
    addemup = currdata + addemup;
end
marFinalAvgADT = addemup./marcount;

addemup = 0;
for i = 1:octcount
    currdata = OctFinal{octcount,1};
    addemup = currdata + addemup;
end
octFinalAvgADT = addemup./octcount;
end

%% Process Data: EKE
for adorable = 1:1
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

%Average over Monsoons
addemup = 0;
for i = 1:sumcount
    currdata = SumFinal{sumcount,1};
    addemup = currdata + addemup;
end
SumFinalAvgEKE = addemup./sumcount;

addemup = 0;
for i = 1:wincount
    currdata = WinFinal{wincount,1};
    addemup = currdata + addemup;
end
winFinalAvgEKE = addemup./wincount;

addemup = 0;
for i = 1:marcount
    currdata = MarFinal{marcount,1};
    addemup = currdata + addemup;
end
marFinalAvgEKE = addemup./marcount;

addemup = 0;
for i = 1:octcount
    currdata = OctFinal{octcount,1};
    addemup = currdata + addemup;
end
octFinalAvgEKE = addemup./octcount;
end

%% Make Figure: ADT Side
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end
figure('units', 'normalized', 'outerposition', [0 0 1 1])
set(gcf,'color','w');
%figure('Position',[1 1 765 1600])
ha=tight_subplot(4,2,[0,0],.076,.016);

% WINTER
axes(ha(1))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,winFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
hold on
set(gca,'xtick',[])
h=colorbar('southoutside');
set(h, 'Position', [0.1965625 0.0394524959742351 0.118880208333336 0.0112721417069244]);
m_text(44,22,"(a) Winter",'Color','w','fontsize',18);
annotation(gcf,'ellipse',...
    [0.2796875 0.785829307568438 0.0191406250000001 0.0370370370370372],...
    'LineWidth',4);
m_text(70.5,8.5,"LH",'Color','k', 'fontsize', 18);
set(gca,'fontsize',20);
caxis([40 110]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

% MARCH
axes(ha(3))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,marFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
hold on
set(gca,'xtick',[])
m_text(44,22,"(c) March",'Color','w','fontsize',18);
annotation(gcf,'arrow',[0.294140625 0.242578125],...
    [0.587761674718197 0.587761674718197],'LineWidth',5);
m_text(58.4, 5.4, "Rossby Wave", 'Color', 'k', 'fontsize',14);
set(gca,'fontsize',20);
caxis([40 110]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

% SUMMER
axes(ha(5))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,SumFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
m_text(44,22,"(e) Summer",'Color','w','fontsize',18);
hold on
set(gca,'fontsize',20);
caxis([40 110]);
colormap jet;
annotation(gcf,'ellipse',...
    [0.238671875 0.372785829307568 0.0144531249999998 0.0289855072463757],...
    'LineWidth',4);
annotation(gcf,'arrow',[0.226953125 0.237890625],...
    [0.347020933977456 0.383252818035427],'LineWidth',5);
sc = m_text(41.3,0,"Somali Current", 'Color', 'w', 'fontsize', 12);
set(sc,'Rotation',50);
m_text(53.3,9.6,'GW','Color','w', 'fontsize', 14)
set(gcf,'PaperPositionMode','auto');

% OCTOBER
axes(ha(7))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,octFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20);
hold on
m_text(44,22,"(g) October",'Color','w','fontsize',18);
set(gca,'fontsize',20);
colormap jet;
caxis([40 110]);
set(gcf,'PaperPositionMode','auto');
%**************************************************
% Make Figure: EKE Side**************************************************
%**************************************************
% WINTER
axes(ha(2))
ax = gca;
ax.YAxisLocation = 'right';
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,winFinalAvgEKE.*10000)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
hold on
h=colorbar('southoutside');
set(h, 'Position', [0.683593750000001 0.0394524959742351 0.118880208333336 0.0112721417069244]);
m_text(44,22,"(b) Winter",'Color','w','fontsize',18);
% annotation(gcf,'ellipse',...
%     [0.762890625 0.785829307568438 0.0191406250000001 0.0370370370370372],...
%     'Color',[1 1 1],...
%     'LineWidth',4);
% m_text(70.5,8.5,"LH",'Color','w', 'fontsize', 18);
ax = gca;
set(gca,'xtick',[])
ax.YAxisLocation = 'right';
set(gca,'fontsize',20);
caxis([0 5000]);
colormap jet;

% MARCH
axes(ha(4))
ax = gca;
ax.YAxisLocation = 'right';
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,marFinalAvgEKE.*10000)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
hold on
m_text(44,22,"(d) March",'Color','w','fontsize',18);
% annotation(gcf,'arrow',[0.777734375 0.725],...
%     [0.597423510466989 0.597423510466989],'Color',[1 1 1],'LineWidth',5);
% m_text(58.4, 6.7, "Rossby Wave", 'Color', 'w', 'fontsize',14);
set(gca,'fontsize',20);
caxis([0 5000]);
colormap jet;

% SUMMER
axes(ha(6))
ax = gca;
ax.YAxisLocation = 'right';
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,SumFinalAvgEKE.*10000)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
m_text(44,22,"(f) Summer",'Color','w','fontsize',18);
hold on
set(gca,'fontsize',20);
caxis([0 5000]);
colormap jet;
% annotation(gcf,'ellipse',...
%     [0.723046875000001 0.372785829307568 0.0144531249999998 0.0289855072463757],...
%     'Color',[1 1 1],...
%     'LineWidth',4);
% annotation(gcf,'arrow',[0.712109375 0.721875],...
%     [0.347020933977456 0.383252818035427],'Color',[1 1 1],'LineWidth',5);
% sc = m_text(41.3,0,"Somali Current", 'Color', 'w', 'fontsize', 12);
% set(sc,'Rotation',50);
% m_text(53.3,9.6,'GW','Color','w', 'fontsize', 14)

% OCTOBER
axes(ha(8))
ax = gca;
ax.YAxisLocation = 'right';
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,octFinalAvgEKE.*10000)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20);
hold on
m_text(44,22,"(h) October",'Color','w','fontsize',18);
set(gca,'fontsize',20);
colormap jet;
caxis([0 5000]);

filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
