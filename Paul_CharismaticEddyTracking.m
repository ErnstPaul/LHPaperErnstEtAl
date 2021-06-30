%% Paul_CharismaticEddyTracking.m (version 2.1)
%Author: Paul Ernst
%Date Created: 5/19/2021
%Date of Last Update: 5/25/2021
%What was last update?
%Created full movie at the end of the script. Adjusted tracking algorithms.
%--------------------------------------
%Purpose: Filters for the trajectories that match the "Charismatic" eddies
%in the Arabian Sea: LH/LL (Lackshadweep High/Low), GW (Great Whirl), SE
%(Socotra Eddy), and SG (Southern Gyre).
%Inputs: Filtered Trajectories files produced by Step 6 of the Eddy
%Tracking code; By Year files produced by Chunk Eddies By Year code.
%Outputs: Movies for each eddy per year, as well as a total movie for all
%eddies over all years.
%% Read data in
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/EXTRACTION/EDDY_TRAJECTORIES')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
load('CE_Filtered_Trajectories.mat')
load('AE_Filtered_Trajectories.mat')
load('AEByYear.mat')
load('CEByYear.mat')
date_a=AE_traj(:,14);
date_c=CE_traj(:,14);
Charisma = cell(5,27);
%% Filter for GW
%Between 5 North and 11.72 North; 51.25 East to 56.70 East.
%Largest Radius positive eddy generated in this box between May and July
latlonbounds = [11.72 5 56.7 51.25]; %N S E W
monthbounds = ["May", "Jun", "Jul"]; %timewise filter
datearray = 1993:2019;
ASYLim = [latlonbounds(2) latlonbounds(1) latlonbounds(1) latlonbounds(2) latlonbounds(2)];
ASXLim = [latlonbounds(4) latlonbounds(4) latlonbounds(3) latlonbounds(3) latlonbounds(4)];
for j = 1:27
    workingmax = 0;
    yearlymax = 0;
    maxid = 0;
    WorkingAE = AElists{j,1};
    idlist = cell(length(WorkingAE),1);
    for i = 1:length(WorkingAE)
        date_a=WorkingAE(:,14);
        date=date_a{i,1};
        date2=datestr(date);
        date2str=date2(1,4:6);
        %is in our temporal domain
        if ismember(date2str,monthbounds)
            x_a=WorkingAE(:,2);
            x_1=x_a{i,1};
            y_a=WorkingAE(:,3);
            y_1=y_a{i,1};
            % is in our spatial domain
            if ((x_1(1) > latlonbounds(4)) && (x_1(1) < latlonbounds(3)) && (y_1(1) > latlonbounds(2)) && (y_1(1) < latlonbounds(1)))
                %grab full ancestry of this guy
                [~, idlist{i,1}] = ancestry(WorkingAE, AE_traj, i);
                %grab max + index
                r_a = WorkingAE(:,6);
                workingmax = max(r_a{i,1});
                if (workingmax > yearlymax)
                    yearlymax = workingmax;
                    ids_a = WorkingAE(:,1);
                    maxid = ids_a{i,1};
                    life_a = WorkingAE(:,16);
                    maxlife = life_a{i,1};
                    maxmonth = date2str;
                    maxi = i;
                end
            end
        end
    end
    %plot largest eddy family
    finallist = idlist(maxi,:);
    Charisma(1,j) = finallist;
    figure('Position',[1 1 1000 1400], 'visible', 'off')
    m_proj('mercator','lon',[40, 80],'lat',[0 20])
    disp(['working' ' ' int2str(datearray(j)) ' GW'])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    m_text(44,17,[maxmonth ' ' int2str(datearray(j))],'Color','w','fontsize',32);
    m_text(41,9.5,['Max Radius: ' int2str(yearlymax) ' km'],'Color','w','fontsize',18);
    m_text(41,7.5,['Lifetime: ' int2str(maxlife) ' days'],'Color','w','fontsize',18);
    m_line(ASXLim,ASYLim,'linewi',2,'Color', 'r');
    hold on
    for i = 1:length(finallist{1})
        x_p=AE_traj(:,2);
        x_p1=x_p{finallist{1}(i),1};
        y_p=AE_traj(:,3);
        y_p1=y_p{finallist{1}(i),1};
        if (finallist{1}(i) == maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
            hold on
            m_plot(x_p1(1),y_p1(1), '*r')
        elseif (finallist{1}(i) < maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0 0.4470 0.7410],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*g')
        else
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0.9290 0.6940 0.1250],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*', 'Color', [0.8500 0.3250 0.0980])
        end
        hold on
    end
    F(j) = getframe(gcf);
