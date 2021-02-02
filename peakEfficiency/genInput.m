function  genInput(tplt,work,energy,nps)
% energyΪnum
% npsΪnum
fidtplt = fopen(tplt);
fid = fopen(work,'w+');
while 1
    str = fgetl(fidtplt);
    if str ==-1
        break;
    else
        newstr = strrep(str,'[ene]',num2str(energy));
        newstr = strrep(newstr,'[nps]',num2str(nps));
        fprintf(fid,[newstr,'\r\n']);
    end
end
fclose(fidtplt);fclose(fid);
end