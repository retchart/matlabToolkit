function [spec,specFirstRowNo] = load1mcnpoutputfile(fileName,specStartLineSymbol)
% Acquire the first energy spectrum from mcnp output file 
% following specStartLineSymbol
%
% Inputs:
% fileName: MCNP output file name
% specStartLineSymbol: which line is considered to be the n-2 line of spec
%                      typicaly,n-1 line only have a word 'energy'
%
%
% Outputs:
% spec: original spectrum data from ".spe" file;
% specFirstRowNo: number of the first line of spectrum data
%
% Examples:
% specStartLineSymbol=' cell  4'
% specStartLineSymbol=' surface  4.3'
%
% Author: yxtccty
% Date: 2020MAR01

suffixs = {'.o','.O'};

if ~contains(fileName,suffixs)
    fileName = [fileName,'.o'];
end
fid = fopen(fileName,'r');
if fid == -1
    spec = -1;
    specFirstRowNo = -1;
    return;
end

for i = 1:howmanylines(fileName)
    dataRow = fgetl(fid);
    if strncmp(dataRow,specStartLineSymbol,length(specStartLineSymbol))
        specFirstRowNo = i+2;
        break;
    end
end

d = importdata(fileName,' ',specFirstRowNo-1);
spec = d.data;
fclose(fid);

end % of function
