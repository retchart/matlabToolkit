function handle = plotmyvec(vec,vecNames)
% plot differect projection vevtor
% 
% Input:
% vec: structure with each field is a projection vector
% vecNames: Cell to write in the legend

lineWidth = 1.2;fontSize = 12;
if length(fieldnames(vec)) ~= length(vecNames)
    error('ERROR: Input names does not match vectors');
end
figure;hold on;
for i=1:length(vecNames)
    handle = plot(getfield(vec,vecNames{i}),'x-','LineWidth',lineWidth);
end
xlabel('Channel');
title('Normalized projection vectors');
legend(vecNames,'FontSize',fontSize);
set(gca,'FontSize',fontSize);
end

