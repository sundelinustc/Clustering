function SDL_sbj_info(SDL)

% load and clean the clinial information across sites so that images and
% the clinical information of interest are matched

%% Initialization
fdir_in  = fullfile(SDL.path, 'DynamicFC', 'clinical_data'); % path of clinical data
fdir_img = '/mnt/BIAC/duhsnas-pri.dhe.duke.edu/dusom_morey/Data/Lab/beta6_outputs'; % path to preprocessed images (cluster path)
if exist(fdir_img, 'dir'), else, fdir_img = 'Z:\Data\Lab\beta6_outputs'; end % % pth to preprocessed images (my PC path if the cluster path does not work)

% a structure to contain the important information
% SITE name, clinical info filename, {sheetname, demographic variables of interest}, {sheetname, scaning variables of interest}
S = {
    'AMC',                      'AMC.xlsx',               {'Clinical data',                     {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'AMC'};
    'Beijing',                  'Beijing.xlsx',           {'Clinicaldemographic data',          {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Beijing'};
    'Cape Town',                'capetown.xls',           {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Capetown',{'capetown'}};
    'Cape Town',                'capetown.xls',           {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Capetown',{'tygerberg'}};
    'Columbia',                 'Columbia.xlsx',          {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Columbia'};
    'Duke',                     'Duke.xlsx',              {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Duke_data'};
    'Emory',                    'Emory.xlsx',             {'Clinical data',                     {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Emory'};
    'Ghent',                    'Ghent.xlsx',             {'Clinical data',                     {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Ghent'};
    'Groningen',                'Groningen Clinical.xlsx',{'Clinicaldemographic data',          {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Groningen'};
    'Leiden',                   'Leiden.xlsx',            {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Leiden'};
    'Masaryk',                  'Masaryk.xlsx',           {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Masaryk'};
    'McLean',                   'McLean.xlsx',            {'Clinical data',                     {'ID', 'ScanIDs',        'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'McLean'};
    'Michigan',                 'Michigan.xlsx',          {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Michigan'};
    'Milwaukee',                'Milwaukee.xlsx',         {'Clinical data',                     {'ID',                   'CurrPTSDdx',           'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Milwaukee'};
    'Minneapolis VA - Disner',  'Minneapolis_VA.xlsx',    {'Clinical data',                     {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Study',  'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'MinnVA'};
    'Munster',                  'Munster.xlsx',           {'Clinicaldemographic data',          {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Muenster'};
    'Nanjing',                  'NanjingYixing.xlsx',     {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'NanjingYixing_data'};
    'Stanford',                 'Stanford.xlsx',          {'Clinicaldemographic data Brains',   {'ID', 'ScanID',         'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Stanford'};
    'Stanford',                 'Stanford.xlsx',          {'Clinicalsemographic data CC',       {'ID', 'ScanID',         'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Stanford'};
    'Toledo',                   'Toledo.xlsx',            {'demographics',                      {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'scanner',   {'TR'}}, {fullfile('Toledo', 'MVA')};
    'Toledo',                   'Toledo.xlsx',            {'demographics',                      {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'scanner',   {'TR'}}, {fullfile('Toledo', 'ONG')};
    'Tours',                    'Tours.xlsx',             {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Tours'};
    'U Wash',                   'UWash.xlsx',             {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'UWash'};
    'UMN',                      'UMN.xlsx',               {'Clinical data',                     {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'UMN'}; % Notice: sbj folder name is inconsistent with filename, e.g. 'MRS2_101' vs. 'mRS2101'
    'Utrecht - BETER',          'Utrecht.xlsx',           {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Utrecht'}; 
    'UW Madison',               'Wisc_Cisler.xlsx',       {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Cisler'}; 
    'UW Madison',               'Wisc_Grupe.xlsx',        {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Grupe'}; 
    'Vanderbilt',               'Vanderbilt.xlsx',        {'Clinicaldemographic data',          {'ID', 'ScanID',         'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Vanderbilt'}; 
    'Waco VA - Gordon',         'Waco_VA.xls',            {'ENIGMA_Subject_Info',               {'ID', 'RestingStateID', 'CurrPTSDdx',           'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'WacoVA'}; % Notice: there are 3 different scanning parameters, do not know which is correct
    'West Haven',               'WestHaven_VA.xlsx',      {'Clinicaldemographic data',          {'ID', 'RestingStateID', 'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'WestHaven'}; 
    'Western Ontario - Lawson', 'WesternOntario.xls',     {'Clinicaldemographic data',          {'ID',                   'CurrentPTSDDiagnosis', 'Age', 'Sex'}}, {'Scan data', {'TR'}}, {'Lawson'}; 
}; 

%% Load subjects' info
for i = 1:size(S,1) % per site
    sitename = S{i,1};
    fprintf('\nSITE = %s\n', sitename);
    filename = fullfile(fdir_in, sitename, S{i,2});
    sheetname_clinical = S{i,3}{1};
    varsname_clinical  = S{i,3}{2};
    sheetname_scan     = S{i,4}{1};
    varsname_scan      = S{i,4}{2};
    if size(S{i,5},2) == 1 % all subjects are in the site folder
        image_sitename     = S{i,5}{:};
    else % subjects are in different subfolders in the site folder 
        image_sitename = fullfile(S{i,5}{1,1}, S{i,5}{1,2}{:});
    end
    
    
    % load Clinical_data
    T  = readtable(filename, 'sheet', sheetname_clinical); % all clinical data
    if strcmp(sitename, 'Waco VA - Gordon')
        T.ID = T.SubjID;
    end
    if isa(T.ID, 'double')
        if any(isnan(T.ID)) % if readtable leads to NaN in T.ID, e.g. the last 5 subjects in Columbia
            tmp = isnan(T.ID); % index of NaN in T.ID
            % load clinical data using readcell
            Tx = readcell(filename, 'Sheet', sheetname_clinical);
            Tx = cell2table(Tx); % cell -> table
            Tx.Properties.VariableNames = Tx{1,:}; % use the 1st row as variable names
            Tx(1,:) = []; % remove the 1st row
            T.ID = cellstr(num2str(T.ID)); % num -> str -> cell
            T.ID(tmp) = Tx.ID(tmp);
        end
    end
    T  = T(:, varsname_clinical); % clinical data of interest
    
    % scanner info
    T1 = readtable(filename, 'sheet', sheetname_scan); % all scanning info
    T1 = T1(:, varsname_scan); % scanning info of interest
    if size(T1,1) ~= size(T,1) % if there are fewer rows (e.g. 1~3 rows) of scan info (applicable to all subjects)
        tmp = unique(T1.TR);
        if isa(tmp, 'cell')
            if ~isempty(tmp{1}) % if the 1st value is non-empty
                tmp = tmp(1); % TR is the 1st non-empty value
            else
                tmp = tmp(2); % TR is the 2nd non-empty value
            end
        end
        T1{1:size(T,1),'TR'} = tmp(1); % make a new T1 with the same number of rows as T
    end
    T = [T, T1]; % merge clinical & scanning info
    
    if strcmp(sitename, 'Minneapolis VA - Disner')
        T{strcmp(T.Study, 'SATURN'), 'TR'} = 2000;
        T{strcmp(T.Study, 'DEFEND'), 'TR'} = 1300;
        T(T.TR == 0, :) = [];
    elseif strcmp(sitename, 'Tours')
        T{:, 'TR'} = 3000;
    elseif strcmp(sitename, 'UW Madison') && strcmp(filename, 'Wisc_Cisler')
        T{:, 'TR'} = 2000;
    elseif strcmp(sitename, 'Western Ontario - Lawson')
        T{:, 'TR'} = 3000;
    end
    
    T.SITE = repmat({sitename}, size(T,1), 1); % add a column of site name
    
    % Load info of images
    path_img = fullfile(fdir_img, image_sitename, 'derivatives', 'halfpipe'); % path to the data preprocessed by Courtney
    fin_img = dir(path_img); % list all subjects of a given site
    T_img = struct2table(fin_img);
    T_img(strcmp(T_img.name,'.'),:) = []; T_img(strcmp(T_img.name,'..'),:) = []; % remove '.' and '..'
    for j = 1:size(T_img,1) % per subject
        if strcmp(sitename, 'UMN')
            tmp = T_img.name{j};
            tmp = strrep(tmp, '_', ''); tmp = strrep(tmp, 'M', 'm');% e.g. MARS2_101 -> mARS2101
            fimg = fullfile(T_img.folder{j}, T_img.name{j}, 'func', ...
                [tmp, '_task-rest_setting-', 'preproc1_bold.nii.gz']);
        elseif strcmp(sitename, 'UW Madison')
            tmp = T_img.name{j};
            tmp = strrep(tmp, '-EMOREG_', '-eMOREG'); 
            tmp = strrep(tmp, '-DOP_', '-dOP');
            tmp = strrep(tmp, '-PAL_', '-pAL');
            fimg = fullfile(T_img.folder{j}, T_img.name{j}, 'func', ...
                [tmp, '_task-rest_setting-', 'preproc1_bold.nii.gz']);
        else
            fimg = fullfile(T_img.folder{j}, T_img.name{j}, 'func', ...
                [T_img.name{j}, '_task-rest_setting-', 'preproc1_bold.nii.gz']);
        end
        if ~exist(fimg) % if the preprocessed file does not exist
            T_img(j,:) = []; % remove this subject
        end
    end
    T_img = T_img(:,'name'); % only names are needed
    
    % standardize the values in the table
    T = SDL_sub_stand(T, T_img); 
    
    % a big table for all sujects
    if i==1 % if 1st site
        T_clinical = T;
    else
        T_clinical = [T_clinical; T];
    end
end

% save data
fout = fullfile(fdir_in, 'SbjInfo.csv');
writetable(T_clinical, fout);
fprintf('\nSaved: Cleaned subjects info in\n%s\n', fout);




%% END
end

function T_out = SDL_sub_stand(T, T_img)
% Standardize the input table
% Input
% -- T, a table of clinical/demographic info
% -- T_img, a table of images info
% Output
% -- T_out, standardized table

% ID
% T.ID class: double -> string -> cell
if isa(T.ID, 'double') % if T.ID are doubles
    T.ID = num2str(T.ID);
end
if ~isa(T.ID, 'cell') % if not cell
    T.ID = cellstr(T.ID);
end

% RestingStateID
Exist_Column = strcmp('RestingStateID',T.Properties.VariableNames); % compare RestingStateID to each column name
if isempty(Exist_Column(Exist_Column==1)) % if there isn't the column of RestingStateID
    T.RestingStateID = T.ID;
end
% T.RestingStateID class: double -> string -> cell
if strcmp(T.SITE, 'Ghent')
    T.RestingStateID = T.ID; % to beter match image filenames
elseif strcmp(T.SITE, 'McLean')
    T.RestingStateID = T.ScanIDs;
elseif strcmp(T.SITE, 'Stanford')
    T.RestingStateID = T.ScanID;
elseif strcmp(T.SITE, 'Tours')
    T.RestingStateID = strrep(T.ID, 'COPTSD_', '');
elseif strcmp(T.SITE, 'U Wash')
    T.RestingStateID = strrep(T.ID, 'R', '');
elseif strcmp(T.SITE, 'UMN')
    T.RestingStateID = strcat('MARS2_', T.ID); 
elseif strcmp(T.SITE, 'UW Madison')
    tmp = T.ID;
    tmp = strrep(tmp, ' ', '_');
    tmp = strrep(tmp, 'EMO_REG', 'EMOREG');
    T.RestingStateID = tmp;
elseif strcmp(T.SITE, 'Vanderbilt')
    T.RestingStateID = T.ScanID;
elseif strcmp(T.SITE, 'West Haven')
    T.RestingStateID = T.ID;
end
if isa(T.RestingStateID, 'double') % if T.RestingStateID are doubles
    T.RestingStateID = num2str(T.RestingStateID);
end
if ~isa(T.RestingStateID, 'cell')
    T.RestingStateID = cellstr(T.RestingStateID);
end

% CurrentPTSDDiagnosis (Control=0, PTSD=1)
if strcmp(T.SITE{1}, 'Milwaukee') || strcmp(T.SITE{1}, 'Waco VA - Gordon')
    T.CurrentPTSDDiagnosis = T.CurrPTSDdx;
end
T{strcmp(T.CurrentPTSDDiagnosis,'PTSD-DS') | ...
    strcmp(T.CurrentPTSDDiagnosis,'PTSDpDS'),'CurrentPTSDDiagnosis'} = {'PTSD'}; % all PTSD be named as PTSD
T{strcmp(T.CurrentPTSDDiagnosis,'Healthy control') | ...
    strcmp(T.CurrentPTSDDiagnosis,'Subthreshold') | ...
    strcmp(T.CurrentPTSDDiagnosis,'Trauma Control') | ...
    strcmp(T.CurrentPTSDDiagnosis,'trauma-exposed adults without PTSD') | ...
    strcmp(T.CurrentPTSDDiagnosis,'CONTROL') | ...
    strcmp(T.CurrentPTSDDiagnosis,'Controls') | ...
    strcmp(T.CurrentPTSDDiagnosis,'control'),'CurrentPTSDDiagnosis'} = {'Control'}; % all Control be named as Control
T(~strcmp(T.CurrentPTSDDiagnosis,'PTSD') & ~strcmp(T.CurrentPTSDDiagnosis,'Control'),:) = []; % remove the subjects without clear CurrentPTSDDiagnosis info
T.CurrentPTSDDiagnosis = categorical(T.CurrentPTSDDiagnosis);
try
    T.CurrentPTSDDiagnosis = renamecats(T.CurrentPTSDDiagnosis,{'Control','PTSD'},{'0','1'});
catch
    T.CurrentPTSDDiagnosis = renamecats(T.CurrentPTSDDiagnosis,{'PTSD'},{'1'}); % if this site has PTSD only
end
T.CurrentPTSDDiagnosis = str2double(string(T.CurrentPTSDDiagnosis));

% Age
T(isnan(T.Age),:) = []; % remove subjects without age info
T(T.Age==0,:) = []; % remove subjects whose age==0

% Sex（M=,F=1)
T{strcmp(T.Sex,'Male'),'Sex'}   = {'M'}; % Male --> 'M'
T{strcmp(T.Sex,'Female'),'Sex'} = {'F'}; % Female --> 'F'
T(~strcmp(T.Sex,'M') & ~strcmp(T.Sex,'F'),:) = []; % remove the subjects without clear sex info
T.Sex = categorical(T.Sex);
if length(unique(T.Sex)) == 1 % if there is only one sex in this site
    try
       T.Sex = renamecats(T.Sex,{'M'},{'0'}); 
    catch
       T.Sex = renamecats(T.Sex,{'F'},{'1'});
    end
else
    T.Sex = renamecats(T.Sex,{'M','F'},{'0','1'});
end
T.Sex = str2double(string(T.Sex));

% TR (unit: s)
TR = unique(T.TR); % unique values of TR
try ischar(TR{:}) % if is not num, such as '1.3s'
    TR = TR{:}; % extract the string
    TR(strfind(TR, 'm')) = [];% remove the character 'm'
    TR(strfind(TR, 's')) = [];% remove the character 's'
    TR(strfind(TR, 'e')) = [];% remove the character 'e' given that 's' has been removed
    TR(strfind(TR, 'c')) = [];% remove the character 'c' given that 'se' have been removed
    TR = str2double(TR); % string -> double
catch
end
TR = TR(~isnan(TR)); % adopt the non-NaN value as TR
if TR > 10
    TR = TR/1000; % TR (s) sometimes are TR (ms) and need to be standardized
end
if isempty(TR) % if this site has no TR info
    TR = NaN;
end
if length(TR) == 1 % if only one TR value
    T.TR = repmat(TR,size(T,1),1); % 
else % if more than 1 TR (e.g. two scanners with differnt TRs)
    if T.TR > 10
        T.TR = T.TR/1000;
    end
end

% add a column representing image ID
T.fID = strcat(T.SITE, '_sub-', T.RestingStateID); 

% merge with image info
if strcmp(T.SITE, 'Columbia') % for Columbia site only
    for i=1:size(T,1) % per subject
        tmp = T.RestingStateID{i};
        tmp(ismember(tmp, '-')) = ''; % remove '-' in 5 subjects
        T.name{i} = ['sub-', num2str(str2num(tmp) , '%07d')]; % make file names consistent with image names
    end
else
    T.name = strcat('sub-', T.RestingStateID);
    for i=1:size(T,1) % per subject
        tmp = T.name{i};
        tmp(ismember(tmp,' ')) = '';
        T.name{i} = tmp;
    end
end
T = innerjoin(T, T_img, 'Keys', {'name'}); % merge 2 tables according to 'name'
T.ImgID = T.name;

% Output
T_out = T(:, {'ID', 'RestingStateID', 'fID', 'ImgID', 'SITE', 'CurrentPTSDDiagnosis', 'Age', 'Sex', 'TR'});
end