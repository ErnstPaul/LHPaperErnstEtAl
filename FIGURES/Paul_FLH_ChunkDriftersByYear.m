%% Paul_FLH_ChunkDriftersByYear.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/26/2021
%Date of Last Update: 5/26/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Chunks drifter files into individual years (1993-->2019)
%Inputs: .mat files for interpolated drifters.
%Outputs: .mat files for all drifters and year by year drifters.
basepath = '/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/'; %this is our base path, everything stems from here
addpath(strcat(basepath, 'm_map/private/')); %where is m_map's private directory?
addpath(strcat(basepath, 'm_map/')) %where is m_map's full directory?
load('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/Whack_Data/gdp_interpolated_drifter_e525_ef89_4814.mat')
%% Processing Drifter Data
date = (gdp_interpolated_drifter.time);
date_d = date/60/60/24 + 719529; %this is in "seconds after jan 1st, 1970" so we reduce it down to days and add
%the 1/1/1970 datenum to it to get its
%MATLAB serial datenum
count93=0;count94=0;count95=0; count96=0;count97=0;count98=0;count99=0;
count00=0;count01=0;count02=0;count03=0;count04=0;count05=0;
count06=0;count07=0;count08=0;count09=0;count10=0;count11=0;
count12=0;count13=0;count14=0;count15=0;count16=0;count17=0;
count18=0;count19=0;
betterIDList = zeros(length(gdp_interpolated_drifter.ID),1);

