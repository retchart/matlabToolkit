clear;close all;
FILE_NAMES_BKGD = {'P00-step0.01MeV-nml'};
FILE_NAMES_SMPL = {'P23-step0.01MeV-nml'};%;'P13';'P15';'P21';'P22';'P23';'P24';'P25';'P31';'P33';'P35'};
ENERGY_AXIS = [0.01:0.01:12]';
OUTLIER_THRESHOLD = 3; % times of variance out which the dots are regard as outlier
ACC_STABLE_TIMESTAMP = 150;

ROI.Cl35a = [195-15,195+15]; % Channel in normalized spectrum
ROI.Cl35b = [611-15,611+15];
ROI.Cl35c = [662-15,662+15];
ROI_TITLE.Cl35a = '1.959MeV';
ROI_TITLE.Cl35b = '6.111MeV';
ROI_TITLE.Cl35c = '6.620MeV';

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
TEST_DETECTION_TIME = [1,2,5,10,30]; % Unit: detection time of one ".spe" file
TEST_DETECTION_TIME = 1:30;
TEST_COMBINED_CHANNEL = 1:20;
TEST_COMBINED_CHANNEL = [1,2,3,4,6,10,20,30,40,60,100,200,300,400,600,1200];
N_ROC_POINT = 500;


specSeq_bkgd = loadseqsfromshortname(FILE_NAMES_BKGD);
specSeq_smpl = loadseqsfromshortname(FILE_NAMES_SMPL);

% Delete outliers
for iSeq = 1:size(fields(specSeq_smpl),1)
    thisSeq = getfield(specSeq_smpl,FILE_NAMES_SMPL{iSeq});
    thisSeq = deleteoutlier(thisSeq,ACC_STABLE_TIMESTAMP,ROI,OUTLIER_THRESHOLD,0);
    specSeq_smpl = setfield(specSeq_smpl,FILE_NAMES_SMPL{iSeq},thisSeq);
end
for iSeq = 1:size(fields(specSeq_bkgd),1)
    thisSeq = getfield(specSeq_bkgd,FILE_NAMES_BKGD{iSeq});
    thisSeq = deleteoutlier(thisSeq,ACC_STABLE_TIMESTAMP,ROI,OUTLIER_THRESHOLD,0);
    specSeq_bkgd = setfield(specSeq_bkgd,FILE_NAMES_BKGD{iSeq},thisSeq);
end


aucChTimeMap = zeros(length(TEST_COMBINED_CHANNEL),length(TEST_DETECTION_TIME));
for iTime = 1:length(TEST_DETECTION_TIME)
    for iCh = 1:length(TEST_COMBINED_CHANNEL)
        % Which two seq are used to form fisher vector
        fisherBKGDseq = combinespectra(specSeq_bkgd.Aug4,TEST_DETECTION_TIME(1),TEST_COMBINED_CHANNEL(iCh));
        fisherSMPLseq = combinespectra(specSeq_smpl.P21,TEST_DETECTION_TIME(1),TEST_COMBINED_CHANNEL(iCh));
        fisherVec = myfisher(fisherBKGDseq,fisherSMPLseq);
        
        % Which two seq are used to analysis auc
        thisBKGDseq = combinespectra(specSeq_bkgd.Aug4,TEST_DETECTION_TIME(iTime),TEST_COMBINED_CHANNEL(iCh));
        thisSMPLseq = combinespectra(specSeq_smpl.P21,TEST_DETECTION_TIME(iTime),TEST_COMBINED_CHANNEL(iCh));
        [~,aucChTimeMap(iCh,iTime)] = estimatevector(thisBKGDseq,thisSMPLseq,fisherVec);
        disp(['iTime=',num2str(iTime),'/',num2str(length(TEST_DETECTION_TIME)), ...
            ' iCh=',num2str(iCh),'/',num2str(length(TEST_COMBINED_CHANNEL))]);
    end
end