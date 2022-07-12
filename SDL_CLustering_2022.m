% This script aims at clustering analyses
% The sccript was made by Dr. Delin Sun (01/13/2022)
% The functions reply on the Matlab toolbox of
% identification-of-brain-based-disorders (https://github.com/xinyuzhao/identification-of-brain-based-disorders)


%% Parameters
% paths of projects and scripts
cd ..; cd ..; SDL.path = pwd; % project path
cd(fullfile(SDL.path,'Clustering_Ashley','Scripts')); % get into the path of scripts

% add paths of important toolbox (if the path has not been set)
if isempty(which('runPipeline')), addpath(fullfile(SDL.path,'Clustering_Ashley','Scripts','identification-of-brain-based-disorders','src')); end
%if isempty(which('spm')), addpath(fullfile(SDL.path,'DynamicFC','Scripts','spm12')); end
% if isempty(which('DynamicBC')), addpath(fullfile(SDL.path,'DynamicFC','Scripts','DynamicBC2.2_20181112')); end


%% Subjects' info
% SDL_CleanData(SDL);

%% Clustering
SDL_clustering(SDL); % clustering analyses

%% Outputs
SDL_clustering_outputs; % display the outputs of clustering analyses

