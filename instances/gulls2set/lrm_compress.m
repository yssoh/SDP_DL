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
                9,2,0.008 ];
           
f = importdata('data/data.mat');
parmode = 1;            % 1 to run FOR loop in parallel, 0 in series

% Compression / Training % % % % % % % % % % % % % % % % % % % % % % % % % 
if strcmp(TYPE,'compression') == 1

    MAX_ROUNDS = 1;         % Number of repeats per choice of parameter values
    n_its = 20;             % Number of cycles of alternating minimization
    
    % Choice of parameters : [ q , r , init];
    % init is suggested initial step size for solving the constrained
    % optimization instance (see notes)

    % Load
    Y = f.Y_TRAIN;
    SEED_TABLE = importdata('seeds/SEEDS_LRM_COMPRESS.mat');
end

% Sweep for suitable parameters % % % % % % % % % % % % % % % % % % % % % %
if strcmp(TYPE,'sweep_sv_params') == 1
    Y = f.Y_TRAIN;
end
