function [spec,specFirstRowNo] = load1spe(varargin)
% Acquire energy spectrum from ".spe" file
% 
% Inputs:
% varargin(1): speFileName: ".spe" file name
% varargin(2): first spectrum line No. (Line number of "$DATA:" plus 2)
%
% Outputs:
% spec: original spectrum data from ".spe" file;
%       -1: ".spe" file can not be read or
%       -2: ".spe" do not contain "$DATA"
% specFirstRowNo: number of the first line of spectrum data
% 
% Author: yxtccty
% Date: 2020FEB10

specStartLineSymbol = '$DATA:'; % spec head
suffixs = {'.spe','.Spe','.SPE'};
fileName = varargin{1};

if contains(varargin{1},suffixs)
    fid = fopen(varargin{1},'r');
else
    fid = fopen([fileName,'.spe'],'r');
end
if fid == -1
    spec = -1;
    specFirstRowNo = -1;
    return;
end
if nargin == 1 % found specStartStr automatically
    i = 1;
    while 1
        dataRow = fgetl(fid);
        if strncmp(dataRow,specStartLineSymbol,length(specStartLineSymbol))
            specFirstRowNo = i+2;
            break;
        end
        if i == 100 % Assume spec head can be found in first 100 rows
            spec = -2;
            specFirstRowNo = 1;
            return;
        end
        i = i+1;
    end
elseif nargin == 2 % varargin{2} is spec head
    specFirstRowNo = varargin{2};
end
d = importdata(varargin{1},'',specFirstRowNo-1);
spec = d.data;
fclose(fid);

end % of function load1spefile
