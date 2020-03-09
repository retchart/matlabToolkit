function seq = combinespectra(specSeq,nTime,nCh)
% Combine n spctra(columns) together to form a new spectrum sequence
%
% Inputs:
% specSeq: Each column is a spectrum
% nTime: How many 1s spectra should be combined together
% nCh: How many neighbor channel should be combined together
%
% Outputs:
% seq: new Spectrum sequence

seq_time = []; % combine of spectrum
for i = 1:nTime:(size(specSeq,2)-nTime+1)
    seq_time = [seq_time,sum(specSeq(:,i:i+nTime-1),2)];
end

seq = [];
for i = 1:nCh:(size(seq_time,1)-nCh+1)
    seq = [seq;sum(seq_time(i:i+nCh-1,:),1)];
end


end

