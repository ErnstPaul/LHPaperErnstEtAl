%% Paul_FLH_Windstresses_Movie.m (version 1.0)
%Author: Paul Ernst
%Date Created: 6/29/2021
%Date of Last Update: 6/29/2021
%Update History:
%PE 6/29/2021 - Created
%--------------------------------------
%Purpose: Puts together a full movie of wind stresses for the AS over 1993
%         through 2019
%Inputs: Full UV wind files from https://www.ncdc.noaa.gov/data-access/marineocean-data/blended-global/blended-sea-winds
%Outputs: "A few" individual figures, one long movie
%--------------------------------------
pathtodata = '/Volumes/Lacie-SAN/SAN2/NOAA_Blended_Winds/NCfiles/';
titlestring1 = 'StressesIDs.mp4'; %what are we naming our final movie?
titlestring2 = 'StressCurlsIDs.mp4'; %what are we naming our final movie?
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/';
output_dir1= strcat(basepath, 'MOVIE/INDIVIDUAL_FILES/WINDSTRESS/');
output_dir2= strcat(basepath, 'MOVIE/INDIVIDUAL_FILES/WINDSTRESSCURL/');
addpath(strcat(basepath, 'm_map/private')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017"];%,"2018","2019"];
firstyear = '1993'; %as a char
load('AE_Filtered_Trajectories.mat') %load AE trajectories
load('FinalEddyIDLists.mat') %load final eddy family trajectories
latlonbounds = [30, -15, 80, 40]; % [N, S, E, W] lat long boundaries of AS
NL = latlonbounds(1);
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);
%% Read data in for Wind Stresses
% filedir=dir(pathtodata);
% %grab the index of the date we actually start from here
% for nFiles = 4:length(filedir)
%     if (filedir(nFiles).name(3:6) == firstyear)
%         ind2start = nFiles;
%         break
%     end
% end
% % Grab from after first year starts
% lenTrue = length(filedir)-ind2start+1;
% Stress = cell(1,lenTrue);
% names4later(1) = convertCharsToStrings(filedir(ind2start).name(3:10));
% list = [pathtodata filedir(ind2start).name];
% Longitudes=double(ncread(list,'lon'));
% Latitudes=double(ncread(list,'lat'));
% %sort out lats/lons and get them into the format we want
% if WL<0; WL=WL+360; end
% if EL<0; EL=EL+360; end
% if WL==EL; WL=0; EL=360;end
% if WL<EL
%     indlon = find(Longitudes>=WL & Longitudes<=EL);
%     indlat = find(Latitudes>=SL & Latitudes<=NL);
%     X = Longitudes(indlon);
%     Y = Latitudes(indlat);
% else
%     indlon = [find(Longitudes>=WL);find(Longitudes<=EL)];
%     indlat = find(Latitudes>=SL & Latitudes<=NL);
%     X = Longitudes(indlon);
%     Y = Latitudes(indlat);
%     X(X>180) = X(X>180)-360;
% end
% %loop through all years
% for nFiles = ind2start:length(filedir)
%     tic
%     iTrue = nFiles-ind2start+1;
%     names4later(iTrue) = convertCharsToStrings(filedir(nFiles).name(3:10));
%     list = [pathtodata filedir(nFiles).name];
%     U=double(ncread(list,'u'));
%     V=double(ncread(list,'v'));
%     [StressX, StressY] = ra_windstr(U,V);
%     StressCurl{iTrue} = ra_windstrcurl(Y,X,transpose(U(indlon,indlat)),transpose(V(indlon,indlat)));
%     Stress{iTrue} = sqrt(StressX.^2+StressY.^2);
%     Stress{iTrue} = Stress{iTrue}(indlon,indlat);
%     disp([toc + " Seconds since last loop; Loop number: " + int2str(iTrue)]);
% end
% 
% save('WindStresses.mat', 'Stress', 'StressCurl', 'names4later', 'X', 'Y');

