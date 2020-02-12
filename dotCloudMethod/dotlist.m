function dots = dotlist(specSeq,detectionTime,ROI)
% Convert every spectrum measured in detectionTime
% into one dot in n-dimension where n is the count of ROIs
%
% Inputs:
% specSeq: normalized spectra sequence, each column is a spectrum
% detectionTime: How many spectrums should be summed to form a spectrum
%                measure for longer time
% ROI: each element is the up and low boundary of ROI
%
% Outputs:
% dots: each col is a point in n-dimension space
%
seqSum = []; % sum of spectrum
for i = 1:floor(size(specSeq,2)/detectionTime)
    seqSum = [seqSum,sum(specSeq(:,detectionTime*(i-1)+1:detectionTime*i),2)];
end

ROInames = fields(ROI);
for i = 1:length(ROInames)
    thisRange = getfield(ROI,ROInames{i});
    dots(i,:) = sum(seqSum(thisRange(1):thisRange(2),:),1);
end

end % of the function

