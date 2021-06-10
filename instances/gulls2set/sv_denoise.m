% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Base configuration file for Gulls % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Parameters  % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
PARAM_TABLE = [81,8; 81,9; ...
               100,9; 100,10; ...
               121,10; 121,11; ...
               144,11; 144,12; ...
               169,12; 169,13; ...
               196,13; 196,14; ...
               225,14; 225,15; ...
               256,15; 256,16; ...
               289,16; 289,17; ...
               324,17; 324,18; ...
               361,18; 361,19; ...
               400,19; 400,20];
           
f = importdata('data/data.mat');
parmode = 1;            % 1 to run FOR loop in parallel, 0 in series

if strcmp(TYPE,'compression') == 1

    MAX_ROUNDS = 2;         % Number of repeats per choice of parameter values
    n_its = 20;             % Number of cycles of alternating minimization

    % Choice of parameters : [ q , r ];
    % Load
    Y = f.Y_TRAIN;
    SEED_TABLE = importdata('seeds/SEEDS_SV_DENOISE.mat');
    
end

if strcmp(TYPE,'denoise') == 1
    
    Y_TEST_TRUTH = f.Y_TEST;
    Y_CENTER = f.Y_CENTER;
    SIGMANOISE = 10;
    N_REPEATS = 5;
    MAX_ROUNDS = 2;
    SEED_TABLE = importdata('seeds/SEEDS_DENOISE.mat');
    
    % Regularizers % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    [l,~] = size(PARAM_TABLE);
    REG_START = [0.0013; 0.0013; ...
                 0.0028; 0.0028; ...
                 0.0034; 0.0047; ...
                 0.0055; 0.0055; ...
                 0.0075; 0.0075; ...
                 0.008;  0.008; ...
                 0.011;  0.011; ...
                 0.013;  0.013; ...
                 0.013;  0.013; ...
                 0.014;  0.014; ...
                 0.015;  0.015; ...
                 0.015;  0.015];

    N_REGS = 10;
    REG_INC = 2;
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
