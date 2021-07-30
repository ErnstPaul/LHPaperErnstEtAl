%% Paul_FFT_LH_Figure.m (version 1.whoknows)
%Author: Paul Ernst
%Date Created: 7/21/2021
%Date of Last Update: 7/21/2021
%Update History:
%PE 7/28/2021 - Pulled my hair out
%PE 7/21/2021 - Created
%--------------------------------------
%Purpose: Puts together a tri-panel-plot of FFT'd Rossby Waves
%Inputs: SLA, Average Eddy Tracks
%Outputs: One figure, 3 columns, 1 row (Full/Half/Local)
%--------------------------------------
tic
titlestring = "Ernst-FFTEx-FigureX.tiff";
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/export_figs/')
load("whiteorangecmap.mat")
addpath(strcat(basepath, 'FUNCTIONS'));
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"];
%for full years
% halfyearsN = [2, 7, 11, 19, 21, 27];
% localyearsN = [5, 6, 12, 18];
% fullyearsN = [1, 3, 4, 8, 9, 10, 13, 14, 15, 16, 17, 20,...
%     22, 23, 24, 25, 26];
%for individual years
halfyearsN = [2];
localyearsN = [6];
fullyearsN = [14];
latlonbounds = [8.1 7.9 79.8 49.4];
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
load('SLAs.mat', 'SLAFinal', 'names4later', 'X', 'Y')

%% Process SLA Averages Across Space and Time
%finding bounds
NLp = nearestpoint(latlonbounds(1), Y);
SLp = nearestpoint(latlonbounds(2), Y);
ELp = nearestpoint(latlonbounds(3), X);
WLp = nearestpoint(latlonbounds(4), X);
Xp = X(WLp:ELp); Yp = Y(SLp:NLp);
SLAforFFT = cell(1,length(years));
%Average SLA across the appropriate bounds
for i = 1:length(years)
    if (i/4 == 0)
        leap = 366;
    else
        leap = 365;
    end
    for j = 1:leap
        SLAforFFT{1,i}(:,j) = nanmean(SLAFinal{i,j}(WLp:ELp,SLp:NLp),2).*100;
    end
end

%% Get the FFT spectrum of each individual wave, then sum into averages
energy = cell(1,length(years)); maxen = cell(1,length(years)); wn = cell(1,length(years));
freq = cell(1,length(years)); wl = cell(1,length(years)); period = cell(1,length(years));
speed = cell(1,length(years)); esd = cell(1,length(years));
for i = 1:length(years)
    
    % Plots the SPECTRUM of longitude/time data (flipped so westerly waves are on the left) in various forms
    data_grid = gradient(transpose(SLAforFFT{1,i}));
    data_grid(isnan(data_grid)) = 0;
    
    % computes the 2D-FFT and the Energy Spectral Density
    fftransform = fft2(data_grid);
    preflipesd = (abs(fftransform)).^2 ;
    
    % shift origin to the center and arrange so westerly waves are on the left
    esd{1,i} = fliplr(fftshift(preflipesd));
    [Ny,Nx] = size(fftransform);
    
    % computes the values for the fft axes
    fx=(0:Nx-1)/Nx; %create array: 0 to X, and normalize by max(X)
    fx=fx-floor(Nx/2)/Nx; %subtract half of normalized X dimension from previous array (centering at 0)
    fx=-1.*fliplr(fx); %flip and make negative  (-.5 --> .5)
    fy=(0:Ny-1)/Ny; %repeat with y the same thing we did to x
    fy=(fy-floor(Ny/2)/Ny); %''
    energy{1,i} = 4*esd{1,i}/((Nx*Ny)^2); %grab energy spectra
    
    %Calculate statistics for this wave
    [maxen{1,i}, index] = max(energy{1,i}, [], 'all', 'linear'); %max energy
    [indexy, indexx] = ind2sub(size(energy{1,i}),index); %index of max energy
    wn{1,i} = abs(1/(fy(indexy)-180)); %remember fy is days
    freq{1,i} = abs(fx(indexx)); %remember fx is lon
    wl{1,i} = 1/wn{1,i}*111;
    period{1,i} = 1/freq{1,i};
    speed{1,i} = wl{1,i}/period{1,i} * cosd(mean(Yp));
end

