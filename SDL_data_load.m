function SDL_data_load(SDL)

% load & clean data for analyses

%% Initialization
fdir_in = fullfile(SDL.path, 'Clustering--Ashley', 'Data'); % path of data
T = readtable(fullfile(fdir_in, 'data_ML.csv')); % all data for ML
% T = T(:,[2,5:end]); % extract nums only to simplify the data for test purpose only


%% Pipeline
% method_name - selected clustering method; 0: hierarchial clustering, 1: DPC, 2: OPTICS
% input_data - m by n data matrix; m: number of samples, n: number of
% features
% reference_label - m by 1 vector; Optional input paramter, default is []
cd(fullfile(SDL.path, 'Clustering--Ashley'));
mkdir('result');

% Three clustering methods (without reference_label)
[bestScore0, bestLabel0, bestFeature0] = runPipeline(0, T{:,:}, []);
[bestScore1, bestLabel1, bestFeature1] = runPipeline(1, T{:,:}, []);
[bestScore2, bestLabel2, bestFeature2] = runPipeline(0, T{:,:}, []);

%% END
end