%% Chunk by year of measurement
for i=1:length(gdp_interpolated_drifter.ID)
    betterIDList(i) = str2double(gdp_interpolated_drifter.ID(i,:));
    date=date_d(i);
    date2=datestr(date);
    date2str=date2(1,10:11);
    date2use=str2double(date2str);
    disp(date2str)
    %date2use is now the last 2 digits in 20XX or 19XX
    switch date2use
         case 93
            count93=count93+1;
            DR93(count93,1) = betterIDList(i);
            DR93(count93,2) = gdp_interpolated_drifter.longitude(i);
            DR93(count93,3) = gdp_interpolated_drifter.latitude(i);
            DR93(count93,4) = date_d(i);
            DR93(count93,5) = gdp_interpolated_drifter.temp(i);
            DR93(count93,6) = gdp_interpolated_drifter.ve(i);
            DR93(count93,7) = gdp_interpolated_drifter.vn(i);
        case 94
            count94=count94+1;
            DR94(count94,1) = betterIDList(i);
            DR94(count94,2) = gdp_interpolated_drifter.longitude(i);
            DR94(count94,3) = gdp_interpolated_drifter.latitude(i);
            DR94(count94,4) = date_d(i);
            DR94(count94,5) = gdp_interpolated_drifter.temp(i);
            DR94(count94,6) = gdp_interpolated_drifter.ve(i);
            DR94(count94,7) = gdp_interpolated_drifter.vn(i);
        case 95
            count95=count95+1;
            DR95(count95,1) = betterIDList(i);
            DR95(count95,2) = gdp_interpolated_drifter.longitude(i);
            DR95(count95,3) = gdp_interpolated_drifter.latitude(i);
            DR95(count95,4) = date_d(i);
            DR95(count95,5) = gdp_interpolated_drifter.temp(i);
            DR95(count95,6) = gdp_interpolated_drifter.ve(i);
            DR95(count95,7) = gdp_interpolated_drifter.vn(i);
        case 96
            count96=count96+1;
            DR96(count96,1) = betterIDList(i);
            DR96(count96,2) = gdp_interpolated_drifter.longitude(i);
            DR96(count96,3) = gdp_interpolated_drifter.latitude(i);
            DR96(count96,4) = date_d(i);
            DR96(count96,5) = gdp_interpolated_drifter.temp(i);
            DR96(count96,6) = gdp_interpolated_drifter.ve(i);
            DR96(count96,7) = gdp_interpolated_drifter.vn(i);
        case 97
            count97=count97+1;
            DR97(count97,1) = betterIDList(i);
            DR97(count97,2) = gdp_interpolated_drifter.longitude(i);
            DR97(count97,3) = gdp_interpolated_drifter.latitude(i);
            DR97(count97,4) = date_d(i);
            DR97(count97,5) = gdp_interpolated_drifter.temp(i);
            DR97(count97,6) = gdp_interpolated_drifter.ve(i);
            DR97(count97,7) = gdp_interpolated_drifter.vn(i);
        case 98
            count98=count98+1;
            DR98(count98,1) = betterIDList(i);
            DR98(count98,2) = gdp_interpolated_drifter.longitude(i);
            DR98(count98,3) = gdp_interpolated_drifter.latitude(i);
            DR98(count98,4) = date_d(i);
            DR98(count98,5) = gdp_interpolated_drifter.temp(i);
            DR98(count98,6) = gdp_interpolated_drifter.ve(i);
            DR98(count98,7) = gdp_interpolated_drifter.vn(i);
        case 99
            count99=count99+1;
            DR99(count99,1) = betterIDList(i);
            DR99(count99,2) = gdp_interpolated_drifter.longitude(i);
            DR99(count99,3) = gdp_interpolated_drifter.latitude(i);
            DR99(count99,4) = date_d(i);
            DR99(count99,5) = gdp_interpolated_drifter.temp(i);
            DR99(count99,6) = gdp_interpolated_drifter.ve(i);
            DR99(count99,7) = gdp_interpolated_drifter.vn(i);
        case 00
            count00=count00+1;
            DR00(count00,1) = betterIDList(i);
            DR00(count00,2) = gdp_interpolated_drifter.longitude(i);
            DR00(count00,3) = gdp_interpolated_drifter.latitude(i);
            DR00(count00,4) = date_d(i);
            DR00(count00,5) = gdp_interpolated_drifter.temp(i);
            DR00(count00,6) = gdp_interpolated_drifter.ve(i);
            DR00(count00,7) = gdp_interpolated_drifter.vn(i);
        case 01
            count01=count01+1;
            DR01(count01,1) = betterIDList(i);
            DR01(count01,2) = gdp_interpolated_drifter.longitude(i);
            DR01(count01,3) = gdp_interpolated_drifter.latitude(i);
            DR01(count01,4) = date_d(i);
            DR01(count01,5) = gdp_interpolated_drifter.temp(i);
            DR01(count01,6) = gdp_interpolated_drifter.ve(i);
            DR01(count01,7) = gdp_interpolated_drifter.vn(i);
        case 02
            count02=count02+1;
            DR02(count02,1) = betterIDList(i);
            DR02(count02,2) = gdp_interpolated_drifter.longitude(i);
            DR02(count02,3) = gdp_interpolated_drifter.latitude(i);
            DR02(count02,4) = date_d(i);
            DR02(count02,5) = gdp_interpolated_drifter.temp(i);
            DR02(count02,6) = gdp_interpolated_drifter.ve(i);
            DR02(count02,7) = gdp_interpolated_drifter.vn(i);
        case 03
            count03=count03+1;
            DR03(count03,1) = betterIDList(i);
            DR03(count03,2) = gdp_interpolated_drifter.longitude(i);
            DR03(count03,3) = gdp_interpolated_drifter.latitude(i);
            DR03(count03,4) = date_d(i);
            DR03(count03,5) = gdp_interpolated_drifter.temp(i);
            DR03(count03,6) = gdp_interpolated_drifter.ve(i);
            DR03(count03,7) = gdp_interpolated_drifter.vn(i);
        case 04
            count04=count04+1;
            DR04(count04,1) = betterIDList(i);
            DR04(count04,2) = gdp_interpolated_drifter.longitude(i);
            DR04(count04,3) = gdp_interpolated_drifter.latitude(i);
            DR04(count04,4) = date_d(i);
            DR04(count04,5) = gdp_interpolated_drifter.temp(i);
            DR04(count04,6) = gdp_interpolated_drifter.ve(i);
            DR04(count04,7) = gdp_interpolated_drifter.vn(i);
        case 05
            count05=count05+1;
            DR05(count05,1) = betterIDList(i);
            DR05(count05,2) = gdp_interpolated_drifter.longitude(i);
            DR05(count05,3) = gdp_interpolated_drifter.latitude(i);
            DR05(count05,4) = date_d(i);
            DR05(count05,5) = gdp_interpolated_drifter.temp(i);
            DR05(count05,6) = gdp_interpolated_drifter.ve(i);
            DR05(count05,7) = gdp_interpolated_drifter.vn(i);
        case 06
            count06=count06+1;
            DR06(count06,1) = betterIDList(i);
            DR06(count06,2) = gdp_interpolated_drifter.longitude(i);
            DR06(count06,3) = gdp_interpolated_drifter.latitude(i);
            DR06(count06,4) = date_d(i);
            DR06(count06,5) = gdp_interpolated_drifter.temp(i);
            DR06(count06,6) = gdp_interpolated_drifter.ve(i);
            DR06(count06,7) = gdp_interpolated_drifter.vn(i);
        case 07
            count07=count07+1;
            DR07(count07,1) = betterIDList(i);
            DR07(count07,2) = gdp_interpolated_drifter.longitude(i);
            DR07(count07,3) = gdp_interpolated_drifter.latitude(i);
            DR07(count07,4) = date_d(i);
            DR07(count07,5) = gdp_interpolated_drifter.temp(i);
            DR07(count07,6) = gdp_interpolated_drifter.ve(i);
            DR07(count07,7) = gdp_interpolated_drifter.vn(i);
        case 08
            count08=count08+1;
            DR08(count08,1) = betterIDList(i);
            DR08(count08,2) = gdp_interpolated_drifter.longitude(i);
            DR08(count08,3) = gdp_interpolated_drifter.latitude(i);
            DR08(count08,4) = date_d(i);
            DR08(count08,5) = gdp_interpolated_drifter.temp(i);
            DR08(count08,6) = gdp_interpolated_drifter.ve(i);
            DR08(count08,7) = gdp_interpolated_drifter.vn(i);
        case 09
            count09=count09+1;
            DR09(count09,1) = betterIDList(i);
            DR09(count09,2) = gdp_interpolated_drifter.longitude(i);
            DR09(count09,3) = gdp_interpolated_drifter.latitude(i);
            DR09(count09,4) = date_d(i);
            DR09(count09,5) = gdp_interpolated_drifter.temp(i);
            DR09(count09,6) = gdp_interpolated_drifter.ve(i);
            DR09(count09,7) = gdp_interpolated_drifter.vn(i);
        case 10
            count10=count10+1;
            DR10(count10,1) = betterIDList(i);
            DR10(count10,2) = gdp_interpolated_drifter.longitude(i);
            DR10(count10,3) = gdp_interpolated_drifter.latitude(i);
            DR10(count10,4) = date_d(i);
            DR10(count10,5) = gdp_interpolated_drifter.temp(i);
            DR10(count10,6) = gdp_interpolated_drifter.ve(i);
            DR10(count10,7) = gdp_interpolated_drifter.vn(i);
        case 11
            count11=count11+1;
            DR11(count11,1) = betterIDList(i);
            DR11(count11,2) = gdp_interpolated_drifter.longitude(i);
            DR11(count11,3) = gdp_interpolated_drifter.latitude(i);
            DR11(count11,4) = date_d(i);
            DR11(count11,5) = gdp_interpolated_drifter.temp(i);
            DR11(count11,6) = gdp_interpolated_drifter.ve(i);
            DR11(count11,7) = gdp_interpolated_drifter.vn(i);
        case 12
            count12=count12+1;
            DR12(count12,1) = betterIDList(i);
            DR12(count12,2) = gdp_interpolated_drifter.longitude(i);
            DR12(count12,3) = gdp_interpolated_drifter.latitude(i);
            DR12(count12,4) = date_d(i);
            DR12(count12,5) = gdp_interpolated_drifter.temp(i);
            DR12(count12,6) = gdp_interpolated_drifter.ve(i);
            DR12(count12,7) = gdp_interpolated_drifter.vn(i);
        case 13
            count13=count13+1;
            DR13(count13,1) = betterIDList(i);
            DR13(count13,2) = gdp_interpolated_drifter.longitude(i);
            DR13(count13,3) = gdp_interpolated_drifter.latitude(i);
            DR13(count13,4) = date_d(i);
            DR13(count13,5) = gdp_interpolated_drifter.temp(i);
            DR13(count13,6) = gdp_interpolated_drifter.ve(i);
            DR13(count13,7) = gdp_interpolated_drifter.vn(i);
        case 14
            count14=count14+1;
            DR14(count14,1) = betterIDList(i);
            DR14(count14,2) = gdp_interpolated_drifter.longitude(i);
            DR14(count14,3) = gdp_interpolated_drifter.latitude(i);
            DR14(count14,4) = date_d(i);
            DR14(count14,5) = gdp_interpolated_drifter.temp(i);
            DR14(count14,6) = gdp_interpolated_drifter.ve(i);
            DR14(count14,7) = gdp_interpolated_drifter.vn(i);
        case 15
            count15=count15+1;
            DR15(count15,1) = betterIDList(i);
            DR15(count15,2) = gdp_interpolated_drifter.longitude(i);
            DR15(count15,3) = gdp_interpolated_drifter.latitude(i);
            DR15(count15,4) = date_d(i);
            DR15(count15,5) = gdp_interpolated_drifter.temp(i);
            DR15(count15,6) = gdp_interpolated_drifter.ve(i);
            DR15(count15,7) = gdp_interpolated_drifter.vn(i);
        case 16
            count16=count16+1;
            DR16(count16,1) = betterIDList(i);
            DR16(count16,2) = gdp_interpolated_drifter.longitude(i);
            DR16(count16,3) = gdp_interpolated_drifter.latitude(i);
            DR16(count16,4) = date_d(i);
            DR16(count16,5) = gdp_interpolated_drifter.temp(i);
            DR16(count16,6) = gdp_interpolated_drifter.ve(i);
            DR16(count16,7) = gdp_interpolated_drifter.vn(i);
        case 17
            count17=count17+1;
            DR17(count17,1) = betterIDList(i);
            DR17(count17,2) = gdp_interpolated_drifter.longitude(i);
            DR17(count17,3) = gdp_interpolated_drifter.latitude(i);
            DR17(count17,4) = date_d(i);
            DR17(count17,5) = gdp_interpolated_drifter.temp(i);
            DR17(count17,6) = gdp_interpolated_drifter.ve(i);
            DR17(count17,7) = gdp_interpolated_drifter.vn(i);
        case 18
            count18=count18+1;
            DR18(count18,1) = betterIDList(i);
            DR18(count18,2) = gdp_interpolated_drifter.longitude(i);
            DR18(count18,3) = gdp_interpolated_drifter.latitude(i);
            DR18(count18,4) = date_d(i);
            DR18(count18,5) = gdp_interpolated_drifter.temp(i);
            DR18(count18,6) = gdp_interpolated_drifter.ve(i);
            DR18(count18,7) = gdp_interpolated_drifter.vn(i);
        case 19
            count19=count19+1;
            DR19(count19,1) = betterIDList(i);
            DR19(count19,2) = gdp_interpolated_drifter.longitude(i);
            DR19(count19,3) = gdp_interpolated_drifter.latitude(i);
            DR19(count19,4) = date_d(i);
            DR19(count19,5) = gdp_interpolated_drifter.temp(i);
            DR19(count19,6) = gdp_interpolated_drifter.ve(i);
            DR19(count19,7) = gdp_interpolated_drifter.vn(i);
    end