%% Average into year bins, see functions
esdTotal = cell(1,3);
esdTotal{1,1} = esd{1,14};
esdTotal{1,2} = esd{1,2};
esdTotal{1,3} = esd{1,6};
energyTotal = cell(1,3);
energyTotal{1,1} = energy{1,14};
energyTotal{1,2} = energy{1,2};
energyTotal{1,3} = energy{1,6};
% esdTotal = averagerFull(esd, years, fullyearsN, halfyearsN, localyearsN);
% energyTotal = averagerFull(energy, years, fullyearsN, halfyearsN, localyearsN);
% tmaxenTotal = averagerSmall(maxen, years, fullyearsN, halfyearsN, localyearsN);
% twnTotal = averagerSmall(wn, years, fullyearsN, halfyearsN, localyearsN);
% twlTotal = averagerSmall(wl, years, fullyearsN, halfyearsN, localyearsN);
% tfreqTotal = averagerSmall(freq, years, fullyearsN, halfyearsN, localyearsN);
% tperiodTotal = averagerSmall(period, years, fullyearsN, halfyearsN, localyearsN);
% tspeedTotal = averagerSmall(speed, years, fullyearsN, halfyearsN, localyearsN);
%% Make the figure
figure('units', 'normalized', 'outerposition', [0 0 1 1])
t = tiledlayout(1,3,'TileSpacing','tight');
anno = cell(1,3); anno{1,1} = "(a) 2006"; anno{1,2} = "(b) 1994"; anno{1,3} = "(c) 1998";
%anno = cell(1,3); anno{1,1} = "(a)"; anno{1,2} = "(b)"; anno{1,3} = "(c)";
%Lay out the tiles and plotge
for nTiles = 1:3
    t = nexttile;
    h = contourf(fx,fy,esdTotal{1,nTiles}./(Nx*Ny), 5); % log(esdTotal{1,nTiles}./(Nx*Ny)) log([10 100 1000 10000]) 
    %pcolor(fx,fy,esdTotal{1,nTiles});
    hold on
    %plot([0 0], [-100 100], '--b', 'LineWidth', 2) %*16, *365
    c=colormap(gray(10));colormap(flipud(c));
    %colormap(jet)
    set(gcf,'PaperPositionMode','auto');
    xlabel('Meridional Wavenumber (1/degree)');
    if nTiles == 1
        ylabel('Frequency (1/day)')
    end
    ymin = 0; ymax = .02; %75  
    xmin = -.1; xmax = 0; %1.75
    ylim([ymin ymax])
    xlim([xmin xmax])
    set(gca,'FontSize',24);
    %caxis([0 .002]); %log([0 10000])
    text('Parent',gca,'FontSize',40,'String',anno{1,nTiles},...
        'Position',[(xmin-xmin/15) (ymax-ymax/25)],'Color', 'k');
end
colorbar(gca,'Position',...
    [0.9640625 0.185990338164251 0.012109375 0.638486312399356]);


% Save Figure
filenamestring = (titlestring);
filename = char(filenamestring);
export_fig(filename,'-m1.5','-a4','-opengl'); %saves to local directory as PNG
toc

