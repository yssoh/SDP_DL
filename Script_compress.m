% Script for replicating experiment in Section 4.2.1 (''Representing Natural Images Patches'')

% There are two stages to this experiment
% Stage 1A and 1B may be executed independently, but must be completed before executing the next stage.

% Clear
clear all
close all
addpath('codes/')

% Set paths
DATASET = 'gulls2set';
SAVETOPATH = strcat('instances/',DATASET,'/output');
mkdir(SAVETOPATH)

% Stage 1A : Represent data as projection of sparse vectors
clear all
close all
DATASET = 'gulls2set';
CONFIG = 'sv_compress';
TYPE = 'compression';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)
run('exp_sv_compress')

% Stage 1B : Represent data as projection of low-rank matrices
clear all
close all
DATASET = 'gulls2set';
CONFIG = 'lrm_compress';
TYPE = 'compression';
SCRIPT = strcat('instances/',DATASET,'/',CONFIG);
run(SCRIPT)
run('exp_lrm_compress')

% Stage 2 : Plot comparison graph
run('graph_compress_format')
run('graph_compress_plot')