end

video=VideoWriter('GreatWhirlTimeLapseSmaller.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');
%% Filter for SE
%Between 9 North and 15 North; 54 East to 60 East.
%Largest Radius positive eddy generated in this box between May and Sept.
latlonbounds = [15 9 58 52]; %N S E W
monthbounds = ["May", "Jun", "Jul", "Aug", "Sep"]; %timewise filter
datearray = 1993:2019;
ASYLim = [latlonbounds(2) latlonbounds(1) latlonbounds(1) latlonbounds(2) latlonbounds(2)];
ASXLim = [latlonbounds(4) latlonbounds(4) latlonbounds(3) latlonbounds(3) latlonbounds(4)];
for j = 1:27
    workingmax = 0;
    yearlymax = 0;
    maxid = 0;
    WorkingAE = AElists{j,1};
    idlist = cell(length(WorkingAE),1);
    for i = 1:length(WorkingAE)
        date_a=WorkingAE(:,14);
        date=date_a{i,1};
        date2=datestr(date);
        date2str=date2(1,4:6);
        %is in our temporal domain
        if ismember(date2str,monthbounds)
            x_a=WorkingAE(:,2);
            x_1=x_a{i,1};
            y_a=WorkingAE(:,3);
            y_1=y_a{i,1};
            % is in our spatial domain
            if ((x_1(1) > latlonbounds(4)) && (x_1(1) < latlonbounds(3)) && (y_1(1) > latlonbounds(2)) && (y_1(1) < latlonbounds(1)))
                %grab full ancestry of this guy
                [~, idlist{i,1}] = ancestry(WorkingAE, AE_traj, i);
                %grab max + index
                r_a = WorkingAE(:,6);
                workingmax = max(r_a{i,1});
                if (workingmax > yearlymax)
                    yearlymax = workingmax;
                    ids_a = WorkingAE(:,1);
                    maxid = ids_a{i,1};
                    life_a = WorkingAE(:,16);
                    maxlife = life_a{i,1};
                    maxmonth = date2str;
                    maxi = i;
                end
            end
        end
    end
    %plot largest eddy family
    finallist = idlist(maxi,:);
    Charisma(2,j) = finallist;
    figure('Position',[1 1 1000 1400], 'visible', 'off')
    m_proj('mercator','lon',[40, 80],'lat',[0 20])
    disp(['working' ' ' int2str(datearray(j)) ' SE'])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    m_text(44,17,[maxmonth ' ' int2str(datearray(j))],'Color','w','fontsize',32);
    m_text(41,9.5,['Max Radius: ' int2str(yearlymax) ' km'],'Color','w','fontsize',18);
    m_text(41,7.5,['Lifetime: ' int2str(maxlife) ' days'],'Color','w','fontsize',18);
    m_line(ASXLim,ASYLim,'linewi',2,'Color', 'r');
    hold on
    for i = 1:length(finallist{1})
        x_p=AE_traj(:,2);
        x_p1=x_p{finallist{1}(i),1};
        y_p=AE_traj(:,3);
        y_p1=y_p{finallist{1}(i),1};
        if (finallist{1}(i) == maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
            hold on
            m_plot(x_p1(1),y_p1(1), '*r')
        elseif (finallist{1}(i) < maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0 0.4470 0.7410],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*g')
        else
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0.9290 0.6940 0.1250],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*', 'Color', [0.8500 0.3250 0.0980])
        end
        hold on
    end
    F(j) = getframe(gcf);
end

video=VideoWriter('SocotraEddyTimeLapse.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');

