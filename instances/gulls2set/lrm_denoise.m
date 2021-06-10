% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Base configuration file for Gulls % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Parameters  % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
PARAM_TABLE = [ 9,1,0.010 ; ...
               10,1,0.010 ; ...
               11,1,0.010 ; ...
               12,1,0.010 ; ...
               13,1,0.010 ; ...
               14,1,0.010 ; ...
               15,1,0.010 ; ...
               16,1,0.0025 ; ...
               17,1,0.002 ; ...
               18,1,0.0015 ; ...
               19,1,0.0015 ; ...
               20,1,0.0012 ];
           
f = importdata('data/data.mat');
parmode = 1;            % 1 to run FOR loop in parallel, 0 in series

% Compression / Training % % % % % % % % % % % % % % % % % % % % % % % % % 
if strcmp(TYPE,'compression') == 1

    MAX_ROUNDS = 2;         % Number of repeats per choice of parameter values
    n_its = 20;             % Number of cycles of alternating minimization
    
    % Choice of parameters : [ q , r , init];
    % init is suggested initial step size for solving the constrained
    % optimization instance (see notes)

    % Load
    Y = f.Y_TRAIN;
    SEED_TABLE = importdata('seeds/SEEDS_LRM_DENOISE.mat');
end

% Denoising % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
if strcmp(TYPE,'denoise') == 1
    
    Y_TEST_TRUTH = f.Y_TEST;
    Y_CENTER = f.Y_CENTER;
    SIGMANOISE = 10;
    N_REPEATS = 5;
    MAX_ROUNDS = 2;
    SEED_TABLE = importdata('seeds/SEEDS_DENOISE.mat');
    % Regularizers % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [l,~] = size(PARAM_TABLE);
    REG_START = [0.015; ...
                 0.023; ...
                 0.047; ...
                 0.06; ...
                 0.075; ...
                 0.11; ...
                 0.18; ...
                 0.27; ...
                 0.4; ...
                 0.5; ...
                 0.68; ...
                 0.8];

    N_REGS = 10;
    REG_INC = 3;
    REG_TAB = zeros(l,N_REGS+1);
    for kk = 1 : N_REGS+1
        for jj = 1 : l
            REG_TAB(jj,kk) = REG_START(jj,1) * REG_INC^((kk-1)/N_REGS);
        end
    end
end

% Plot comparison graph % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
if strcmp(TYPE,'plottingcomplexitycomparison') == 1
    dd = 64;
    TOTAL_DICT_RUNS = 2;
    TOTAL_NOISE_RUNS = 5;
    SVSPAN = 2;
end