%% If we already calculated the above data
load('WindStresses.mat');
lenTrue = length(Stress);

%% Get dates of all Eddies: just need 4 datapoints per eddy across time:
%1: ID of Eddy (LHW (ID), LH (ID), GW (ID), SES (ID), SEF (ID))
%2: Lon of occurrance (2)
%3: Lat of occurrance (3)
%4: Date of occurrance (14)
% Edd = cell(5,4); %5 = eddy family; 4 = categories
% famType = cell(5,1);
% appendEddyName = ["LHW", "LH", "GW", "SES", "SEF"];
% famType{1} = LHWFinalFull; famType{2} = LHFinalFull; famType{3} = GWFinalFull;
% famType{4} = SESRootFamily; famType{5} = SEFRootFamily;
% x_a=AE_traj(:,2); y_a=AE_traj(:,3); date_a=AE_traj(:,14);
% %loop through all ID'd eddies
% for i = 1:5
%     clear idlist
%     idlist = [];
%     for nYears = 1:length(years)
%         idlist = [idlist famType{i}{nYears}];
%     end
%     workingX = cell(1,length(idlist));
%     workingY = cell(1,length(idlist));
%     workingDate = cell(1,length(idlist));
%     for j = 1:length(idlist)
%         workingID = idlist(1,j);
%         %extract components
%         x = x_a{workingID,1};
%         y = y_a{workingID,1};
%         date=date_a{workingID,1};
%         date2=datestr(date);
%         [datelen, ~] = size(date2);
%         clear date3
%         %this is a loop to get things in our preferred datetime format:
%         %yyyymmdd, which will also be our filenames, which will also be how we
%         %plot everything
%         for k = 1:datelen
%             date3(k) = convertCharsToStrings(date2(k,:));
%             day = extractBefore(date3(k),3);
%             year = extractAfter(date3(k),7);
%             month = extractBetween(date3(k),4,6);
%             [~,month] = monthconversion(month);
%             date3(k) = year + month + day;
%         end
%         %put all the final things in their appropriate place here
%         workingX{1,j} = x;
%         workingY{1,j} = y;
%         workingDate{1,j} = date3;
%     end
%     %And back into the master matrix
%     Edd{i,1} = idlist;
%     Edd{i,2} = workingX;
%     Edd{i,3} = workingY;
%     Edd{i,4} = workingDate;
% end
% 
% save('NotableEddiesPlotMovieData.mat', 'Edd', 'names4later', 'appendEddyName');

%% If we already calculated the above data
load('NotableEddiesPlotMovieData.mat');

%% Make individual figures
%NEED: X (Lons), Y (Lats), names4later (["19930102"]), Stresses (fitted to
%X/Y grid as seen below)
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end

