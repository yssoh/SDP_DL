% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Plot comparison graph
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

close all
clear all

load('errs.mat');
N_ROUNDS = 1;

% Hard code the locations where the convex envelop is attained
lrm_lower_tab = [1,2,3,4,5,8];
[~,l] = size(lrm_lower_tab);
lrm_lower_env = zeros(l,2);
for i = 1 : l
    lrm_lower_env(i,1) = lrm_comp_table(lrm_lower_tab(i),3);
    lrm_lower_env(i,2) = min(lrm_comp_table(lrm_lower_tab(i),3+1:3+N_ROUNDS));
end

sv_lower_tab = [25,33,50,43,51,60,61,78,87,88];
[~,l] = size(sv_lower_tab);
sv_lower_env = zeros(l,2);
for i = 1 : l
    sv_lower_env(i,1) = sv_comp_table(sv_lower_tab(i),3);
    sv_lower_env(i,2) = min(sv_comp_table(sv_lower_tab(i),3+1:3+N_ROUNDS));
end

figure
hold on
plot(lrm_comp_table(:,3),lrm_comp_table(:,4),'.r','LineWidth',2)
plot(sv_comp_table(:,3),sv_comp_table(:,4),'.b','LineWidth',2)
plot(lrm_lower_env(:,1),lrm_lower_env(:,2),'r','LineWidth',2)
plot(sv_lower_env(:,1),sv_lower_env(:,2),'b','LineWidth',2)
hold off
ylabel('Approximation error','FontSize',16)
xlabel('Representation complexity','FontSize',16)
set(gca,'fontsize',16)

figure
hold on
plot(lrm_lower_env(:,1),lrm_lower_env(:,2),'r','LineWidth',2)
plot(sv_lower_env(:,1),sv_lower_env(:,2),'b','LineWidth',2)
hold off
ylabel('Approximation error','FontSize',16)
xlabel('Representation complexity','FontSize',16)
set(gca,'fontsize',16)

% Error progression plots % % % % % % % % % % % % % % % % % % % % % % % % 
clear all
jj = 1;

% Sparse vectors % % % % % % % % % % % % % % % % % % % % % % % % 
DATASET = 'gulls2set';
CONFIG = 'sv_compress';
TYPE = '';
SCRIPT = strcat('instances\',DATASET,'\',CONFIG);
DIR = strcat('instances\',DATASET,'\output\');

run(SCRIPT)
SV_PARAM_TABLE = [400,7;500,7;700,7;600,8;700,8;800,8;800,9;1000,9;1100,10;1100,11];
[l,~] = size(SV_PARAM_TABLE);

figure
hold on
for i = 1 : l
    q = SV_PARAM_TABLE(i,1);
    r = SV_PARAM_TABLE(i,2);
    PATH = strcat(DIR,'r',int2str(jj),'sv_q',int2str(q),'r',int2str(r),'.mat');
    load(PATH,'errtab_store')
    plot(mean(errtab_store,2),'k','LineWidth',2);
end
hold off

ylabel('Approximation error','FontSize',16)
xlabel('Iterate #','FontSize',16)
set(gca,'fontsize',16)

% Low-rank matrices % % % % % % % % % % % % % % % % % % % % % % % % 
CONFIG = 'lrm_compress';
SCRIPT = strcat('instances\',DATASET,'\',CONFIG);
LRM_PARAM_TABLE = [9,1;10,1;11,1;12,1;13,1;9,2] ;
[l,~] = size(LRM_PARAM_TABLE);
lrm_comp_table = zeros(l,2);

figure
hold on
for i = 1 : l
    q = LRM_PARAM_TABLE(i,1);
    r = LRM_PARAM_TABLE(i,2);
    PATH = strcat(DIR,'r',int2str(jj),'lrm_q',int2str(q),'r',int2str(r),'.mat');
    load(PATH,'errtab_store')
    plot(mean(errtab_store,2),'k','LineWidth',2);
end
hold off

ylabel('Approximation error','FontSize',16)
xlabel('Iterate #','FontSize',16)
set(gca,'fontsize',16)