%% Filter for SG
%Between 1 North and 5 North, 40 East to 55 East.
%Largest Radius positive eddy generated in this box between May and July
latlonbounds = [5 1 55 43]; %N S E W
monthbounds = ["May", "Jun", "Jul"]; %timewise filter
datearray = 1993:2019;
ASYLim = [latlonbounds(2) latlonbounds(1) latlonbounds(1) latlonbounds(2) latlonbounds(2)];
ASXLim = [latlonbounds(4) latlonbounds(4) latlonbounds(3) latlonbounds(3) latlonbounds(4)];
for j = 1:27
    workingmax = 0;
    yearlymax = 0;
    maxid = 0;
    WorkingAE = AElists{j,1};
    idlist = cell(length(WorkingAE),1);
    for i = 1:length(WorkingAE)
        date_a=WorkingAE(:,14);
        date=date_a{i,1};
        date2=datestr(date);
        date2str=date2(1,4:6);
        %is in our temporal domain
        if ismember(date2str,monthbounds)
            x_a=WorkingAE(:,2);
            x_1=x_a{i,1};
            y_a=WorkingAE(:,3);
            y_1=y_a{i,1};
            % is in our spatial domain
            if ((x_1(1) > latlonbounds(4)) && (x_1(1) < latlonbounds(3)) && (y_1(1) > latlonbounds(2)) && (y_1(1) < latlonbounds(1)))
                %grab full ancestry of this guy
                [~, idlist{i,1}] = ancestry(WorkingAE, AE_traj, i);
                %grab max + index
                r_a = WorkingAE(:,6);
                workingmax = max(r_a{i,1});
                if (workingmax > yearlymax)
                    yearlymax = workingmax;
                    ids_a = WorkingAE(:,1);
                    maxid = ids_a{i,1};
                    life_a = WorkingAE(:,16);
                    maxlife = life_a{i,1};
                    maxmonth = date2str;
                    maxi = i;
                end
            end
        end
    end
    %plot largest eddy family
    finallist = idlist(maxi,:);
    Charisma(3,j) = finallist;
    figure('Position',[1 1 1000 1400], 'visible', 'off')
    m_proj('mercator','lon',[40, 80],'lat',[-5 15])
    disp(['working' ' ' int2str(datearray(j)) ' SG'])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    m_text(44,17,[maxmonth ' ' int2str(datearray(j))],'Color','w','fontsize',32);
    m_text(41,9.5,['Max Radius: ' int2str(yearlymax) ' km'],'Color','w','fontsize',18);
    m_text(41,7.5,['Lifetime: ' int2str(maxlife) ' days'],'Color','w','fontsize',18);
    m_line(ASXLim,ASYLim,'linewi',2,'Color', 'r');
    hold on
    for i = 1:length(finallist{1})
        x_p=AE_traj(:,2);
        x_p1=x_p{finallist{1}(i),1};
        y_p=AE_traj(:,3);
        y_p1=y_p{finallist{1}(i),1};
        if (finallist{1}(i) == maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
            hold on
            m_plot(x_p1(1),y_p1(1), '*r')
        elseif (finallist{1}(i) < maxid)
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0 0.4470 0.7410],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*g')
        else
            m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0.9290 0.6940 0.1250],  'LineWidth', 1);
            hold on
            m_plot(x_p1(1),y_p1(1), '*', 'Color', [0.8500 0.3250 0.0980])
        end
        hold on
    end
    F(j) = getframe(gcf);
end

video=VideoWriter('SouthernGyreTimeLapse.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');

