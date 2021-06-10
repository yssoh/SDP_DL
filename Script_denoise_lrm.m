% Script for denoising using semidefinite representable norms
% Body of the code

clear all
close all
addpath('codes/')

DATASET = 'gulls2set';
CONFIG = 'lrm_denoise';
TYPE = 'denoise';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)

[d,n] = size(Y_TEST_TRUTH);
[l,~] = size(PARAM_TABLE);
Y_DENOISE = zeros(d,n);

% Main Loop

% Import Set
for dictround = 1 : MAX_ROUNDS
for rr = 1 : N_REPEATS
    
    % Load seed from seed table % % %
    seed = SEED_TABLE(rr,1);
    rng(seed)
    
    % Plant noise + Center
    Y_TEST_NOISY = Y_TEST_TRUTH + SIGMANOISE*randn(d,n) - Y_CENTER * ones(1,n);
 
    fprintf('Denoising Experiment # # # # # # # # # # # # \n')
    
    for jj = 1 : l    
        q = PARAM_TABLE(jj,1);
        r = PARAM_TABLE(jj,2);    
        fprintf('Dimension %d, Rank %d \n',q,r)

        % % % % % % % % % % % % % % % % % % % % %
        % Loading trained dictionary
        % % % % % % % % % % % % % % % % % % % % %
        
        fprintf('Loading trained dictionary...')
        DICTPATH = strcat('instances/',DATASET,'/output/r',int2str(dictround),'lrm_q',int2str(q),'r',int2str(r),'.mat');
        load(DICTPATH,'A')
        fprintf('Done.\n')

        % % % % % % % % % % % % % % % % % % % % %
        % Testing
        % % % % % % % % % % % % % % % % % % % % %

        fprintf('Testing with trained A...\n')
        [~,N_REGS] = size(REG_TAB);
        nsq_mat = zeros(N_REGS,n);
        nabs_mat = zeros(N_REGS,n);
        sq_mat = zeros(N_REGS,n);

        % Sweep over choices of regularizers
        for kk = 1 : N_REGS

            REG = REG_TAB(jj,kk);
            fprintf('Denoising with choice of regularizer %e .',REG)

            % Here the hard-thresholding parameter is set to q so that no
            % hard-thresholding is actually performed
            if parmode == 1
                parfor ii = 1 : n
                    Y_DENOISE(:,ii) = contract(A,lrmnuc(A,Y_TEST_NOISY(:,ii),q,'reg',REG));
                end
            else
                for ii = 1 : n
                    Y_DENOISE(:,ii) = contract(A,lrmnuc(A,Y_TEST_NOISY(:,ii),q,'reg',REG));
                end
            end

            % Compute the reconstruction error
            for ii = 1 : n
                nabs_mat(kk,ii) = norm(Y_DENOISE(:,ii) + Y_CENTER - Y_TEST_TRUTH(:,ii)) / norm(Y_TEST_TRUTH(:,ii));
                nsq_mat(kk,ii) = norm(Y_DENOISE(:,ii) + Y_CENTER - Y_TEST_TRUTH(:,ii))^2 / norm(Y_TEST_TRUTH(:,ii))^2;
                sq_mat(kk,ii) = norm(Y_DENOISE(:,ii) + Y_CENTER - Y_TEST_TRUTH(:,ii))^2;
            end
            fprintf('Error: norm. abs %e, norm. sq %e, mse %e \n',mean(nabs_mat(kk,:)),mean(nsq_mat(kk,:)),mean(sq_mat(kk,:)))

        end
        DICTPATH = strcat('instances/',DATASET,'/testerr/r',int2str(dictround),'n',int2str(rr),'err_lrm_q',int2str(q),'r',int2str(r),'.mat');
        save(DICTPATH,'nabs_mat','nsq_mat','sq_mat')
        fprintf('Complete\n\n\n')

    end
end
end