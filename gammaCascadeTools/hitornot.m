function hitFlag = hitornot(P0,v,det)
% Decide whether a particle with velocity v from P0 will arrive the
% detector
%
% INPUTS:
% P0: source position (1 raw,3 cols)
% v: velocities of particles (n raws, 3 cols)
% det.dis = z cooridnate (临时用这个)
% det.radius = detector radius (临时用这个)
%
hitFlag = zeros(size(v,1),1);
for i = 1:size(v,1)
    thisv = v(i,:);
    if thisv(3) ~= 0 % 仅非水平出射可能到达探测器
        % P0(3)+n_multi*thisv(3)=det.dis
        n_multi = (det.dis-P0(3))/thisv(3);
        xhit = P0(1)+n_multi*thisv(1);
        yhit = P0(2)+n_multi*thisv(2);
        if xhit^2+yhit^2 < det.radius^2 && det.dis*v(i,3)>0
            hitFlag(i,1) = 1;
        end
    end
end
end

