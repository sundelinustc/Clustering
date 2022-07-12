clear all;
close all;
clc;

input_f = load('../data/connectivity_features/PTSD_connectivity.mat');
input_data = input_f.connectivities;

reference_label = load('sample_label.csv');

mkdir('result'); % not in the raw script, need to manually make it

[bsetScore, bestLabel, bestFeature] = runPipeline(1, input_data, reference_label);
