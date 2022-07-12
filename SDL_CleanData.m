function SDL_CleanData(SDL)

% Aims:
% (1) load data from data_clusteranalysis.csv
% (2) remove columns with a lot of NA, i.e. 'drink_alcohol', and 'alcohol_problems'
% (3) remove subjects with missing values, i.e. NA
% (4) split data into two sections: part1 & part2
% (5) normalize, standardize data and save outputs for part1&2, respectively
% (6) regress out clinical & demographic info from brain data, and save, for part1&2, respectively

%% (1) Load data
fdir_in = fullfile(SDL.path, 'Clustering_Ashley', 'Data'); % path of data
T  = readtable(fullfile(fdir_in, 'data_clusteranalysis.csv')); % T is a 240x20 table

%% (2) Remove columns of too many NAs
T.drink_alcohol = [];
T.alcohol_problems = []; % T is a 240x18 table

%% (3) Remove subjects with NA
T(any(ismissing(T),2), :) = []; % T is a 228x18 table

%% (4) Split data into two sections
T1 = T(T.Part==1,:); % T1 is a 80x18 table
T2 = T(T.Part==2,:); % T2 is a 148x18 table

%% (5) Normalization, Standardization
% part 1
M = T1{:,3:end};
a = StatisticalNormaliz(M, 'standard'); b = StatisticalNormaliz(a, 'scaling'); 
T1{:,3:end} = b;
fn = fullfile(fdir_in, 'data1.csv');
writetable(T1, fn);

% part 2
M = T2{:,3:end};
a = StatisticalNormaliz(M, 'standard'); b = StatisticalNormaliz(a, 'scaling'); 
T2{:,3:end} = b;
fn = fullfile(fdir_in, 'data2.csv'); 
writetable(T2, fn);

%% (6) Regress our clinical/demographic info from brain data
Vhead = {'Scan_ID', 'Part'};
Vy  = 'head_injury_yes';
Vx  = {'small_25_50_voxels', 'medium_50_75_voxels', 'large_75_100_voxels', 'Xlarge_100up_voxels'}; % variables of interest (brain data)
Vco = {'Age', 'Gender_M', 'Hand_L', 'PTSD_DX_curr', 'PTSD_DX_LT', 'X_bdi_score', 'X_dast_score',...
    'education', 'employed', 'suicide', 'smokes'};

% part 1
T1_new = T1(:, [Vhead, Vy]);
for i = 1:size(Vx,2) % per variable of interest
    Vname = Vco; Vname{end+1} = Vx{i}; % linear model: Vx{i} ~ 1 + Vco{1} + Vco{2} +...+Vco{end}
    tbl  = T1(:, Vname);
    mdl = fitlm(tbl); 
    T1_new.(Vx{i}) = mdl.Residuals.Raw;
end
fn = fullfile(fdir_in, 'data1_regressed.csv'); % brain data after regressing out demographic/clinical variables
writetable(T1_new, fn);

% part 2
T2_new = T2(:, [Vhead, Vy]);
for i = 1:size(Vx,2) % per variable of interest
    Vname = Vco; Vname{end+1} = Vx{i}; % linear model: Vx{i} ~ 1 + Vco{1} + Vco{2} +...+Vco{end}
    tbl  = T2(:, Vname);
    mdl = fitlm(tbl); 
    T2_new.(Vx{i}) = mdl.Residuals.Raw;
end
fn = fullfile(fdir_in, 'data2_regressed.csv'); % brain data after regressing out demographic/clinical variables
writetable(T2_new, fn);

%% End
end