%% WIND STRESS: MAKE FIGURES
w = waitbar(0,'Setting up the movie...');
waitbarstr = 'Calculating finishing time, give me 30 iterations...';
time = 0;
for i = 5191:lenTrue %Change to 1
    tic
    figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off'); %fullscreen
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    m_pcolor(Xgrid,Ygrid,Stress{i})
    shading flat
    hold on
    m_coast('patch',[.7 .7 .7]);
    m_grid('box', 'fancy','fontsize',28);
    hold on
    
    %Find us eddies!
    %Loop through all 5 eddy systems
    repeatList = [];
    for system = 1:5
        idlist = Edd{system,1};
        for pls = 1:length(idlist)
            if ~ismember(idlist(pls), repeatList)
                if ismember(names4later(i), Edd{system,4}{pls})
                    for n = 1:length(Edd{system,4}{pls})
                        if (names4later(i) == Edd{system,4}{pls}(n))
                            indexmat = n;
                            break;
                        end
                    end
                    %plot a text annotation to the right of the eddy center if
                    %it's on the correct date
                    m_text(Edd{system,2}{pls}(indexmat),Edd{system,3}{pls}(indexmat),...
                        (appendEddyName(system) + " " + int2str(idlist(pls))), 'color', 'k', 'fontsize', 12)
                end
            end
            repeatList = [repeatList idlist(pls)];
        end
    end
    
    nn = insertAfter(names4later(i),4,' ');
    [q1] = split(nn);
    q2 = q1(1);
    q1(1) = q1(2);
    q1(2) = q2;
    nn = join(q1,'/');
    nn = insertAfter(nn,2,'/');
    
    m_text(70,28,nn,'color','w','fontsize',36);
    set(gca,'fontsize',32);
    colorbar('peer',gca,'Position',...
        [0.718708851958813 0.110305958132045 0.00624999999999998 0.814814814814815]); colormap jet;
    ylabel('Latitude');
    xlabel('Longitude');
    title('Wind Stress (N/m^2), 1993-2019', 'fontsize', 28);
    caxis([0 .3]);
    colormap(redblue);
    set(gcf,'PaperPositionMode','auto');
    % save figure
    filenamestring = ([output_dir1 + names4later(i) + '.png']);
    filename = char(filenamestring);
    export_fig(filename);
    delete(gcf)
    %Handing waitbar
    if (i < 30)
        time = time + toc;
    end
    if (i == 31)
        endtimeadd = ((lenTrue)/30*time);
        endtime = addtodate(datenum(datetime('now')), endtimeadd, 'second');
        endstr = datestr(endtime, 'HH:MM PM');
        waitbarstr = ['Calculation done! I will be done at: ' endstr];
    end
    waitbar((i/(lenTrue)),w,waitbarstr);
    disp(['Frame:' ' ' int2str(i) ' of ' int2str(lenTrue)]);
    toc
end
close(w)

%% WIND STRESS CURL: MAKE FIGURES
w = waitbar(0,'Setting up the movie...');
waitbarstr = 'Calculating finishing time, give me 30 iterations...';
time = 0;
for i = 1:lenTrue
    tic
    figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off'); %fullscreen
    m_proj('mercator','longitude',[WL EL],'latitude',[SL NL])
    m_pcolor(Xgrid,Ygrid,transpose(StressCurl{i}))
    shading flat
    hold on
    m_coast('patch',[.7 .7 .7]);
    m_grid('box', 'fancy','fontsize',28);
    hold on
    
    %Find us eddies!
    %Loop through all 5 eddy systems
    repeatList = [];
    for system = 1:5
        idlist = Edd{system,1};
        for pls = 1:length(idlist)
            if ~ismember(idlist(pls), repeatList)
                if ismember(names4later(i), Edd{system,4}{pls})
                    for n = 1:length(Edd{system,4}{pls})
                        if (names4later(i) == Edd{system,4}{pls}(n))
                            indexmat = n;
                            break;
                        end
                    end
                    %plot a text annotation to the right of the eddy center if
                    %it's on the correct date
                    m_text(Edd{system,2}{pls}(indexmat),Edd{system,3}{pls}(indexmat),...
                        (appendEddyName(system) + " " + int2str(idlist(pls))), 'color', 'k', 'fontsize', 12)
                end
            end
            repeatList = [repeatList idlist(pls)];
        end
    end
    
    nn = insertAfter(names4later(i),4,' ');
    [q1] = split(nn);
    q2 = q1(1);
    q1(1) = q1(2);
    q1(2) = q2;
    nn = join(q1,'/');
    nn = insertAfter(nn,2,'/');
    
    m_text(70,28,nn,'color','w','fontsize',36);
    set(gca,'fontsize',32);
    colorbar('peer',gca,'Position',...
        [0.718708851958813 0.110305958132045 0.00624999999999998 0.814814814814815]); colormap jet;
    ylabel('Latitude');
    xlabel('Longitude');
    title('Wind Stress Curl (N/m^3), 1993-2019', 'fontsize', 28);
    caxis([-0.000002 0.000002]);
    colormap(redblue);
    set(gcf,'PaperPositionMode','auto');
    % save figure
    filenamestring = ([output_dir2 + names4later(i) + '.png']);
    filename = char(filenamestring);
    export_fig(filename);
    delete(gcf)
    %Handing waitbar
    if (i < 30)
        time = time + toc;
    end
    if (i == 31)
        endtimeadd = (lenTrue/30*time);
        endtime = addtodate(datenum(datetime('now')), endtimeadd, 'second');
        endstr = datestr(endtime, 'HH:MM PM');
        waitbarstr = ['Calculation done! I will be done at: ' endstr];
    end
    waitbar((i/lenTrue),w,waitbarstr);
    disp(['Frame:' ' ' int2str(i) ' of ' int2str(lenTrue)]);
    toc
