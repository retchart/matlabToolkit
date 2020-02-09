function distance = p2pdistance(pos1,pos2,pos3)
% distance为pos1和pos2的距离
% 若pos1在pos2的pos3侧，符号为‘+’；在另一侧符号为‘-’
distance = zeros(size(pos1,1),1);
for i = 1:size(pos1,1)
    distance(i,1) = sqrt((pos1(i,1)-pos2(1,1))^2+(pos1(i,2)-pos2(1,2))^2);
    if distance(i,1)==0
        continue;
    end
    vec2 = pos1(i,1:2)-pos2(1,1:2);k2=vec2(1,2)/vec2(1,1);
    vec3 = pos1(i,1:2)-pos3(1,1:2);k3=vec3(1,2)/vec3(1,1);
    if ~isequal(pos2,pos3) % pos2和pos3不一致
        flag1 = vec2*vec3';flag2=vec2*vec2';flag3=vec3*vec3';
        if flag1>0 && flag2<flag3 %同向且pos1与pos3在pos2两侧
            distance(i,1) = -distance(i,1);
        end
        clear flag1 flag2 flag3;
    else % pos2和pos3一致
        %vec2在(第2，第3]象限时distance符号为'-'
        if vec2(1,1)<0
            distance(i,1) = -distance(i,1);
        end
        if vec2(1,2)<0
            distance(i,1) = -distance(i,1);
        end
    end
end
end
