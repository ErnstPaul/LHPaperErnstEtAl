%% Paul_FLH_FinalEddyTracking.m (version 1.1)
%Author: Paul Ernst
%Date Created: 6/15/2021
%Date of Last Update: 6/25/2021
%Update History:
%PE 6/25/2021 - Added SES and SEF distinctions.
%PE 6/15/2021 - Created
%--------------------------------------
%Purpose: Correlates dates of LH, LHW, SE, and GW
%Inputs: FinalEddyIDLists.mat (from Paul_FinalEddyTracking.m), MoK dates,
%        Traj files (from eddy steps)
%Outputs: Time series of dates (plot)
%--------------------------------------
%% Data Entry
%Load automatically tracked eddies
load('Charisma.mat')
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'EXTRACTION/EDDY_TRAJECTORIES')) %where are the trajectories files located?
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/private')
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/m_map/')
addpath(strcat(basepath, 'export_figs/')) %where is export_figs located?
load('AE_Filtered_Trajectories.mat') %load AE trajectories
GW = Charisma(1,:);
SE = Charisma(2,:);
LH = Charisma(4,:);

%GWRoot is the manually identified "original" eddy, the main element of the
%family that forms GWFinal
GWRoot = [62	4913	8780	13470	18632	21883	25066	28801	33097	37142	41028	44731	48970	53550	57428	62109	64461	69647	73243	77223	81322	84926	88513	92758	96181	100494	105567];
GWFinal = GW;
GWFinal{9} = [33097, 32451];
GWFinal{10} = 37142;
GWFinal{17} = 64461;
GWFinal{23} = 88513;
GWFinal{24} = 92758;

%SERoot is the manually identified "original" eddy, the main element of the
%family that forms SEFinal
SEFRoot = [20	6157	9808	15406	16876	20024	25996	30528	32451	38440	42392	46653	50625	55432	58535	61116	64899	71424	72724	78101	83020	86994	91176	93608	96691	102483	106811];
SESRoot= [1349	5953	7473	13652	17326	22737	26633	29408	33312	39084	42905	46166	49685	54826	58535	62255	64749	70329	75268	78101	82469	84776	90389	93608	97809	100445	105427];
SEFRootC = num2cell(SEFRoot);
SESRootC = num2cell(SESRoot);
SEFinal = SE;
SEFinal{27} = 105427;
SEFinal{25} = 97809;
SEFinal{24} = 93608;
SEFinal{21} = 82469;
SEFinal{17} = 64749;
SEFinal{13} = 49685;
SEFinal{12} = 46653;
SEFinal{11} = 42905;
SEFinal{10} = 38440;
SEFinal{9} = 33312;
SEFinal{7} = 26633;
SEFinal{6} = 22737;
SEFinal{5} = 16131;
SEFinal{2} = 5953;

%LHRoot is the manually identified "original" eddy, the main element of the
%family that forms LHFinal
LHRoot = [20	4272	8086	12514	16584	20439	24727	28801	32451	36753	40727	44392	48411	52511	56182	60358	64749	68756	72756	75880	80833	84280	88149	92397	96181	100087	103636];
LHFinal = LH;
LHFinal{3} = [8086, 8975];
LHFinal{4} = [12514, 13536];
LHFinal{5} = 16584;
LHFinal{12} = 44392;
LHFinal{13} = [48411, 48729, 49685];
LHFinal{17} = 64749;
LHFinal{18} = 68756;
LHFinal{24} = [92397, 92847];
LHFinal{26} = 100087;

%LHWRoot is the manually identified "original" eddy, the main element of the
%family that forms LHWFinal
LHWRoot = [62	4332	8170	12418	16643	20770	25066	29125	33097	36902	41028	44731	48511	52892	56742	60790	64461	68948	73059	75773	80556	84618	88513	92449	96412	100494	104219];
LHWFinal = cell(1,27);
LHWFinal{1} = 62;
LHWFinal{2} = [4332, 4905, 4913];
LHWFinal{3} = [8170, 8780];
LHWFinal{4} = [12418, 13997, 13470];
LHWFinal{5} = [16643, 17636, 17462, 17813, 16131];
LHWFinal{6} = [20770, 21147, 21996];
LHWFinal{7} = 25066;
LHWFinal{8} = [29125, 28801];
LHWFinal{9} = 33097;
LHWFinal{10} = [36902, 37860, 37935, 37142];
LHWFinal{11} = 41028;
LHWFinal{12} = 44731;
LHWFinal{13} = [48511, 48752, 48970];
LHWFinal{14} = [52892, 52913, 53550];
LHWFinal{15} = [56742, 56967, 56995, 57458];
LHWFinal{16} = 60790;
LHWFinal{17} = 64461;
LHWFinal{18} = [68948, 69405, 69405];
LHWFinal{19} = [73059, 73243];
LHWFinal{20} = [75773, 77223];
LHWFinal{21} = [80556];
LHWFinal{22} = [84618, 85483, 85886, 85991, 85872];
LHWFinal{23} = 88513;
LHWFinal{24} = [92449, 93378, 92758];
LHWFinal{25} = [96412, 96944, 97136];
LHWFinal{26} = 100494;
LHWFinal{27} = [104219, 105567];

