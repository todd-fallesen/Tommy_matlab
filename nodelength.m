clear all;
clc;
close all;
rootpath    = uigetdir;
%rootpath = 'Z:\working\fallest\Projects\Tommy_Mau\Node_Matlab\Node analysis_For Todd\csv_test\ch3';
%%TO DO, make sure the files match up between ch1 and ch2

files       = dir([rootpath '/*.csv']);

pixelSize = 1;
filenames = {};
x1 = [];
x2 = [];


for a = 1:length(files)
    data = csvread([rootpath '/' files(a).name],2,0);

    filename        = files(a).name(1:end-4);
    filenames{a} = filename;
    rawIntensity    = data(1:end,2:2:end);
    rawIntensity(rawIntensity==0)=nan;
    

    [row,col] = size(rawIntensity);
      for i=1:col
            noderaw = rawIntensity(1:end,i);
            isnan(noderaw);
            ~any(isnan(noderaw));
            noderawno_nans = noderaw(~any(isnan(noderaw),2),:); %keep rows which have no nans

            distance        = data(~any(isnan(noderaw),2),2*i-1);

            [nodeLength(i), x1(a), x2(a)] = nodelengthcalculatorLIVE(distance, noderawno_nans, pixelSize);

            % Create a PNG filename.
            pngFileName = sprintf('%s_%d',filename, i);
            fullFileName = fullfile(rootpath, pngFileName);

            % Then save it
            print(fullFileName, '-dpng');
            close all

    
      end
   
   
   
   
end 

csvwrite(fullfile(rootpath,'noderesults.csv'),nodeLength);


promptMessage = sprintf('Do you want to Continue onto the next channel,\nor Cancel to abort processing?');
button1 = questdlg(promptMessage, 'Continue', 'Continue', 'Cancel', 'Continue');
if strcmpi(button1, 'Cancel')
  return; % Or break or continue
end

rootpath    = uigetdir(rootpath, 'Get the Files for Channel 4');
files_ch4       = dir([rootpath '/*.csv']);


IntegInt = [];
Displacement = [];
IntByDistance = [];
for a = 1:length(files_ch4)
    data = csvread([rootpath '/' files_ch4(a).name],2,0);
    filename        = files_ch4(a).name(1:end-4);
    Filenames{a} = filename;
    
    [IntegInt(a), Displacement(a), IntByDistance(a)] = second_channel_intensity(x1(a), x2(a), distance, data);
    
end

data_table = table(Filenames', Displacement', IntegInt', IntByDistance');


writetable(data_table, fullfile(rootpath,'CH4_results.csv'));    
    

    