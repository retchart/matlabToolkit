close all;fclose all;clear;
delete('*.i');delete('*.o');
energyList = (0.1:0.1:12)';

nps = 1e8;
effCurve = zeros(size(energyList,1),3);
effCurve(:,1)=energyList;

spec = zeros(12/0.01,length(energyList)); % col number from input file "e0"
specErr = zeros(12/0.01,length(energyList));
for i = 1:size(energyList,1)
    disp('---------------------------------------------');
    disp(['Current: ',num2str(energyList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(energyList,1)),')']);
    workName = [num2str(i),'.i'];
    genInput('tplt.tplt',workName,energyList(i,1),nps);
    % disp(['MCNP start: ',datestr(now)]);
    if isunix
        [~,~]=system(['mpirun.lsf mcnp5.mpi.impi_intel i=',num2str(i), ...
            '.i o=',num2str(i),'.o r=',num2str(i),'.r p=',num2str(i),'.p']);
    else
        [~,~]=system(['mcnp5 i=',num2str(i),'.i o=',num2str(i),'.o r=', ...
            num2str(i),'.r p=',num2str(i),'.p']);
    end
    % disp(['MCNP finish: ',datestr(now)]);
    %     [eff,err] = readOutput([num2str(i),'.o'],146);
    %     effCurve(i,2) = eff;
    %     effCurve(i,3) = err;
    [thisSpec,~] = load1mcnpoutputfile([num2str(i),'.o'],' cell  1');
    spec(:,i) = thisSpec(:,2);
    specErr(:,i) = thisSpec(:,3);
    disp(['Success: ',num2str(energyList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(energyList,1)),')']);
    delete([num2str(i),'.r']);
    save('effResult');
    % disp(['Success: ',datestr(now)]);
end
energyAxis = thisSpec(:,1);
save('effResult');
disp('==========Project done=============');

