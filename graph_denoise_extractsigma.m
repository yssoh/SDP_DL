% Extract the value of the variance 
% 

clear all
close all
addpath('codes/')

DATASET = 'gulls2set';
CONFIG = 'sv_denoise';
TYPE = 'denoise';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)

SAVETOPATH = strcat('instances/',DATASET,'/testerr/');
mkdir(SAVETOPATH);

[d,n] = size(Y_TEST_TRUTH);
[l,~] = size(PARAM_TABLE);
Y_DENOISE = zeros(d,n);

SQ_NOISE = zeros(N_REPEATS,1);

for rr = 1 : N_REPEATS
    
    % Load seed from seed table % % %
    seed = SEED_TABLE(rr,1);
    rng(seed)
    
    % Plant noise + Center
    Y_TEST_NOISY = Y_TEST_TRUTH + SIGMANOISE*randn(d,n) - Y_CENTER * ones(1,n);
    
    NOISE_MATRIX = Y_TEST_NOISY - Y_TEST_TRUTH + Y_CENTER * ones(1,n);
    NOISE_MATRIX = NOISE_MATRIX.^2;
    NOISE_MATRIX = NOISE_MATRIX / 720;
    
    SQ_NOISE(rr,1)=sum(sum(NOISE_MATRIX));
    
    
end

save(strcat(SAVETOPATH,'sq_noise.mat'),'SQ_NOISE');
