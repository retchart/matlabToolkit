function newSpec = addGaussbroaden( spec,method,a,b,c )
% 为能谱增加高斯展宽
%
% INPUTS:
% spec: 双列能谱，第一列MeV能量，第二列计数
% method：1.平滑展宽 2.抽样（要求spec第二列为自然数）
% a,b,c: parameters in FWHM=a+b*sqrt(E+cE^2)
%        林谦老师ppt推荐NaI：a=0.01 b=0.05 c=0.4
%
% OUTPUS:
% newspec: 第一列MeV能量，第二列计数

newSpec = [spec(:,1),zeros(size(spec,1),1)];
energyStep = spec(2,1)-spec(1,1);
countcut = sum(spec(:,2))/(size(spec,1)^2); % countcut: 小于多少的数视为0
if method == 1 % 平滑展宽
    for i = 1:size(spec,1)
        if spec(i,2) == 0
            continue;
        end
        fwhm = a+b*sqrt(spec(i,1)+c*spec(i,1)^2);
        sigma = 0.42466*fwhm; % sigma = fwhm/(2*sqrt(2*ln2))
        thisResponse = zeros(size(newSpec,1),1);
        jFirst = norminv(countcut/sum(spec(:,2)),spec(i,1),sigma);
        jFirst = max([sum(spec(:,1)<jFirst),1]);
        jFlag = 0;
        for j = jFirst:size(newSpec,1)
            if j == 1
                thisResponse(1,1) = spec(i,2)* ...
                    (normcdf(newSpec(1,1),spec(i,1),sigma) - normcdf(0,spec(i,1),sigma));
            else
                thisResponse(j,1) = spec(i,2)* ...
                    (normcdf(newSpec(j,1),spec(i,1),sigma)-normcdf(newSpec(j-1,1),spec(i,1),sigma));
            end
            if thisResponse(j,1)>countcut
                jFlag = 1;
            end
            if thisResponse(j,1)<countcut && jFlag ==1
                break;
            end
        end
        % disp([num2str(i),'/',num2str(size(spec,1))]);
        %         for j = 1:size(newSpec,1)
        %             thisResponse(j,1) = spec(i,2)*energyStep* ...
        %                 exp(-((newSpec(j,1)-spec(i,1))/(sqrt(2)*sigma))^2)/(sigma*sqrt(2*pi));
        %         end
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
