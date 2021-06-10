% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Script for plotting graphs
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

lrm_convtab = [1,15,4,7,21,12];
[~,l] = size(lrm_convtab);
lrm_convenv = zeros(l,2);
for i = 1 : l
    lrm_convenv(i,1) = lrm_comp_table(lrm_convtab(i),1);
    lrm_convenv(i,2) = lrm_comp_table(lrm_convtab(i),2);
end

sv_convtab = [1,15,18,8,22,23,12];
[~,l] = size(sv_convtab);
sv_convenv = zeros(l,2);
for i = 1 : l
    sv_convenv(i,1) = sv_comp_table(sv_convtab(i)*SVSPAN,1);
    sv_convenv(i,2) = min(sv_comp_table(SVSPAN*(sv_convtab(i)-1)+1:SVSPAN*sv_convtab(i),2));
end

% 2 way comparison % % % % % % % % % % % % % % % % % % % % % % % %
figure2 = figure;
axes1 = axes('Parent',figure2,'XScale','log','XMinorTick','on',...
    'FontSize',16);
box(axes1,'on');
hold(axes1,'all');
semilogx(lrm_convenv(:,1),lrm_convenv(:,2),'LineWidth',2,'Color',[1 0 0]);
semilogx(sv_convenv(:,1),sv_convenv(:,2),'LineWidth',2,'Color',[0 0 1]);

% Create Labels
ylabel('Normalized MSE','FontSize',16);
xlabel('Computational cost of proximal operator','FontSize',16);