end
close(w)

%% MAKE MOVIE: WIND STRESS
% Movie makin'
filedir=dir(output_dir1);
addpath(output_dir1);
video=VideoWriter(titlestring1,'MPEG-4'); %create the video object, using mp4 by default
video.FrameRate=30;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
for dday=3:length(filedir) %where N is the number of images; we use 3 because the only other thing in this directory
    %should be "." and ".." which are the present
    %and current directories. If you have other
    %random stuff in here, then just note that you
    %may need to change "3" to something else. Check
    %the "filedir" variable.
    disp(['processing video:' ' ' filedir(dday).name]);
    I=imread([filedir(dday).name]); %read the next image
    %this.... is an odd line. Let me explain:
    %I grabbed all eddies that EVER went into the region of interest. But,
    %sometimes, there are eddies from without that come in, or eddies from
    %within that go out. Those eddies are still annotated in the figure by
    %m_text. This cropping line means that, while you will still see those
    %names of eddies floating around the boundaries of the figure, you will
    %not have a movie with differently sized main images.
    %Here's the catch: this probably changes based on screen resolution
    %(untested), so you may need to run this section with this line
    %commented out, see what error resolution you get, and put that in
    %there instead of "1164 1234". Then, that should work.
    %Alternatively, just change the above code to prevent eddies not in the
    %area of interest from showing up at all. I prefer it this way; your
    %call when you run this yourself.
    J=imcrop(I,[0 0 1164 1234]);
    writeVideo(video,J);
end
close(video); %close the file
disp('finished');

% MAKE MOVIE: WIND STRESS CURL
% Movie makin'
filedir=dir(output_dir2);
addpath(output_dir2);
video=VideoWriter(titlestring2,'MPEG-4'); %create the video object, using mp4 by default
video.FrameRate=30;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
for dday=3:length(filedir) %where N is the number of images; we use 3 because the only other thing in this directory
    %should be "." and ".." which are the present
    %and current directories. If you have other
    %random stuff in here, then just note that you
    %may need to change "3" to something else. Check
    %the "filedir" variable.
    disp(['processing video:' ' ' filedir(dday).name]);
    I=imread([filedir(dday).name]); %read the next image
    %this.... is an odd line. Let me explain:
    %I grabbed all eddies that EVER went into the region of interest. But,
    %sometimes, there are eddies from without that come in, or eddies from
    %within that go out. Those eddies are still annotated in the figure by
    %m_text. This cropping line means that, while you will still see those
    %names of eddies floating around the boundaries of the figure, you will
    %not have a movie with differently sized main images.
    %Here's the catch: this probably changes based on screen resolution
    %(untested), so you may need to run this section with this line
    %commented out, see what error resolution you get, and put that in
    %there instead of "1164 1234". Then, that should work.
    %Alternatively, just change the above code to prevent eddies not in the
    %area of interest from showing up at all. I prefer it this way; your
    %call when you run this yourself.
    J=imcrop(I,[0 0 1164 1234]);
    writeVideo(video,J);
end
close(video); %close the file
disp('finished');

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