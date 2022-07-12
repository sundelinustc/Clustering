function SDL_clustering_outputs(SDL)

% load & clean data for analyses

%% Initialization
fname = fullfile(SDL.path, 'Clustering_Ashley', 'result', 'Results_NoRefLabel.mat'); % load results file
load(fname);
fdir_in = fullfile(SDL.path, 'Clustering_Ashley', 'Data'); % path of data
T = readtable(fullfile(fdir_in, 'data_all.csv')); % all data, including demographic info and those for for ML, already preprocessed by a R markdown script

%% Pipeline

% confusion matrix
[m,order] = confusionmat(PTSD_DX_curr', bestLabel0');
figure; cm = confusionchart(m,order);

[m,order] = confusionmat(PTSD_DX_LT', bestLabel0');
figure; cm = confusionchart(m,order);

[m,order] = confusionmat(PTSD_DX_curr', bestLabel1');
figure; cm = confusionchart(m,order);

[m,order] = confusionmat(PTSD_DX_LT', bestLabel1');
figure; cm = confusionchart(m,order);

[m,order] = confusionmat(PTSD_DX_curr', bestLabel2');
figure; cm = confusionchart(m,order);

[m,order] = confusionmat(PTSD_DX_LT', bestLabel2');
figure; cm = confusionchart(m,order);

%% END
end