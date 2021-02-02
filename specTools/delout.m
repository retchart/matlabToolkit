function [] = delout(FILE_NAME)
OUTLIER_THRESHOLD = 3; % times of variance out which the dots are regard as outlier
ACC_STABLE_TIMESTAMP = 150;

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
ROI_SELECTED = {'Cl35a','Cl35b','Cl35c'};

% Keep ROIs in ROI_SELECTED
nameTmp = fieldnames(ROI);
for i = 1:length(nameTmp)
    if ~ismember(nameTmp{i},ROI_SELECTED)
        ROI = rmfield(ROI,nameTmp{i});
        ROI_TITLE = rmfield(ROI_TITLE,nameTmp{i});
    end
end
ROI = orderfields(ROI);

sgnl = loadnormalizedseq(FILE_NAME);
if isequal(sgnl,1)
    error('Error: Normalized sample file can not be read');
end

sgnl = deleteoutlier(sgnl,ACC_STABLE_TIMESTAMP,ROI,OUTLIER_THRESHOLD,0);
save([FILE_NAME,'-delo.mat'],'sgnl');
end