%% Experimental
% % FIGURE 14: PLOT
% % Plot types
% % ENERGY SPECTRAL DENSITY - TWO-SIDED
% % h= pcolor(fx,fy,esd*1/24); %1/24 = hourly
% % ENERGY ASSOCIATED to each COMPONENT - TWO-SIDED
% % as defined in the Energy theorem
% % h = pcolor(fx,fy,esd/(Nx*Ny));
% % SPECTRUM IN VARIANCE PRESERVING FORM (= the squared amplitude of each
% % component) - in this case it is one-sided, use 'axis' properly...
% % h= pcolor(fx,fy,4*esd/((Nx*Ny)^2));
% ccc=[0 1e6];
% 
% % one lon
% %xll=([-.2 .2]);%Plot X limit
% xll=([-10 10]);% (48*48)
% yll=([0 2]);%Plot Y limit
% time=1/24; %terms of days (1hr = 1/24day)
% fig1=figure;set(fig1,'position',[1 1 1600 1200]);clf
% ha=tight_subplot(3,1,[.06 .04],[.06 .04],[.05 .09]);
% 
% data_gridA(isnan(data_gridA))=0;
% fftransform = fft2(data_gridA);
% esd = (abs(fftransform)).^2 ;
% %esd=esd*((1e-6)^2);% microrad^2 to rad^2
% esd = fliplr(fftshift(esd));
% [Ny,Nx] = size(fftransform);
% fx=(0:Nx-1)/Nx;fx=fx-floor(Nx/2)/Nx;fx=-1.*fliplr(fx);
% fy=(0:Ny-1)/Ny;fy=(fy-floor(Ny/2)/Ny);
% fy=fy/time;% change fy so as to have 1/day instead of 1/cycle
% 
% axes(ha(1))
% %h=pcolor(fx*(48*48),fy,esd*(time));shading interp;hold on; %1/24 = hourly
% h=pcolor(fx*(48*48),fy,esd/(Nx*Ny));shading interp;hold on;% g='Energy (microradians^2)';
% set(gcf,'PaperPositionMode','auto');
% ylabel('Frequency (1/day)');%title('Spectrum L/T Data');
% set(gca,'fontsize',22);
% c=colormap(gray(10));colormap(flipud(c));ylim(yll); xlim(xll);
% text(-9.6,1.75,'(a) Box A','fontsize',35,'color','k')%N
% grid on;box on;ax=gca;ax.LineWidth=1;ax.Layer='top';
%  
% 
% % MERIDIONAL
% plot([-1.574 -1.574],[0 2],'Linewidth',2,'Color','k','Linestyle','--');
% c1=colorbar('vert');
% set(c1,'Position', [.912 .705 .012 .25],'fontsize',24)%,...
% %    'Limits',[0 2e-6],'Ticks',[0 .5e-6 1e-6 1.5e-6 2e-6],'TickLabels',{'0','.5','1','1.5','2'})
% %text(10.8,2.12,'x10^-^6','fontsize',24);
% %ylabel(c1,{'Energy Spectral Density';'(radians^2*days*degree)'},'fontsize',22);
% ylabel(c1,{'Energy Spectrum';'(microradians^2)'},'fontsize',22);
% xlabel('Meridional wavenumber (1/degree)');
% text(6,1.8,['13' char(176) 'N-15' char(176) 'N,  97 ' char(176) 'E'],'fontsize',24,'color','k')

%% Functions to condense code above
%For large (27 x 366) mats
function [avgmat] = averagerFull(inputmat, years, fulls, halfs, locals)
avgmat = cell(1,3);
for i = 1:3
    avgmat{1,i} = zeros(size(inputmat{1,1}));
end
for i = 1:365
    %spacewise avg
    for j = 1:length(years)
        %timewise avg
        if ismember(i, fulls)
            avgmat{1,1}(:,j) = avgmat{1,1}(:,j) + nanmean(inputmat{1,i}(:,j),2);
        elseif ismember(i, halfs)
            avgmat{1,2}(:,j) = avgmat{1,2}(:,j) + nanmean(inputmat{1,i}(:,j),2);
        elseif ismember(i, locals)
            avgmat{1,3}(:,j) = avgmat{1,3}(:,j) + nanmean(inputmat{1,i}(:,j),2);
        end
    end
    avgmat{1,1}(:,j) = avgmat{1,1}(:,j)./length(fulls);
    avgmat{1,2}(:,j) = avgmat{1,2}(:,j)./length(halfs);
    avgmat{1,3}(:,j) = avgmat{1,3}(:,j)./length(locals);
end
end

%For small (1 x 27) mats
function [avgmat] = averagerSmall(inputmat, years, fulls, halfs, locals)
avgmat = cell(1,3);
for i = 1:3
    avgmat{1,i} = 0;
end
for i = 1:length(years)
    if ismember(i, fulls)
        avgmat{1,1} = avgmat{1,1} + inputmat{1,i};
    elseif ismember(i, halfs)
        avgmat{1,2} = avgmat{1,2} + inputmat{1,i};
    elseif ismember(i, locals)
        avgmat{1,3} = avgmat{1,3} + inputmat{1,i};
    end
end
avgmat{1,1} = avgmat{1,1}./length(fulls);
avgmat{1,2} = avgmat{1,2}./length(halfs);
avgmat{1,3} = avgmat{1,3}./length(locals);
end


