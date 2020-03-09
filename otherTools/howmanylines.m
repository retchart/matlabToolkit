function nLine = howmanylines(fileName)
% return number of lines in file
% 
% Inputs:
% fileName
%
% Outputs:
% nLines: number of lines
% 
% 
if ispc
    [~,cmdout] = system(['find /v /c "" ',fileName]);
    ms = isstrprop(cmdout,'digit');
    flag = 0;
    for i = length(ms)-1:-1:1
        if ms(i)==0 && ms(i+1)==1
            flag = 1;
        end
        if flag 
            ms(i) = 0;
        end
    end
else
    [~,cmdout] = system(['wc -l ',fileName]);
    ms = isstrprop(cmdout,'digit');
    flag = 0;
    for i = 2:size(cmdout)
        if ms(i-1)==1 && ms(i)==0
            flag = 1;
        end
        if flag 
            ms(i) = 0;
        end
    end
end
% ms = isstrprop(cmdout,'digit');
% ms = regexp(cmdout,'(?<=\w+)\d+','match');
nLine = str2num(cmdout(ms));
end

