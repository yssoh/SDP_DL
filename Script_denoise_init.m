% Full Script for denoising comparison
clear all
close all
addpath('codes/')

% Set the following two parameters
DATASET = 'gulls2set';
SAVETOPATH = strcat('instances/',DATASET,'/output');
mkdir(SAVETOPATH)

% Run the SV Script -- Train regularizer
clear all
close all
DATASET = 'gulls2set';
CONFIG = 'sv_denoise';
TYPE = 'compression';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)
run('exp_sv_compress')

% Run the LRM Script -- Train regularizer
clear all
close all
DATASET = 'gulls2set';
CONFIG = 'lrm_denoise';
TYPE = 'compression';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)
run('exp_lrm_compress')
