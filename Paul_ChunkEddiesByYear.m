%% Paul_ChunkEddiesByYear.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Chunks trajectory files into individual years (1993-->2019)
%Inputs: .mat files for Filtered Trajectories.
%Outputs: .mat files (AEByYear and CEByYear) corresponding to the eddy type
%% Inputs
addpath('/Volumes/Lacie-SAN/SAN2/Paul_Eddies/Eddy_Tracking/EXTRACTION/EDDY_TRAJECTORIES')
load('CE_Filtered_Trajectories.mat')
load('AE_Filtered_Trajectories.mat')
%% Filtering for year of propagation, 1993-->2019, AE
date_a=AE_traj(:,14);
count93=0;count94=0;count95=0; count96=0;count97=0;count98=0;count99=0;
count00=0;count01=0;count02=0;count03=0;count04=0;count05=0;
count06=0;count07=0;count08=0;count09=0;count10=0;count11=0;
count12=0;count13=0;count14=0;count15=0;count16=0;count17=0;
count18=0;count19=0;
for i=1:length(AE_traj)
    date=date_a{i,1};
    date2=datestr(date);
    date2str=date2(1,10:11);
    date2use=str2double(date2str);
    switch date2use
        case 93
            count93=count93+1;
            AE93(count93,1:21) = AE_traj(i,1:21);
        case 94
            count94=count94+1;
            AE94(count94,1:21) = AE_traj(i,1:21);
        case 95
            count95=count95+1;
            AE95(count95,1:21) = AE_traj(i,1:21);
        case 96
            count96=count96+1;
            AE96(count96,1:21) = AE_traj(i,1:21);
        case 97
            count97=count97+1;
            AE97(count97,1:21) = AE_traj(i,1:21);
        case 98
            count98=count98+1;
            AE98(count98,1:21) = AE_traj(i,1:21);
        case 99
            count99=count99+1;
            AE99(count99,1:21) = AE_traj(i,1:21);
        case 00
            count00=count00+1;
            AE00(count00,1:21) = AE_traj(i,1:21);
        case 01
            count01=count01+1;
            AE01(count01,1:21) = AE_traj(i,1:21);
        case 02
            count02=count02+1;
            AE02(count02,1:21) = AE_traj(i,1:21);
        case 03
            count03=count03+1;
            AE03(count03,1:21) = AE_traj(i,1:21);
        case 04
            count04=count04+1;
            AE04(count04,1:21) = AE_traj(i,1:21);
        case 05
            count05=count05+1;
            AE05(count05,1:21) = AE_traj(i,1:21);
        case 06
            count06=count06+1;
            AE06(count06,1:21) = AE_traj(i,1:21);
        case 07
            count07=count07+1;
            AE07(count07,1:21) = AE_traj(i,1:21);
        case 08
            count08=count08+1;
            AE08(count08,1:21) = AE_traj(i,1:21);
        case 09
            count09=count09+1;
            AE09(count09,1:21) = AE_traj(i,1:21);
        case 10
            count10=count10+1;
            AE10(count10,1:21) = AE_traj(i,1:21);
        case 11
            count11=count11+1;
            AE11(count11,1:21) = AE_traj(i,1:21);
        case 12
            count12=count12+1;
            AE12(count12,1:21) = AE_traj(i,1:21);
        case 13
            count13=count13+1;
            AE13(count13,1:21) = AE_traj(i,1:21);
        case 14
            count14=count14+1;
            AE14(count14,1:21) = AE_traj(i,1:21);
        case 15
            count15=count15+1;
            AE15(count15,1:21) = AE_traj(i,1:21);
        case 16
            count16=count16+1;
            AE16(count16,1:21) = AE_traj(i,1:21);
        case 17
            count17=count17+1;
            AE17(count17,1:21) = AE_traj(i,1:21);
        case 18
            count18=count18+1;
            AE18(count18,1:21) = AE_traj(i,1:21);
        case 19
            count19=count19+1;
            AE19(count19,1:21) = AE_traj(i,1:21);
    end
