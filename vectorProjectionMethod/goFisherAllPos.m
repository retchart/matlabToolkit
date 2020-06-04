%% Fisher vector processes all positions' data
%% 0. Setting parameters 

clear;close all;

N_ROC_POINT = 500;
ENERGY_AXIS = [0.01:0.01:12]';
OUTLIER_THRESHOLD = 3; % times of variance out which the dots are regard as outlier
ACC_STABLE_TIMESTAMP = 150;
TEST_DETECTION_TIME = [1,2,5,10,30]; % Unit: detection time of one ".spe" file
COMBINED_CH = (1:1200)'; % how many channels are combined when trying Fisher method
COMBINED_CH = COMBINED_CH(mod(1200,COMBINED_CH)==0);
ROI.Cl35a = [195-15,195+15]; % Channel in normalized spectrum
ROI.Cl35b = [611-15,611+15];
ROI.Cl35c = [662-15,662+15];
ROI.N14a = [1083-15,1083+15];
ROI.N14a1 = [1083-15,1083+15];
ROI.N14b = [527-15,527+15];
ROI.TEST = [1125,1125];
ROI_TITLE.Cl35a = '1.959MeV';
ROI_TITLE.Cl35b = '6.111MeV';
ROI_TITLE.Cl35c = '6.620MeV';
ROI_TITLE.N14a = '10.829MeV';
ROI_TITLE.N14a1 = '10.829MeV';
ROI_TITLE.N14b = '5.269MeV';
ROI_TITLE.TEST = 'test';
%% 
% Defined ROI(s): 
% 
% Cl35a: 1950keV¡À150keV;
% 
% Cl35b: 6110keV¡À150keV;
% 
% Cl35c: 6620keV¡À150keV;
% 
% NOTICE: The titles and x/y labels of following figures show what ROIs are 
% used. 

ROI_SELECTED = {'Cl35b','Cl35c'};

% Keep ROIs in ROI_SELECTED
nameTmp = fieldnames(ROI);
for i = 1:length(nameTmp)
    if ~ismember(nameTmp{i},ROI_SELECTED)
        ROI = rmfield(ROI,nameTmp{i});
        ROI_TITLE = rmfield(ROI_TITLE,nameTmp{i});
    end
end
ROI = orderfields(ROI);
ROI_TITLE = orderfields(ROI_TITLE);
ROI_NAMES = fieldnames(ROI_TITLE);
%% 1. Import data and data pre-processing 
% 1.1 Import data
% Spectra should be normalized in advance.

bkgd = loadnormalizedseq('Aug6-0kg-step0.01MeV-nml');
smpl_P{1,1} = loadnormalizedseq('P11-1kg-step0.01MeV-nml');
smpl_P{1,2} = loadnormalizedseq('P13-1kg-step0.01MeV-nml');
smpl_P{2,1} = loadnormalizedseq('P21-1kg-step0.01MeV-nml');
smpl_P{2,2} = loadnormalizedseq('P23-1kg-step0.01MeV-nml');
smpl_P{3,1} = loadnormalizedseq('P31-1kg-step0.01MeV-nml');
smpl_P{3,2} = loadnormalizedseq('P33-1kg-step0.01MeV-nml');
% 1.2 Pre-processing
% Delete the outliers in the spectra sequences. Counts of the spectra's sum 
% and of the ROI sum are used and illustrated.

bkgd = deleteoutlier(bkgd,ACC_STABLE_TIMESTAMP,ROI,OUTLIER_THRESHOLD,0);
for i = 1:3
    for j = 1:2
        smpl_P{i,j} = deleteoutlier(smpl_P{i,j},ACC_STABLE_TIMESTAMP,ROI,OUTLIER_THRESHOLD,0);
    end
end

%% 2. Fisher vector method
% Variables that influence the AUC, which we want to show:
% 
% 1)Detection time, 2) Fisher vector from which drug place, 3)Count of channel 
% of Fisher vector, 4)AUC of different drug place

sampleName = {'P12','P22','P32','P13','P23','P33'};
for iTime = 1:length(TEST_DETECTION_TIME)
    thisTime = TEST_DETECTION_TIME(iTime);
    figure;
    for colcol = 1:2
        for rowrow = 1:3
            subplot(3,2,colcol+rowrow*2-2);
            [aucList{iTime,rowrow,colcol},~] = aucList_v1(bkgd,smpl_P,[rowrow,colcol],sampleName,COMBINED_CH,thisTime,0);
        end
    end
end
save('aucDataMessPack_all_time.mat');
