function netArea = getnet(s,pk,method)
% 计算能谱s中pk指示的峰区计数
% INPUTS：
%    s： 单列能谱
%    pk：峰所在的道址
%
% OUTPUTS：
%    netArea:峰净计数

switch method
    case 1
        LL = pk-55;
        HH = pk+55;
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL),s(HH)]);
    case 2
        % 寻找谷底
        LL = pk-3;
        HH = pk+3;
        for i = 0:10
            if s(pk-i-1)>=s(pk-i)
                LL = pk-i;
                break;
            end
        end
        for i = 0:10
            if s(pk+i+1)>=s(pk+i)
                HH = pk+i;
                break;
            end
        end
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL),s(HH)]);
    case 3
        roi=[pk-30:pk+30];
        [netArea,~,~,~,~] = fitPeak(roi,s(roi),0);
    otherwise
        
        
end