end
%% Filtering for year of propagation, 1993-->2019, CE
date_c=CE_traj(:,14);
count93=0;count94=0;count95=0; count96=0;count97=0;count98=0;count99=0;
count00=0;count01=0;count02=0;count03=0;count04=0;count05=0;
count06=0;count07=0;count08=0;count09=0;count10=0;count11=0;
count12=0;count13=0;count14=0;count15=0;count16=0;count17=0;
count18=0;count19=0;
for i=1:length(CE_traj)
    date=date_c{i,1};
    date2=datestr(date);
    date2str=date2(1,10:11);
    date2use=str2double(date2str);
    switch date2use
        case 93
            count93=count93+1;
            CE93(count93,1:21) = CE_traj(i,1:21);
        case 94
            count94=count94+1;
            CE94(count94,1:21) = CE_traj(i,1:21);
        case 95
            count95=count95+1;
            CE95(count95,1:21) = CE_traj(i,1:21);
        case 96
            count96=count96+1;
            CE96(count96,1:21) = CE_traj(i,1:21);
        case 97
            count97=count97+1;
            CE97(count97,1:21) = CE_traj(i,1:21);
        case 98
            count98=count98+1;
            CE98(count98,1:21) = CE_traj(i,1:21);
        case 99
            count99=count99+1;
            CE99(count99,1:21) = CE_traj(i,1:21);
        case 00
            count00=count00+1;
            CE00(count00,1:21) = CE_traj(i,1:21);
        case 01
            count01=count01+1;
            CE01(count01,1:21) = CE_traj(i,1:21);
        case 02
            count02=count02+1;
            CE02(count02,1:21) = CE_traj(i,1:21);
        case 03
            count03=count03+1;
            CE03(count03,1:21) = CE_traj(i,1:21);
        case 04
            count04=count04+1;
            CE04(count04,1:21) = CE_traj(i,1:21);
        case 05
            count05=count05+1;
            CE05(count05,1:21) = CE_traj(i,1:21);
        case 06
            count06=count06+1;
            CE06(count06,1:21) = CE_traj(i,1:21);
        case 07
            count07=count07+1;
            CE07(count07,1:21) = CE_traj(i,1:21);
        case 08
            count08=count08+1;
            CE08(count08,1:21) = CE_traj(i,1:21);
        case 09
            count09=count09+1;
            CE09(count09,1:21) = CE_traj(i,1:21);
        case 10
            count10=count10+1;
            CE10(count10,1:21) = CE_traj(i,1:21);
        case 11
            count11=count11+1;
            CE11(count11,1:21) = CE_traj(i,1:21);
        case 12
            count12=count12+1;
            CE12(count12,1:21) = CE_traj(i,1:21);
        case 13
            count13=count13+1;
            CE13(count13,1:21) = CE_traj(i,1:21);
        case 14
            count14=count14+1;
            CE14(count14,1:21) = CE_traj(i,1:21);
        case 15
            count15=count15+1;
            CE15(count15,1:21) = CE_traj(i,1:21);
        case 16
            count16=count16+1;
            CE16(count16,1:21) = CE_traj(i,1:21);
        case 17
            count17=count17+1;
            CE17(count17,1:21) = CE_traj(i,1:21);
        case 18
            count18=count18+1;
            CE18(count18,1:21) = CE_traj(i,1:21);
        case 19
            count19=count19+1;
            CE19(count19,1:21) = CE_traj(i,1:21);
    end
end
%% Place all AE/CE in one array
for i = 1:1
    AElists = cell(27,1);
    AElists{1,1} = AE93;
    AElists{2,1} = AE94;
    AElists{3,1} = AE95;
    AElists{4,1} = AE96;
    AElists{5,1} = AE97;
    AElists{6,1} = AE98;
    AElists{7,1} = AE99;
    AElists{8,1} = AE00;
    AElists{9,1} = AE01;
    AElists{10,1} = AE02;
    AElists{11,1} = AE03;
    AElists{12,1} = AE04;
    AElists{13,1} = AE05;
    AElists{14,1} = AE06;
    AElists{15,1} = AE07;
    AElists{16,1} = AE08;
    AElists{17,1} = AE09;
    AElists{18,1} = AE10;
    AElists{19,1} = AE11;
    AElists{20,1} = AE12;
    AElists{21,1} = AE13;
    AElists{22,1} = AE14;
    AElists{23,1} = AE15;
    AElists{24,1} = AE16;
    AElists{25,1} = AE17;
    AElists{26,1} = AE18;
    AElists{27,1} = AE19;
end
for i = 1:1
    CElists = cell(27,1);
    CElists{1,1} = CE93;
    CElists{2,1} = CE94;
    CElists{3,1} = CE95;
    CElists{4,1} = CE96;
    CElists{5,1} = CE97;
    CElists{6,1} = CE98;
    CElists{7,1} = CE99;
    CElists{8,1} = CE00;
    CElists{9,1} = CE01;
    CElists{10,1} = CE02;
    CElists{11,1} = CE03;
    CElists{12,1} = CE04;
    CElists{13,1} = CE05;
    CElists{14,1} = CE06;
    CElists{15,1} = CE07;
    CElists{16,1} = CE08;
    CElists{17,1} = CE09;
    CElists{18,1} = CE10;
    CElists{19,1} = CE11;
    CElists{20,1} = CE12;
    CElists{21,1} = CE13;
    CElists{22,1} = CE14;
    CElists{23,1} = CE15;
    CElists{24,1} = CE16;
    CElists{25,1} = CE17;
    CElists{26,1} = CE18;
    CElists{27,1} = CE19;
end
%% Save arrays
save('AEByYear.mat', 'AElists');
save('CEByYear.mat', 'CElists');
%% 