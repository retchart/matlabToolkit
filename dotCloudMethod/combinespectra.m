function seq = combinespectra(specSeq,n)
% Combine n spctra(columns) together to form a new spectrum sequence
%
% Inputs:
% specSeq: Each column is a spectrum
% n: How many spectra should be combined together
%
% Outputs:
% seq: new Spectrum sequence

seq = []; % combine of spectrum
for i = 1:floor(size(specSeq,2)/n)
    seq = [seq,sum(specSeq(:,n*(i-1)+1:n*i),2)];
end

end

