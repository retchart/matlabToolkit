function directions = gen3Ddirection(zpole,phi)
% 
% INPUTS:
% zpole: reference direction (3 columns, many raws)
% phi: angle between particle direction and zpole( 1 column)
%
% OUTPUTS:
% directions: particle direction in 3D (3 columns, many raws)
%

directions = 0*zpole; % 粒子出射方向
centers = 0*zpole; % 方向簇圆心
rr = 0*phi; % 方向簇半径
for i = 1:size(zpole,1)
    if phi(i,1) < pi/2
        centers(i,:) = zpole(i,:);
        rr(i,1) = tan(phi(i,1));
    elseif phi(i,1) == pi/2
        centers(i,:) = [0,0,0];
        rr(i,1) = 1;
    elseif phi(i,1) > pi/2
        centers(i,:) = -zpole(i,:);
        rr(i,1) = -tan(phi(i,1));
    else 
        error('Some theta value is wrong');
    end
end
for i = 1:size(zpole,1)
    basis_a = cross(zpole(i,:),[1 0 0]);
    if ~any(basis_a) % 若basis_a全为0
        basis_a = cross(zpole(i,:),[0 1 0]);
    end
    basis_b = cross(zpole(i,:),basis_a); 
    basis_a = basis_a/norm(basis_a);
    basis_b = basis_b/norm(basis_b);
    theta = 2*pi*rand; % 随机抽取圆周上的一个点
    directions(i,1) = centers(i,1)+rr(i,1)*basis_a(1)*cos(theta)+rr(i,1)*basis_b(1)*sin(theta);
    directions(i,2) = centers(i,2)+rr(i,1)*basis_a(2)*cos(theta)+rr(i,1)*basis_b(2)*sin(theta);
    directions(i,3) = centers(i,3)+rr(i,1)*basis_a(3)*cos(theta)+rr(i,1)*basis_b(3)*sin(theta);
end

end

