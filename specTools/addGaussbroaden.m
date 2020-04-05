function newSpec = addGaussbroaden( spec,method,countcut,a,b,c )
% 为能谱增加高斯展宽
%
% INPUTS:
% spec: 双列能谱，第一列MeV能量，第二列计数
% method：1.平滑展宽 2.抽样（要求spec第二列为自然数）
% countcut: 小于多少的数视为0
% a,b,c: parameters in FWHM=a+b*sqrt(E+cE^2)
%        林谦老师ppt推荐NaI：a=0.01 b=0.05 c=0.4
%
% OUTPUS:
% newspec: 第一列MeV能量，第二列计数

newSpec = [spec(:,1),zeros(size(spec,1),1)];
energyStep = spec(2,1)-spec(1,1);
if method == 1 % 平滑展宽
    for i = 1:size(spec,1)
        fwhm = a+b*sqrt(spec(i,1)+c*spec(i,1)^2);
        sigma = 0.42466*fwhm; % sigma = fwhm/(2*sqrt(2*ln2))
        thisResponse = zeros(size(newSpec,1),1);
        for j = 1:size(newSpec,1)
            thisResponse(j,1) = spec(i,2)*energyStep* ...
                exp(-((newSpec(j,1)-spec(i,1))/(sqrt(2)*sigma))^2)/(sigma*sqrt(2*pi));
        end
        newSpec(:,2) = newSpec(:,2)+thisResponse;
    end
    newSpec(find(newSpec(:,2)<countcut),2) = 0;
elseif method == 2 % 抽样
    spec(:,2) = round(spec(:,2));
    for i = 1:size(spec,1)
        fwhm = a+b*sqrt(spec(i,1)+c*spec(i,1)^2);
        sigma = 0.42466*fwhm; % sigma = fwhm/(2*sqrt(2*ln2))
        for j = 1:spec(i,2)
            pos = norminv(rand,spec(i,1)+0.5*energyStep,sigma);
            if pos < newSpec(1,1)
                pos = newSpec(1,1);
            end
            chch = sum(spec(:,1)<=pos);
            newSpec(chch,2) = newSpec(chch,2) + 1;
        end
    end
end
