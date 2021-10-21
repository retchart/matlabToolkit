function [eff,err] = readOutput(fileName,lineNo)
fidin = fopen(fileName);
for i=1:lineNo-1
    fgetl(fidin);
end
dataRow = str2double(regexp(fgetl(fidin),'\s+','split'));
eff=dataRow(1,2);
err=dataRow(1,3);
fclose(fidin);

end
