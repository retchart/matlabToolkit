close all;
sumCh = 16;
fileName = '2-NaI-potato-1kg.Spe';
specStartStr = '$DATA:';
fid = fopen(fileName,'r');
for i =1:2100
    dataRow = fgetl(fid);
    if strncmp(dataRow,specStartStr,6)
        specStartRow = i;
        break;
    end
end
fclose(fid);
fileData = importdata(fileName,'',specStartRow+1);
originalSpec = fileData.data;% 无刻度单列能谱

for i=1:(size(originalSpec,1)/sumCh)
    spec(i,1)=sum(originalSpec((sumCh*i-sumCh+1):sumCh*i,1));
end
semilogy(spec,'o-');
