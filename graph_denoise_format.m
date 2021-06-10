% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Script for converting format
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

close all
clear all

DATASET = 'gulls2set';
TYPE = 'plottingcomplexitycomparison';

SCRIPT = strcat('instances/',DATASET,'/lrm_denoise');
run(SCRIPT)
LRM_PARAM_TABLE = PARAM_TABLE;

% Low Rank Matrices
[l,~] = size(LRM_PARAM_TABLE);
lrm_comp_table = zeros(TOTAL_DICT_RUNS*l,2);
for dict = 1 : TOTAL_DICT_RUNS
    for i = 1 : l
        q = LRM_PARAM_TABLE(i,1);
        r = LRM_PARAM_TABLE(i,2);

        % Complexity Measure for LRM
        lrm_comp_table(i+(dict-1)*l,1) = (sqrt(2*q+2) * ((dd+q*(2*q+1)+2)^3 + (q*(2*q+1)+2)^3) * log((2*q+2) / 10^(-6)));
        
        % Getting dimensions (pardon the terrible code)
        PATH = strcat('instances/',DATASET,'/testerr/r1n1err_lrm_q',int2str(q),'r',int2str(r),'.mat');
        load(PATH,'sq_mat')
        [nregs,sq_mat_otherdim]=size(sq_mat);
        
        % Aggregate the MSEs
        sq_mat_avg = zeros(nregs,sq_mat_otherdim);
        total_noise = 0;
        load(strcat('instances/',DATASET,'/testerr/sq_noise.mat'),'SQ_NOISE');
        for runno = 1 : TOTAL_NOISE_RUNS
            PATH = strcat('instances/',DATASET,'/testerr/r',int2str(dict),'n',int2str(runno),'err_lrm_q',int2str(q),'r',int2str(r),'.mat');
            load(PATH,'sq_mat')
            load(strcat('instances/',DATASET,'/testerr/sq_noise.mat'),'SQ_NOISE')
            sq_mat_avg = sq_mat_avg + sq_mat;
            total_noise = total_noise + SQ_NOISE(runno,1);
        end
        sq_mat_avg = sq_mat_avg / total_noise;
        
        % Extract the best performing MSEs
        minsofar = mean(sq_mat_avg(1,:));
        for jj = 2 : nregs
            minsofar = min(minsofar,mean(sq_mat_avg(jj,:))); 
        end
        lrm_comp_table(i+(dict-1)*l,2) = minsofar;
    end
end

SCRIPT = strcat('instances/',DATASET,'/sv_denoise');
run(SCRIPT)
SV_PARAM_TABLE = PARAM_TABLE;

% Sparse Vectors
[l,~] = size(SV_PARAM_TABLE);
sv_comp_table = zeros(TOTAL_DICT_RUNS*l,2);
for dict = 1 : TOTAL_DICT_RUNS
    for i = 1 : l
        q = SV_PARAM_TABLE(i,1);
        r = SV_PARAM_TABLE(i,2);

        % Complexity Measure for SV
        sv_comp_table(i+(dict-1)*l,1) = (sqrt(2*q+2) * ((dd+2*q+2)^3 + (2*q+2)^3)* log((2*q+2) / 10^(-6)));
        
        % Getting dimensions (pardon the terrible code)
        PATH = strcat('instances/',DATASET,'/testerr/r1n1err_sv_q',int2str(q),'r',int2str(r),'.mat');
        load(PATH,'sq_mat')
        [nregs,sq_mat_otherdim]=size(sq_mat);
        
        % Aggregate the MSEs
        sq_mat_avg = zeros(nregs,sq_mat_otherdim);
        total_noise = 0;
        load(strcat('instances/',DATASET,'/testerr/sq_noise.mat'),'SQ_NOISE');
        for runno = 1 : TOTAL_NOISE_RUNS
            PATH = strcat('instances/',DATASET,'/testerr/r',int2str(dict),'n',int2str(runno),'err_sv_q',int2str(q),'r',int2str(r),'.mat');
            load(PATH,'sq_mat')
            sq_mat_avg = sq_mat_avg + sq_mat;
            total_noise = total_noise + SQ_NOISE(runno,1);
        end
        sq_mat_avg = sq_mat_avg / total_noise;
        
        % Extract the best performing MSEs
        minsofar = mean(sq_mat_avg(1,:));
        for jj = 2 : nregs
            minsofar = min(minsofar,mean(sq_mat_avg(jj,:))); 
        end
        sv_comp_table(i+(dict-1)*l,2) = minsofar;
    end
end