%% Filter for LH
%LH forms reliably along 10 North,  70-75 East.
% 5 North to 15 North, longest lived positive (AE) eddy in Jan-Mar
latlonbounds = [13 6 76 71]; %N S E W
monthbounds = ["Jan", "Feb", "Mar"]; %timewise filter
datearray = 1993:2019;
ASYLim = [latlonbounds(2) latlonbounds(1) latlonbounds(1) latlonbounds(2) latlonbounds(2)];
ASXLim = [latlonbounds(4) latlonbounds(4) latlonbounds(3) latlonbounds(3) latlonbounds(4)];
for j = 1:27
    clear fulllife
    WorkingAE = AElists{j,1};
    idlist = cell(length(WorkingAE),1);
    for i = 1:length(WorkingAE)
        date_a=WorkingAE(:,14);
        date=date_a{i,1};
        date2=datestr(date);
        date2str=date2(1,4:6);
        %is in our temporal domain
        if ismember(date2str,monthbounds)
            x_a=WorkingAE(:,2);
            x_1=x_a{i,1};
            y_a=WorkingAE(:,3);
            y_1=y_a{i,1};
            % is in our spatial domain
            if ((x_1(1) > latlonbounds(4)) && (x_1(1) < latlonbounds(3)) && (y_1(1) > latlonbounds(2)) && (y_1(1) < latlonbounds(1)))
                %grab full ancestry of this guy
                [fulllife(i), idlist{i,1}] = ancestry(WorkingAE, AE_traj, i);
                datelist(i) = string(date2str);
            end
        end
    end
    %plot longest-lived eddy family
    [val, id] = max(fulllife);
    maxid = id;
    maxmonth = datelist(id);
    finallist = idlist(id,:);
    Charisma(4,j) = finallist;
    r_a = AE_traj(:,6);
    workingmax = 0;
    finalmax = 0;
    for i = 1:length(finallist{1})
        workingmax = max(r_a{finallist{1}(i),1});
        if (workingmax > finalmax)
            finalmax = workingmax;
        end
    end
    figure('Position',[1 1 1000 1400], 'visible', 'off')
    m_proj('mercator','lon',[40, 80],'lat',[0 15])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    hold on
    m_text(41,8,[convertStringsToChars(maxmonth) ' ' int2str(datearray(j))],'Color','w','fontsize',20);
    m_text(41,9.7,['Max Radius: ' int2str(finalmax) ' km'],'Color','w','fontsize',20);
    m_line(ASXLim,ASYLim,'linewi',2,'Color', 'r');
    disp(['working' ' ' int2str(datearray(j)) ' LH'])
    for i = 1:length(finallist{1})
        x_p=AE_traj(:,2);
        x_p1=x_p{finallist{1}(i),1};
        y_p=AE_traj(:,3);
        y_p1=y_p{finallist{1}(i),1};
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
        hold on
        m_plot(x_p1(1),y_p1(1), '*r')
        
    end
    F(j) = getframe(gcf);
end

video=VideoWriter('LackshadweepTimeLapse.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');

%% Filter for LL
%LL forms reliably along 10 North, 70-75 East.
% 5 to 15 North, longest lived CE (negative) eddy in July-Sept
latlonbounds = [15 5 76 71]; %N S E W
monthbounds = ["Jun", "Jul", "Aug", "Sep"]; %timewise filter
datearray = 1993:2019;
ASYLim = [latlonbounds(2) latlonbounds(1) latlonbounds(1) latlonbounds(2) latlonbounds(2)];
ASXLim = [latlonbounds(4) latlonbounds(4) latlonbounds(3) latlonbounds(3) latlonbounds(4)];
for j = 1:27
    clear fulllife
    WorkingCE = CElists{j,1};
    idlist = cell(length(WorkingCE),1);
    for i = 1:length(WorkingCE)
        date_a=WorkingCE(:,14);
        date=date_a{i,1};
        date2=datestr(date);
        date2str=date2(1,4:6);
        %is in our temporal domain
        if ismember(date2str,monthbounds)
            x_a=WorkingCE(:,2);
            x_1=x_a{i,1};
            y_a=WorkingCE(:,3);
            y_1=y_a{i,1};
            % is in our spatial domain
            if ((x_1(1) > latlonbounds(4)) && (x_1(1) < latlonbounds(3)) && (y_1(1) > latlonbounds(2)) && (y_1(1) < latlonbounds(1)))
                %is ending further west than it started
                %grab full ancestry of this guy
                [fulllife(i), idlist{i,1}] = ancestry(WorkingCE, CE_traj, i);
                datelist(i) = string(date2str);
            end
        end
    end
    %plot longest-lived eddy family
    [val, id] = max(fulllife);
    maxid = id;
    maxmonth = datelist(id);
    finallist = idlist(id,:);
    Charisma(5,j) = finallist;
    r_a = CE_traj(:,6);
    workingmax = 0;
    finalmax = 0;
    for i = 1:length(finallist{1})
        workingmax = max(r_a{finallist{1}(i),1});
        if (workingmax > finalmax)
            finalmax = workingmax;
        end
    end
    figure('Position',[1 1 1000 1400], 'visible', 'off')
    m_proj('mercator','lon',[40, 90],'lat',[0 20])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    hold on
    m_text(41,8,[convertStringsToChars(maxmonth) ' ' int2str(datearray(j))],'Color','w','fontsize',16);
    m_text(41,9.7,['Max Radius: ' int2str(finalmax) ' km'],'Color','w','fontsize',16);
    m_line(ASXLim,ASYLim,'linewi',2,'Color', 'r');
    disp(['working' ' ' int2str(datearray(j)) ' LL'])
    for i = 1:length(finallist{1})
        x_p=CE_traj(:,2);
        x_p1=x_p{finallist{1}(i),1};
        y_p=CE_traj(:,3);
        y_p1=y_p{finallist{1}(i),1};
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
        hold on
        m_plot(x_p1(1),y_p1(1), '*r')
        
    end
    F(j) = getframe(gcf);
