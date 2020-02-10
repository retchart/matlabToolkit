function nmlSeq = loadnormalizedseq(fileName)
% Discription see the code
%
if contains(fileName,'eV-nml')
    load([fileName,'.mat'],'sgnl');
    nmlSeq = sgnl;
else
    nmlSeq = -1;
end

end
