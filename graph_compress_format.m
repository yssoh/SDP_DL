% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Only need to run the following segment once
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

close all
clear all
addpath('graphs/')

DATASET = 'gulls2set';
TYPE = '';

CONFIG = 'sv_compress';
SCRIPT = strcat('instances\',DATASET,'\',CONFIG);
run(SCRIPT)
SV_PARAM_TABLE = PARAM_TABLE;

CONFIG = 'lrm_compress';
SCRIPT = strcat('instances\',DATASET,'\',CONFIG);
run(SCRIPT)
LRM_PARAM_TABLE = PARAM_TABLE;

Y = f.Y_TRAIN;
[d,n] = size(Y);

N_ROUNDS = 1;

DIR = strcat('instances\',DATASET,'\output\');
UB = 33;
LB = 17;

% Sparse Vectors
[l,~] = size(SV_PARAM_TABLE);
sv_comp_table = [];
for i = 1 : l
    q = SV_PARAM_TABLE(i,1);
    r = SV_PARAM_TABLE(i,2);
    sv_newrow = zeros(1,3+N_ROUNDS);
    sv_newrow(:,1) = q;
    sv_newrow(:,2) = r;
    sv_newrow(:,3) = complexity_sv(r,q,d,n);
    
    if (sv_newrow(:,3)>=LB) && (sv_newrow(:,3)<=UB)

        for jj = 1 : N_ROUNDS;
            PATH = strcat(DIR,'r',int2str(jj),'sv_q',int2str(q),'r',int2str(r),'.mat');
            load(PATH,'errtab_store')
            [len,~] = size(errtab_store);
            sv_newrow(:,3+jj) = mean(errtab_store(len,:));   
        end
        sv_comp_table = [sv_comp_table ; sv_newrow];
    end
end

% Low Rank Matrices
[l,~] = size(LRM_PARAM_TABLE);
lrm_comp_table = [];
for i = 1 : l
    q = LRM_PARAM_TABLE(i,1);
    r = LRM_PARAM_TABLE(i,2);
    lrm_newrow = zeros(1,3+N_ROUNDS);
    lrm_newrow(:,1) = q;
    lrm_newrow(:,2) = r;
    lrm_newrow(:,3) = complexity_lrm(r,q,d,n);
    
    if (lrm_newrow(:,3)>=LB) && (lrm_newrow(:,3)<=UB)

        for jj = 1 : N_ROUNDS;
            PATH = strcat(DIR,'r',int2str(jj),'lrm_q',int2str(q),'r',int2str(r),'.mat');
            load(PATH,'errtab_store')
            [len,~] = size(errtab_store);
            lrm_newrow(:,3+jj) = mean(errtab_store(len,:));   
        end
        lrm_comp_table = [lrm_comp_table ; lrm_newrow];
    end
end

save('errs.mat','lrm_comp_table','sv_comp_table')

close all
clear all