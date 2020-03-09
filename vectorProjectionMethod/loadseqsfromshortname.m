function specSeq = loadseqsfromshortname(fileNames)
% load spectrum sequences from cell fileNames
% 
% Inputs:
% fileNames: a cell of short names of normalized spectrum
%
% Outputs:
% specSeq: 
specSeq = struct;
for i = 1:length(fileNames)
    dir1 = dir([fileNames{i},'*nml*']);
    if isempty(dir1)
        error(['Invalid short file name: ',fileNames{i}]);
    end
    load(dir1.name);
    specSeq = setfield(specSeq,fileNames{i},sgnl);
end

end

