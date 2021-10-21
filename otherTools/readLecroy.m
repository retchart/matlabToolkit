function [waves,tAxis]=readLecroy(maindir,nameForm,prefix,maxWavNo)
% 读取Lecroy示波器储存的多个.trc二进制文件波形
% INPUT:
%     maindir: 文件夹名称
%     nameForm: 读取的文件正则表达式，如"C2*.trc"
%     prefix: 保存名称
%     maxWavNo: 最大读取多少个波形
% OUTPUT:
%     waves: 每一列为一个波形，单位V
%     tAxis: 时间轴
    t1=cputime;
    path = pwd;
    addpath(pwd);
    cd (maindir);
    subdir = dir(nameForm);
    %dT=subdir(end).date-subdir(1).date;
    %samTime=dT(end)+dT(end-1)*10+dT(end-3)*60+dT(end-4)*600+dT(end-6)*3600+dT(end-7)*36000;
    wave = ReadLeCroyBinaryWaveform(subdir(1).name);
    tAxis = wave.x;
    waves=zeros(length(wave.y),min([length(subdir),maxWavNo]));
    for i=1:min([length(subdir),maxWavNo])
        disp([num2str(i),'/',num2str(maxWavNo),'/total:',num2str(length(subdir))])
        thisName=subdir(i).name;
        wave=ReadLeCroyBinaryWaveform(thisName);
        data=wave.y;
        %data=data-mean(data(1:50));
        waves(:,i)=data;
    end
    cd (path);
    fprintf('-------Saving data-------\n');
    save(['wave_',prefix,'_',maindir,'.mat'],'waves','tAxis','-v7.3');
    fprintf('**** finish all after %.3f s ****\n',cputime-t1);
end