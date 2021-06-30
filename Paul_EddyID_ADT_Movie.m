%% Paul_EddyID_ADT_Movie.m (version 1.1)
%Author: Paul Ernst
%Date Created: 6/15/2021
%Date of Last Update: 6/16/2021
%What was last update?
%Generalized variables. Added many comments.
%--------------------------------------
%Purpose: To ID graphically which eddies from the Pegliasco Eddy Tracking
%Algorithm are overlaid over which ADT data
%Inputs: ADT matrix for the area, found in ADTs.mat; filtered trajectories
%matrices for eddies you want to track.
%Outputs: Many individual daily figures; one full movie.
%--------------------------------------
%% Inputs; rhere are a few sticky plot settings in the Make Movie section; take note of that (they're marked with comments)
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
titlestring = 'FinalIDTOTALCropped.mp4'; %what are we naming our final movie?
output_dir= strcat(basepath, 'MOVIE/INDIVIDUAL_FILES/FINALID/TOTAL/'); %this is our output directory, you should make this yourself
addpath(strcat(basepath, 'm_map/private')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
years = ["1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"...
    "2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019"]; %what years are you looking at?
load('ADTs.mat') %where is the ADT.mat file located? Alternatively, comment out and make the ADT.mat file below
load('CE_Filtered_Trajectories.mat') %load CE trajectories
load('AE_Filtered_Trajectories.mat') %load AE trajectories
latlonbounds = [30, -15, 80, 40]; % [N, S, E, W] lat long boundaries that you're using here
NL = latlonbounds(1); %grabbing the limits discretely in their own variables
SL = latlonbounds(2);
WL = latlonbounds(4);
EL = latlonbounds(3);

%% UNCOMMENT THIS LOOP IF YOU DON'T ALREADY HAVE ADTs.mat IN YOUR FILE SYSTEM
%pathtodata = '/Volumes/Lacie-SAN/SAN2/CMEMS/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/'; %where is your CMEMS data?
%
% for i = 1:length(years)
%     input_str = (pathtodata + years(i) + '/');
%     input_dir = convertStringsToChars(input_str);
%     %% Construct name matrix
%     count = 0;
%     list_ADT = [];
%     list_ADT = [list_ADT;dir([input_dir '/*.nc'])]; % make sure this directory exists
%     %get date in proper format
%     for qq = 1:length(list_ADT)
%         dates4later(i,qq) = list_ADT(qq).name;
%         dates4later(i,qq) = extractAfter(dates4later(i,qq),22);
%         dates4later(i,qq) = extractBefore(dates4later(i,qq),9);
%         names4later(i,qq) = dates4later(i,qq);
%     end
%     IND=[]; %Index
%     for kop=1:length(list_ADT)
%         name = list_ADT(kop).name;
%         ind = strfind(name,['4_' num2str(yrb)]);
%         if isempty(ind)==0
%             if datenum(name(ind+2:ind+9),'yyyymmdd')<datebeg
%                 IND = [IND kop];
%             end
%         end
%         ind = strfind(name,['4_' num2str(yre)]);
%         if isempty(ind)==0
%             if datenum(name(ind+2:ind+9),'yyyymmdd')>dateend
%                 IND = [IND kop];
%             end
%         end
%     end
%     list_ADT(IND) = [];
%     list_ADT1 = [];
%     %clear list_ADT1
%     for pok=1:length(list_ADT) %5800
%         name =  list_ADT(pok).name;
%         list_ADT1(pok,:) = [input_dir '/' name]; % not calling proper directory
%     end
%     list_ADT1 = char(list_ADT1);
%     %% Loop through all days in a year
%     [M,N] = size(list_ADT1);
%     for j = 1:M %5800
%         tic
%         filename_ADT = list_ADT1(j,:);
%         Longitudes=double(ncread(filename_ADT,'longitude'));
%         Latitudes=double(ncread(filename_ADT,'latitude'));
%         ADT=double(ncread(filename_ADT,'adt'));
%         if WL<0; WL=WL+360; end
%         if EL<0; EL=EL+360; end
%         if WL==EL; WL=0; EL=360;end
%         if WL<EL
%             indlon = find(Longitudes>=WL & Longitudes<=EL);
%             indlat = find(Latitudes>=SL & Latitudes<=NL);
%             X = Longitudes(indlon);
%             Y = Latitudes(indlat);
%         else
%             indlon = [find(Longitudes>=WL);find(Longitudes<=EL)];
%             indlat = find(Latitudes>=SL & Latitudes<=NL);
%             X = Longitudes(indlon);
%             Y = Latitudes(indlat);
%             X(X>180) = X(X>180)-360;
%         end
%         % Reduce ADT to area of interest
%         ADTFinal{i,j} = ADT(indlon,indlat);
%         disp(["Finished " + int2str(i) + " " + int2str(j)])
%         toc
%     end
% end
% disp(["Finished Processing"])
% save("ADTs.mat", 'ADTFinal', 'X', 'Y', 'names4later', '-v7.3')

%% Filter for all eddies in the AS
%For CE or AE, simply ctrl+f and replace all AE with CE or vice versa
%Not advised to plot both, gets too hectic with too many numbers
%But you do you, future friend
tic
%grab sublists of x, y, etc
idlist = cell(length(AE_traj),1);
x_a=AE_traj(:,2);
y_a=AE_traj(:,3);
%loop through every identified eddy
for i = 1:length(AE_traj)
    x_1=x_a{i,1};
    y_1=y_a{i,1};
    % is in our spatial domain at any time in its life?
    for j = 1:length(x_1)
        if ((x_1(j) > latlonbounds(4)) && (x_1(j) < latlonbounds(3)) && (y_1(j) > latlonbounds(2)) && (y_1(j) < latlonbounds(1)))
            %grab id of this guy!
            workid = AE_traj(:,1);
            idlist{i,1} = workid{i,1};
            break
        end
    end
end
toc

%remove empty cells real quick
idlist = idlist(~cellfun('isempty',idlist(:,1)),:);

%% Get dates of all Eddies: just need 4 datapoints per eddy across time:
%1: ID of Eddy
%2: Lon of occurrance (2)
%3: Lat of occurrance (3)
%4: Date of occurrance (14)
tic
Edd = cell(4,length(idlist));
x_a=AE_traj(:,2); y_a=AE_traj(:,3); date_a=AE_traj(:,14);
%loop through all ID'd eddies
for i = 1:length(idlist)
    working = idlist{i,1};
    %extract components
    x = x_a{working,1};
    y = y_a{working,1};
    date=date_a{working,1};
    date2=datestr(date);
    [datelen, ~] = size(date2);
    clear date3
    %this is a loop to get things in our preferred datetime format:
    %yyyymmdd, which will also be our filenames, which will also be how we
    %plot everything
    for k = 1:datelen
        date3(k) = convertCharsToStrings(date2(k,:));
        day = extractBefore(date3(k),3);
        year = extractAfter(date3(k),7);
        month = extractBetween(date3(k),4,6);
        [~,month] = monthconversion(month);
        date3(k) = year + month + day;
    end
    %put all the final things in their appropriate place here
    Edd{1,i} = [idlist{i}];
    Edd{2,i} = [x];
    Edd{3,i} = [y];
    Edd{4,i} = [date3];
end
toc

%% Make Movie: everything
%Start by making the grid from the ADT mat file X/Y data
Xgrid = zeros(length(X),length(Y));
Ygrid = zeros(length(X),length(Y));
for p = 1:length(Y)
    Xgrid(:,p) = X(:,1);
end
for p = 1:length(X)
    Ygrid(p,:) = Y(:,1);
end

%loop through all years
%NOTE: This should be parallel-compliant! If you have the parallel
%computing toolbox, you can very much make this a parfor- loop just by
%adding "par" before the for. It should run much faster that way.
%That said, parfor will screw up your resolution. Your call.
for i = 1:length(years)
    %is this a leap year? if so, we need to know
    if (mod(i,4) == 0)
        leap = 366;
    else
        leap = 365;
    end
    %loop through all days in this year
    for j = 1:leap
        tic
        figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off'); %fullscreen, invisible figure
        m_proj('mercator','longitude',[WL EL],'latitude',[SL NL]) %initialize map
        m_pcolor(Xgrid,Ygrid,ADTFinal{i,j}.*100) %ADT color plot in cm
        shading flat
        hold on
        m_coast('patch',[.7 .7 .7]);
        m_grid('box', 'fancy','fontsize',28);
        hold on
        %Find us eddies!
        for pls = 1:length(idlist)
            if ismember(names4later(i,j), Edd{4,pls})
                for n = 1:length(Edd{4,pls})
                    if (names4later(i,j) == Edd{4,pls}(n))
                        indexmat = n;
                        break;
                    end
                end
                %plot a text annotation to the right of the eddy center if
                %it's on the correct date
                m_text(Edd{2,pls}(indexmat),Edd{3,pls}(indexmat),int2str(Edd{1,pls}), 'color', 'k', 'fontsize', 12)
            end
        end
        
        %this is a section dedicated to the date marking in the top right
        %corner of the plot
        nn = insertAfter(names4later(i,j),4,' ');
        [q1] = split(nn);
        q2 = q1(1);
        q1(1) = q1(2);
        q1(2) = q2;
        nn = join(q1,'/');
        nn = insertAfter(nn,2,'/');
        
        %NOTE NOTE NOTE NOTE NOTE NOTE: 70, 28 is the (lon, lat) that this
        %date annotation will be, and this WILL vary on your geographic
        %area. There is no way to detect easily where is the best place for
        %this label-- please adjust it to where you need it manually!
        m_text(70,28,nn,'color','w','fontsize',36);
        set(gca,'fontsize',32);
        colorbar('peer',gca,'Position',...
            [0.718708851958813 0.110305958132045 0.00624999999999998 0.814814814814815]); colormap jet;
        %I don't know how this colorbar position varies with screen resolution. You
        %may need to fiddle with this.
        ylabel('Latitude');
        xlabel('Longitude');
        title('IDs and ADT overlaid; Eddy center at left side of ID, ', 'fontsize', 28);
        caxis([40 110]);
        %This color axis is generally pretty good for ADT. But, you can
        %certainly figure out if you have a better one.
        colormap jet;
        set(gcf,'PaperPositionMode','auto');
        %save the figure to a filename in the output directory
        disp(['Frame:' ' ' int2str(i) ' ' int2str(j)]);
        filenamestring = ([output_dir + names4later(i,j) + '.png']);
        filename = char(filenamestring);
        %we use export_fig because it automatically crops and is nice
        export_fig(filename);
        %we have to delete the figure or else memory go kaboom because
        %MATLAB is a fun and engaging memory management simulator
        delete(gcf)
        toc
    end
end

%% Make Movie
filedir=dir(output_dir);
addpath(output_dir);
video=VideoWriter(titlestring,'MPEG-4'); %create the video object, using mp4 by default
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


%% This works to translate the string of a month into its numberstring.
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