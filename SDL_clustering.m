function SDL_clustering(SDL)

% load & clean data for analyses

%% Initialization
% file names of cleaned data
fn = {
    'data1';
    'data1_regressed';
    'data2';
    'data2_regressed';
    };

fdir_in = fullfile(SDL.path, 'Clustering_Ashley', 'Data'); % path of data


%% Pipeline
% method_name - selected clustering method; 0: hierarchial clustering, 1: DPC, 2: OPTICS
% input_data - m by n data matrix; m: number of samples, n: number of
% features
% reference_label - m by 1 vector; Optional input paramter, default is []
cd(fullfile(SDL.path, 'Clustering_Ashley'));
mkdir('result');

for i = 1:size(fn,1) % per input data file
    T  = readtable(fullfile(fdir_in, [fn{i},'.csv'])); % load preprocessed data
    Vname = T.Properties.VariableNames; % names of all variables
    Vhead = {'Scan_ID', 'Part', 'head_injury_yes'}; % names of variables that will NOT be including in clustering analyses
    VnameX = setdiff(Vname, Vhead); % names of variables that will be included in clustering analyses
    
    %% Three clustering methods (without reference_label)
    [bestScore0, bestLabel0, bestFeature0] = runPipeline(0, T{:,VnameX}, []); % hierarchial clustering
    [bestScore1, bestLabel1, bestFeature1] = runPipeline(1, T{:,VnameX}, []); % DPC
    [bestScore2, bestLabel2, bestFeature2] = runPipeline(2, T{:,VnameX}, []); % OPTICS
    
    fname = fullfile(SDL.path, 'Clustering_Ashley', 'result', ['Results_',fn{i},'_NoRefLabel.mat']);
    save(fname);
   
    
    %% Three clustering methods (without reference_label)
    [bestScore0, bestLabel0, bestFeature0] = runPipeline(0, T{:,VnameX}, T.head_injury_yes); % hierarchial clustering
    [bestScore1, bestLabel1, bestFeature1] = runPipeline(1, T{:,VnameX}, T.head_injury_yes); % DPC
    [bestScore2, bestLabel2, bestFeature2] = runPipeline(2, T{:,VnameX}, T.head_injury_yes); % OPTICS
    
    fname = fullfile(SDL.path, 'Clustering_Ashley', 'result', ['Results_',fn{i},'_YesRefLabel.mat']);
    save(fname);
end


%% END
end