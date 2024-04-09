%% Clear all and close all

clear all;
clc;
close all;


% %% Make a prompt for one or two data sets
% promptMessage = sprintf('Would you like to process one,\nor two channels');
% channel_count = questdlg(promptMessage, 'One', 'One', 'Two', 'Two', 'Cancel');
% 
% %% Make a switch case for the two options
% switch channel_count
%     case 'One'
%         
%     rootpath    = uigetdir; %get the path for the data
%     files       = dir([rootpath '/*.csv']); %read in the data
%     pixelSize = 1;
%     filenames = {}; %make a cell array for the files
%     x1 = []; 
%     x2 = [];
% 
% 
%     for a = 1:length(files)
%         data = csvread([rootpath '/' files(a).name],2,0); %read in the data from the file
% 
%         filename        = files(a).name(1:end-4);
%         filenames{a} =      filename;
%         rawIntensity    = data(1:end,2:2:end);
%         rawIntensity(rawIntensity==0)=nan;
% 
% 
%         [row,col] = size(rawIntensity);
%           for i=1:col
%                 noderaw = rawIntensity(1:end,i);
%                 isnan(noderaw);
%                 ~any(isnan(noderaw));
%                 noderawno_nans = noderaw(~any(isnan(noderaw),2),:); %keep rows which have no nans
% 
%                 distance        = data(~any(isnan(noderaw),2),2*i-1);
% 
%                 [nodeLength(i), x1(a), x2(a)] = nodelengthcalculatorLIVE(distance, noderawno_nans, pixelSize);
% 
%                 % Create a PNG filename.
%                 pngFileName = sprintf('%s_%d',filename, i);
%                 fullFileName = fullfile(rootpath, pngFileName);
% 
%                 % Then save it
%                 print(fullFileName, '-dpng');
%                 close all
% 
% 
%           end
% 
% 
% 
% 
%     end 
% 
%     csvwrite(fullfile(rootpath,'noderesults.csv'),nodeLength);
% 
% %%This is case TWO
% %%
% 
%     case 'Two'
        [file_ch1, path]=uigetfile('*.csv', 'Choose the First Channel file');
        [file_ch2, path2]=uigetfile('*.csv', 'Choose the Second Channel file');

        data = readtable(fullfile(path, file_ch1)); %load the file
        variable_names = data.Properties.VariableNames;
        containsVar = cellfun(@(x) contains(x, 'Var'), variable_names); %logical array to take out the ones that contain 'Var'
        file_cells_ch1= variable_names(~containsVar);
        data(1,:)=[];


        pixelSize = 1;
        filenames = {};
        x1 = [];
        x2 = [];


        for a = 1:length(file_cells_ch1)
            
                %todd code
                x_dist =  [];
                intensity =[];
                distance = [];
                noderaw =[];
                nodrawno_nans=[];
                rawIntensity = [];
                disp("A is currently")
                a
                x_dist=str2double(table2array(data(1:end,(a*2) -1))); %using the variable "a" as the multiplier, we will get the correct columns for each file
                intensity = str2double(table2array(data(1:end,(a*2) -0)));
                filename_ch1 = file_cells_ch1{a}; %get the filename
            
            

            

                    rawIntensity    = intensity;
                    %this is original code
                    rawIntensity(rawIntensity==0)=nan;


                   noderaw = rawIntensity(1:end);

                    noderawno_nans = noderaw(~any(isnan(noderaw),2),:); %keep rows which have no nans

                    distance =  x_dist(~any(isnan(x_dist),2),:);

                    [nodeLength(a), x1(a), x2(a)] = nodelengthcalculatorLIVE(distance, noderawno_nans, pixelSize);

                    % Create a PNG filename.
                    pngFileName = sprintf('%s_%d',filename_ch1, i);
                    fullFileName = fullfile(path, pngFileName);

                    % Then save it
                    print(fullFileName, '-dpng');
                    close all


                    data_out(a).Filename=filename_ch1;
                    data_out(a).nodeLength=nodeLength(a);
                    data_out(a).x1 = x1(a);
                    data_out(a).x2 = x2(a);
                    

                    



        end 
        data_out = struct2table(data_out);
        writetable(data_out,fullfile(path,'noderesults.csv'));

        
  %%% Second channel stuff
  

        [file_ch2, path2]=uigetfile('*.csv', 'Choose the Second Channel file');


        data_ch2 = readtable(fullfile(path2, file_ch2)); %load the file
        variable_names = data_ch2.Properties.VariableNames;
        containsVar = cellfun(@(x) contains(x, 'Var'), variable_names); %logical array to take out the ones that contain 'Var'
        file_cells_ch2= variable_names(~containsVar); %removes the VarX names from the list of file names
        data_ch2(1,:)=[]; %pulls off the first row which is variable names again.  Comment this out if you don't have variable names in row one

        
        if isequal(file_cells_ch1, file_cells_ch2)
            disp('The two sets of filenames are the same.');
        else
            disp('The two sets of filenames are NOT the same.');
            warning('FAILURE FAILURE! The files are NOT the same!');
            return
        end

    IntegInt = [];
    Displacement = [];
    IntByDistance = [];
    Filenames = [];
    for a = 1:length(files_cells)
            
                %todd code
                Filenames(a) = file_cells_ch2{a};
                distance =  [];
                intensity =[];
                distance=str2double(table2array(data(1:end,(a*2) -1))); %using the variable "a" as the multiplier, we will get the correct columns for each file
                intensity = str2double(table2array(data(1:end,(a*2) -0)));
                
                filename_ch2 = file_cells_ch2{a}; %get the filename

                intensity(intensity==0)=nan;
                intensity = noderaw(~any(isnan(intensity),2),:); %keep rows which have no nans
                distance =  x_dist(~any(isnan(x_dist),2),:);
                
        [IntegInt(a), Displacement(a), IntByDistance(a)] = second_channel_intensity(x1(a), x2(a), distance, intensity);

    end
    


    data_table = table(Filenames', Displacement', IntegInt', IntByDistance');


    writetable(data_table, fullfile(path2,'Second_Channel_results.csv'));    

    %%
%end %this is the end for the switch case
    