%% Paul_LH_ADT_EKE_Figure1.m (version 1.2)
% This is a script that takes these two and stitches them together, side by side:
%----------------------------------------------------------------------------
% Paul_SC_EKE_Schematic.m (version 1.0)
%Author: Paul Ernst
%Date Created: 6/8/2021
%Purpose: Creates a seasonal schematic for EKE during 1993-2019.
%Inputs: CMEMS altimetry data from this time period. (ADT, VGOS, UGOS)
%Outputs: One schematic of EKE averaged per season in this time.
% +
% Paul_MonsoonADTSchematic.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/22/2021
%Purpose: Creates daily-stepped movie of geostrophic currents and ADTs from
%1993 to 2019 in the region between 15 S and 30 N; 40 E to 80 E.
%Inputs: CMEMS altimetry data from this time period. (ADT, VGOS, UGOS)
%Outputs: Many individual daily figures; one full movie.
%Date Created: 6/11/2021
%Date of Last Update: 7/14/2021
%----------------------------------------------------------------------------
%Update History:
%PE 7/30/2021 - Added comments, removed SES, SEF, and LHW annotations
%PE 7/14/2021 - Added SES, SEF, and LHW annotations to plots.
%PE 6/11/2021 - Created.
%Note: ADTs.mat and EKEs.mat are both required, produced by those Schematic
%files above. Run both of those ones first.
%% Inputs: ADT
tic
titlestring = "Ernst-ADTEKESchematic-Figure1.tiff";
pathtodata = '/Volumes/Lacie-SAN/SAN2/CMEMS/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/';
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
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
%loops like this are just so I can close the code when looking at overall
%organization, no functional purpose
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
%Loop thru all years
for i = 1:27
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        %If it's in the right month, grab it
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
%Summer
addemup = 0;
for i = 1:sumcount
    currdata = SumFinal{sumcount,1};
    addemup = currdata + addemup;
end
SumFinalAvgADT = addemup./sumcount;

%Winter
addemup = 0;
for i = 1:wincount
    currdata = WinFinal{wincount,1};
    addemup = currdata + addemup;
end
winFinalAvgADT = addemup./wincount;

%March
addemup = 0;
for i = 1:marcount
    currdata = MarFinal{marcount,1};
    addemup = currdata + addemup;
end
marFinalAvgADT = addemup./marcount;