%% Family tracking

GWFinalFull = compactAncestry(GWFinal, AE_traj);
SEFinalFull = compactAncestry(SEFinal, AE_traj);
LHFinalFull = compactAncestry(LHFinal, AE_traj);
LHWFinalFull = compactAncestry(LHWFinal, AE_traj);
SESRootFamily = compactAncestry(SESRootC, AE_traj);
SEFRootFamily = compactAncestry(SEFRootC, AE_traj);

save('FinalEddyIDLists', 'GWRoot', 'GWFinalFull', 'SESRoot', 'SESRootFamily', 'SEFRoot', 'SEFRootFamily', 'SEFinalFull', 'LHRoot', 'LHFinalFull', 'LHWRoot', 'LHWFinalFull');
%% Family Plotting

x_p=AE_traj(:,2); y_p=AE_traj(:,3);
datearray = 1993:2019;
output_dir= strcat(basepath, 'MOVIE/INDIVIDUAL_FILES/TRACKING/');

for i = 1:27
    figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off')
    m_proj('mercator','lon',[40, 90],'lat',[-5 25])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    hold on
    m_text(44,20,int2str(datearray(i)),'Color','w','fontsize',32);
    disp(['working' ' ' int2str(datearray(i)) ' Final'])
    %Plot each eddy on one geographic area, differing in color, marked with
    %asterisks surrounded by circles where they originate; root eddies are
    %distinguished by thicker lines
    repeatlistGW = [SEFRootFamily{i} LHFinalFull{i} LHWFinalFull{i} SESRootFamily{i}];
    repeatlistSES = [GWFinalFull{i} LHFinalFull{i} LHWFinalFull{i} SEFRootFamily{i}];
    repeatlistSEF = [GWFinalFull{i} LHFinalFull{i} LHWFinalFull{i} SESRootFamily{i}];
    repeatlistLH = [GWFinalFull{i} SESRootFamily{i} LHWFinalFull{i} SEFRootFamily{i}];
    repeatlistLHW = [GWFinalFull{i} SESRootFamily{i} LHFinalFull{i} SEFRootFamily{i}];
    %Do GW
    for j = 1:length(GWFinalFull{i})
        x_p1 = x_p{GWFinalFull{i}(j),1};
        y_p1 = y_p{GWFinalFull{i}(j),1};
        if ismember(GWFinalFull{i}(j), GWRoot)
            LW = 4;
        else
            LW = 2;
        end
        if ismember(GWFinalFull{i}(j), repeatlistGW)
            colorPlot = 'k';
            disp(["Overlap Detected: " + int2str(GWFinalFull{i}(j))]);
        else
            colorPlot = 'r';
        end
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', colorPlot, 'LineWidth', LW);
        hold on
        m_text(x_p1(1), y_p1(1), int2str(GWFinalFull{i}(j)), 'fontsize', 12);
    end
    
    %Do SES
    for j = 1:length(SESRootFamily{i})
        x_p1 = x_p{SESRootFamily{i}(j),1};
        y_p1 = y_p{SESRootFamily{i}(j),1};
        %Check if this is the root
        if ismember(SESRootFamily{i}(j), SESRoot)
            LW = 4;
        else
            LW = 2;
        end
        %Check for repeats
        if ismember(SESRootFamily{i}(j), repeatlistSES)
            colorPlot = 'k';
            disp(["Overlap Detected: " + int2str(SESRootFamily{i}(j))]);
        else
            colorPlot = [0.9290, 0.6940, 0.1250];
        end
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', colorPlot, 'LineWidth', LW);
        hold on
        m_text(x_p1(1), y_p1(1), int2str(SESRootFamily{i}(j)), 'fontsize', 12);
    end
    
    %Do SEF
    for j = 1:length(SEFRootFamily{i})
        x_p1 = x_p{SEFRootFamily{i}(j),1};
        y_p1 = y_p{SEFRootFamily{i}(j),1};
        %Check if this is the root
        if ismember(SEFRootFamily{i}(j), SEFRoot)
            LW = 4;
        else
            LW = 2;
        end
        %Check for repeats
        if ismember(SEFRootFamily{i}(j), repeatlistSEF)
            colorPlot = 'k';
            disp(["Overlap Detected: " + int2str(SEFRootFamily{i}(j))]);
        else
            colorPlot = 'm';
        end
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', colorPlot, 'LineWidth', LW);
        hold on
        m_text(x_p1(1), y_p1(1), int2str(SEFRootFamily{i}(j)), 'fontsize', 12);
    end
    
    %Do LH
    for j = 1:length(LHFinalFull{i})
        x_p1 = x_p{LHFinalFull{i}(j),1};
        y_p1 = y_p{LHFinalFull{i}(j),1};
        %Check if this is the root
        if ismember(LHFinalFull{i}(j), LHRoot)
            LW = 4;
        else
            LW = 2;
        end
        %Check for repeats
        if ismember(LHFinalFull{i}(j), repeatlistLH)
            colorPlot = 'k';
            disp(["Overlap Detected: " + int2str(LHFinalFull{i}(j))]);
        else
            colorPlot = 'b';
        end
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', colorPlot, 'LineWidth', LW);
        hold on
        m_text(x_p1(1), y_p1(1), int2str(LHFinalFull{i}(j)), 'fontsize', 12);
    end
    
    %Do LHW
    for j = 1:length(LHWFinalFull{i})
        x_p1 = x_p{LHWFinalFull{i}(j),1};
        y_p1 = y_p{LHWFinalFull{i}(j),1};
        %Check if this is the root
        if ismember(LHWFinalFull{i}(j), LHWRoot)
            LW = 4;
        else
            LW = 2;
        end
        %Check for repeats
        if ismember(LHWFinalFull{i}(j), repeatlistLHW)
            colorPlot = 'k';
            disp(["Overlap Detected: " + int2str(LHWFinalFull{i}(j))]);
        else
            colorPlot = 'g';
        end
        m_plot(x_p1,y_p1, 'LineStyle', '-', 'Color', colorPlot, 'LineWidth', LW);
        hold on
        m_text(x_p1(1), y_p1(1), int2str(LHWFinalFull{i}(j)), 'fontsize', 12);
    end
    set(gca,'fontsize',32);
    title("Eddies by year: Thicker Lines = Root Eddies", 'fontsize', 28)
    ylabel('Latitude');
    xlabel('Longitude');
    hold on
    h = zeros(6, 1);
    h(1) = plot([-10 -11],[-10 -11],'-r');
    hold on
    h(2) = plot([-10 -12],[-10 -11],'-', 'Color', [0.9290, 0.6940, 0.1250]);
    hold on
    h(3) = plot([-10 -12],[-10 -11],'-m');
    hold on
    h(4) = plot([-10 -13],[-10 -11],'-b');
    hold on
    h(5) = plot([-10 -14],[-10 -11],'-g');
    hold on
    h(6) = plot([-10 -15],[-10 -11],'-k');
    legend(h, {'Great Whirl System', 'Socotra Eddy Summer System', 'Socotra Eddy Fall System', 'Lackshadweep High System','Lackshadweep High West System', 'Eddy Overlaps Systems'}, 'FontSize', 24);
    set(gcf,'PaperPositionMode','auto');
    filenamestring = ([output_dir  int2str(datearray(i))  '.png']);
    filename = char(filenamestring);
    %we use export_fig because it automatically crops and is nice
    export_fig(filename);
    %we have to delete the figure or else memory go kaboom because
    %MATLAB is a fun and engaging memory management simulator
    delete(gcf)
end

% Make movie
titlestring = 'FinalTrackingTimeLapse.mp4';
filedir=dir(output_dir);
addpath(output_dir);
video=VideoWriter(titlestring,'MPEG-4'); %create the video object, using mp4 by default
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
for dday=3:length(filedir) %where N is the number of images; we use 3 because the only other thing in this directory
    %should be "." and ".." which are the present
    %and current directories. If you have other
    %random stuff in here, then just note that you
    %may need to change "3" to something else. Check
    %the "filedir" variable.
    disp(['processing video:' ' ' filedir(dday).name]);
    I=imread([filedir(dday).name]); %read the next image
    writeVideo(video,I);
end
close(video); %close the file
disp('finished');



%% Packaging the ancestry function so it's just one line above
function [finalMatFull] = compactAncestry(finalMat, trajectories)
finalMatFull = cell(1,27);
for year = 1:27
    clear idlist
    idlist(1) = finalMat{year}(1);
    for ancestor = 1:length(finalMat{year})
        idlist = [idlist, ancestryFull(trajectories, finalMat{year}(ancestor))];
    end
    idlist = unique(idlist);
    finalMatFull{year} = idlist;
end
end