end

%% Place back into full array
for i = 1:1
    DRlists = cell(27,1);
    DRlists{1,1} = DR93;
    DRlists{2,1} = DR94;
    DRlists{3,1} = DR95;
    DRlists{4,1} = DR96;
    DRlists{5,1} = DR97;
    DRlists{6,1} = DR98;
    DRlists{7,1} = DR99;
    DRlists{8,1} = DR00;
    DRlists{9,1} = DR01;
    DRlists{10,1} = DR02;
    DRlists{11,1} = DR03;
    DRlists{12,1} = DR04;
    DRlists{13,1} = DR05;
    DRlists{14,1} = DR06;
    DRlists{15,1} = DR07;
    DRlists{16,1} = DR08;
    DRlists{17,1} = DR09;
    DRlists{18,1} = DR10;
    DRlists{19,1} = DR11;
    DRlists{20,1} = DR12;
    DRlists{21,1} = DR13;
    DRlists{22,1} = DR14;
    DRlists{23,1} = DR15;
    DRlists{24,1} = DR16;
    DRlists{25,1} = DR17;
    DRlists{26,1} = DR18;
    DRlists{27,1} = DR19;
end
%% Save arrays (chunked and full)
DRFull = cell(10,1);
DRFull{1,1} = betterIDList;
DRFull{2,1} = gdp_interpolated_drifter.longitude;
DRFull{3,1} = gdp_interpolated_drifter.latitude;
DRFull{4,1} = date_d;
DRFull{5,1} = gdp_interpolated_drifter.temp;
DRFull{6,1} = gdp_interpolated_drifter.ve;
DRFull{7,1} = gdp_interpolated_drifter.vn;
DRFull{8,1} = gdp_interpolated_drifter.err_temp;
DRFull{9,1} = gdp_interpolated_drifter.err_lat;
DRFull{10,1} = gdp_interpolated_drifter.err_lon;
save('DRByYearAS.mat', 'DRlists', 'DRFull');
%ID, Lon, Lat, Date

%% Test figure
years = 1993:2019;
for i = 1:27
    figure('units', 'normalized', 'outerposition', [0 0 1 1], 'visible', 'off')
    m_proj('mercator','lon',[40, 90],'lat',[-5 25])
    m_coast('patch',[.6 .6 .6]);
    m_grid('box','fancy','fontsize',27);
    hold on
    curryear = DRlists{i,1};
    x_d = curryear(:,2);
    y_d = curryear(:,3);
    m_scatter(x_d,y_d);
    title("Drifters in the AS in " + int2str(years(i)))
    F(i) = getframe(gcf);
end

video=VideoWriter('DrifterTestAS.mp4','MPEG-4'); %create the video object
video.FrameRate=1;%set video frame rate. number of frames per second. default is 30 frames per second
open(video); %open the file for writing
%for dday=3:length(filedir) %where N is the number of images
for i = 1:27
    writeVideo(video,F(i)); %write the image to file
end
close(video); %close the file
disp('finished');