%October
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
%Loop thru all years
for i = 1:27
    if (mod(i,4) == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        %If it's in the right month, grab it
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

%Winter
addemup = 0;
for i = 1:wincount
    currdata = WinFinal{wincount,1};
    addemup = currdata + addemup;
end
winFinalAvgEKE = addemup./wincount;

%March
addemup = 0;
for i = 1:marcount
    currdata = MarFinal{marcount,1};
    addemup = currdata + addemup;
end
marFinalAvgEKE = addemup./marcount;

%October
addemup = 0;
for i = 1:octcount
    currdata = OctFinal{octcount,1};
    addemup = currdata + addemup;
end
octFinalAvgEKE = addemup./octcount;
end

%% Make Figure: ADT Side
%Construct grid
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end

%Construct figure using tight_subplot because I didn't have TiledLayout at
%this point (MATLAB 2018a), if I had TiledLayout I would've used it here
%I mean jesus, look at this shit, it's like 200 lines long
%That's rough buddy
figure('units', 'normalized', 'outerposition', [0 0 1 1])
set(gcf,'color','w');
%Line below is for a more compact version of the figure instead having to
%manually splice it together like a bloody caveman in preview or some bull
%But tight subplot is a wet noodle so eh?
%figure('Position',[1 1 765 1600])
ha=tight_subplot(4,2,[0,0],.076,.016);

%--------------------------------------
% WINTER - LH and LHW Annotated
%--------------------------------------
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
%Annotations
set(h, 'Position', [0.1965625 0.0394524959742351 0.118880208333336 0.0112721417069244]);
m_text(44,22,"(a) Winter",'Color','w','fontsize',18);
%LH
annotation(gcf,'ellipse',...
    [0.2828125 0.792270531400966 0.0191406250000001 0.0370370370370374],...
    'LineWidth',3);
m_text(71.75,9.5,"LH",'Color','k', 'fontsize', 18);
%LHW
% annotation(gcf,'ellipse',...
%     [0.27109375 0.786634460547504 0.0120312500000002 0.0233494363929145],...
%     'LineWidth',3);
% m_text(65.75,6.75,"LHW",'Color','k', 'fontsize', 11);
set(gca,'fontsize',20);
caxis([40 110]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

%--------------------------------------
% MARCH - Rossby Waves Annotated
%--------------------------------------
axes(ha(3))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,marFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20, 'xticklabels', []);
hold on
set(gca,'xtick',[])
%Annotations
m_text(44,22,"(c) March",'Color','w','fontsize',18);
annotation(gcf,'arrow',[0.294140625 0.242578125],...
    [0.587761674718197 0.587761674718197],'LineWidth',5);
m_text(58.4, 5.4, "Rossby Waves", 'Color', 'k', 'fontsize',14);
set(gca,'fontsize',20);
caxis([40 110]);
colormap jet;
set(gcf,'PaperPositionMode','auto');

%--------------------------------------
% SUMMER - GW, SES, and SC Annotated
%--------------------------------------
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
%Annotations
%GW
annotation(gcf,'ellipse',...
    [0.238671875 0.372785829307568 0.0144531249999998 0.0289855072463757],...
    'LineWidth',3);
m_text(53.3,9.6,'GW','Color','w', 'fontsize', 14)
%SES
% annotation(gcf,'ellipse',...
%     [0.2546875 0.383929146537842 0.0116406250000001 0.0234782608695656],...
%     'LineWidth',3);
% m_text(59.2,11.1,'SES','Color','k', 'fontsize', 12)
%SC
annotation(gcf,'arrow',[0.226953125 0.237890625],...
    [0.347020933977456 0.383252818035427],'LineWidth',5);
sc = m_text(41.3,0,"Somali Current", 'Color', 'w', 'fontsize', 12);
set(sc,'Rotation',50);

set(gcf,'PaperPositionMode','auto');

%--------------------------------------
% OCTOBER - GW and SEF Annotated
%--------------------------------------
axes(ha(7))
m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
hold on
m_pcolor(Xgrid,Ygrid,octFinalAvgADT*100)
shading flat
m_coast('patch',[.5 .5 .5]);
m_grid('box', 'fancy','fontsize',20);
hold on
%Annotations
%GW
annotation(gcf,'ellipse',...
    [0.232421875 0.148953301127214 0.0144531249999998 0.0289855072463757],...
    'LineWidth',3);
m_text(50.7,7.1,'GW','Color','k', 'fontsize', 14)
%SEF
% annotation(gcf,'ellipse',...
%     [0.246875 0.172173913043478 0.011640625 0.0234782608695656],'LineWidth',3);
% m_text(56.3,11.1,'SEF','Color','k', 'fontsize', 12)
m_text(44,22,"(g) October",'Color','w','fontsize',18);
set(gca,'fontsize',20);
colormap jet;
caxis([40 110]);
set(gcf,'PaperPositionMode','auto');
%**************************************************
% Make Figure: EKE Side**************************************************
%**************************************************
%--------------------------------------
% WINTER
%--------------------------------------
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
%Annotations
m_text(44,22,"(b) Winter",'Color','w','fontsize',18);
% This commented out code copies the LH annotation to this panel if desired
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

%--------------------------------------
% MARCH
%--------------------------------------
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
%Annotations
% Copies Rossby Wave annotation if desired
% annotation(gcf,'arrow',[0.777734375 0.725],...
%     [0.597423510466989 0.597423510466989],'Color',[1 1 1],'LineWidth',5);
% m_text(58.4, 6.7, "Rossby Waves", 'Color', 'w', 'fontsize',14);
set(gca,'fontsize',20);
caxis([0 5000]);
colormap jet;

%--------------------------------------
% SUMMER
%--------------------------------------
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
%Annotations
% Copies Somali Current and GW if desired
% annotation(gcf,'ellipse',...
%     [0.723046875000001 0.372785829307568 0.0144531249999998 0.0289855072463757],...
%     'Color',[1 1 1],...
%     'LineWidth',4);
% annotation(gcf,'arrow',[0.712109375 0.721875],...
%     [0.347020933977456 0.383252818035427],'Color',[1 1 1],'LineWidth',5);
% sc = m_text(41.3,0,"Somali Current", 'Color', 'w', 'fontsize', 12);
% set(sc,'Rotation',50);
% m_text(53.3,9.6,'GW','Color','w', 'fontsize', 14)

%--------------------------------------
% OCTOBER
%--------------------------------------
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
%No Annotations here

%% Save Figure
%Using Export_Fig for max resolution (magnified, AA'd)
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory
toc