end

video=VideoWriter('LackshadweepLowTimeLapse.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');

save('Charisma.mat', 'Charisma')

%% Plot ALL Eddies by year
%Charisma: 1-5: GW, SE, SG, LH, LL
repeatlist = zeros(1,500);
repeatcount = 0;
for i = 1:27
    figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off')
    m_proj('mercator','lon',[40, 90],'lat',[-5 25])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    hold on
    m_text(44,20,int2str(datearray(i)),'Color','w','fontsize',32);
    disp(['working' ' ' int2str(datearray(i)) ' CHA'])
    for j = [5,1,2,3,4]
        clear finallist
        finallist = Charisma{j,i};
        for k = 1:length(finallist)
            repeatcount = repeatcount + 1;
            repeatflag = 0;
            if (ismember(finallist(k),repeatlist))
                repeatflag = 1;
            end
            repeatlist(repeatcount) = finallist(k);
            x_p=AE_traj(:,2);
            x_p1=x_p{finallist(k),1};
            y_p=AE_traj(:,3);
            y_p1=y_p{finallist(k),1};
            if ((repeatflag == 1) && (j ~= 5))
                a6 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
                hold on
                m_plot(x_p1(1),y_p1(1), '*k')
            elseif ((repeatflag == 1) && (j == 5))
                x_p=CE_traj(:,2);
                x_p1=x_p{finallist(k),1};
                y_p=CE_traj(:,3);
                y_p1=y_p{finallist(k),1};
                a6 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'k', 'LineWidth', 2);
                hold on
                m_plot(x_p1(1),y_p1(1), '*k')
            else
                
                switch j
                    case 1
                        a1 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2);
                        hold on
                        m_plot(x_p1(1),y_p1(1), '*r')
                    case 2
                        a2 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2);
                        hold on
                        m_plot(x_p1(1),y_p1(1), '*', 'Color', [0.9290, 0.6940, 0.1250])
                    case 3
                        a3 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'b', 'LineWidth', 2);
                        hold on
                        m_plot(x_p1(1),y_p1(1), '*b')
                    case 4
                        a4 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'g', 'LineWidth', 2);
                        hold on
                        m_plot(x_p1(1),y_p1(1), '*g')
                    case 5
                        x_p=CE_traj(:,2);
                        x_p1=x_p{finallist(k),1};
                        y_p=CE_traj(:,3);
                        y_p1=y_p{finallist(k),1};
                        a5 = m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', 'm', 'LineWidth', 2);
                        hold on
                        m_plot(x_p1(1),y_p1(1), '*m')
                end
            end
        end
    end
    hold on
    h = zeros(6, 1);
    h(1) = plot([-10 -11],[-10 -11],'-r');
    hold on
    h(2) = plot([-10 -12],[-10 -11],'-', 'Color', [0.9290, 0.6940, 0.1250]);
    hold on
    h(3) = plot([-10 -13],[-10 -11],'-b');
    hold on
    h(4) = plot([-10 -14],[-10 -11],'-g');
    hold on
    h(5) = plot([-10 -15],[-10 -11],'-m');
    hold on
    h(6) = plot([-10 -16],[-10 -11],'-k');
    legend(h, {'Great Whirl System', 'Socotra Eddy System', 'Southern Gyre System','Lackshadweep High System', 'Lackshadweep Low System', 'Eddy Overlaps Systems'}, 'FontSize', 24);
    F(i) = getframe(gcf);
end

video=VideoWriter('CharismaTimeLapse.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');

