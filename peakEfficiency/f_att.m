function fatt = f_att(m,r,h,d)
% 计算圆柱状源的自吸收因子
% 峰效率e(E)=ep(E)*fG*fatt
% ep(E)为点源探测效率（点位于体源距离探测器最近的表面的中心）
% fG无衰减几何探测效率
% fatt 自吸收因子，本函数给出
% 参考文献：J. C. Aguiar, E. Galiano, and J. Fernandez, 
% “Peak efficiency calibration for attenuation
%  corrected cylindrical sources in gamma ray 
%  spectrometry by the use of a point source,” 
%  Appl. Radiat. Isot., vol. 64, no. 12, pp. 1643–1647, 2006.
% INPUTS：
%       m: 源的线性衰减系数(/cm)
%       r：源的半径(cm)
%       h：源的高度(cm)
%       d：源距离探测器的最近距离(cm)
% OUTPUTS:
%       fatt：自吸收因子

i

fatt = imrhd/irhd;

end

