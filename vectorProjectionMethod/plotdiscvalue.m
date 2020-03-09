function handle = plotdiscvalue(values,names)
% Plot the estimated value of the discriminations with different detection
% time
%
% Inputs:
% values: Each column is the value of the discriminator. zeros means not
%         calculated
% names: Cell to write in the legend
%

lineWidth = 2;fontSize = 12;
if size(values,2) ~=length(names)
    error('ERROR: Input names does not match vectors');
end
values = [(1:size(values,1))',values];
values(find(values(:,2)==0),:) =[];

figure;hold on;
for i=1:length(names)
    handle = plot(values(:,1),values(:,i+1),'x-','LineWidth',lineWidth);
end
set(gca,'FontSize',fontSize);
xlabel('Detection time(s)','FontSize',fontSize);
legend(names);

end

