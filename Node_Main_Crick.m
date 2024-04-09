%% Clear all and close all

clear all;
clc;
close all;

    [file_ch1, path1]=uigetfile('*.csv', 'Choose the First Channel file');
    [file_ch2, path2]=uigetfile('*.csv', 'Choose the Second Channel file');

%%
    data = readtable(fullfile(path1, file_ch1)); %load the file
    variable_names = data.Properties.VariableNames;
    containsVar = cellfun(@(x) contains(x, 'Var'), variable_names); %logical array to take out the ones that contain 'Var'
    file_cells_ch1= variable_names(~containsVar);
    data(1,:)=[];


    pixelSize = 1;
    filenames = {};
    x1 = [];
    x2 = [];

%%
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
                fullFileName = fullfile(path1, pngFileName);

                % Then save it
                print(fullFileName, '-dpng');
                close all


                data_out(a).Filename=filename_ch1;
                data_out(a).nodeLength=nodeLength(a);
                data_out(a).x1 = x1(a);
                data_out(a).x2 = x2(a);






    end 
    data_out = struct2table(data_out);
    writetable(data_out,fullfile(path1,'noderesults.csv'));


%%% Second channel stuff




data_ch2 = readtable(fullfile(path2, file_ch2));                %load the file
variable_names = data_ch2.Properties.VariableNames;             %get the variable names
containsVar = cellfun(@(x) contains(x, 'Var'), variable_names); %logical array to take out the ones that contain 'Var'
file_cells_ch2= variable_names(~containsVar);                   %removes the VarX names from the list of file names
data_ch2(1,:)=[];                                               %pulls off the first row which is variable names again.  Comment this out if you don't have variable names in row one


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
for a = 1:length(file_cells_ch2)

            %todd code
            
            distance =  [];
            intensity =[];
            distance=str2double(table2array(data(1:end,(a*2) -1))); %using the variable "a" as the multiplier, we will get the correct columns for each file
            intensity = str2double(table2array(data(1:end,(a*2) -0)));

            filename_ch2 = file_cells_ch2{a}; %get the filename

            intensity(intensity==0)=nan;
            intensity = noderaw(~any(isnan(intensity),2),:); %keep rows which have no nans
            distance =  x_dist(~any(isnan(x_dist),2),:);
            Filenames{a} = filename_ch2;

    [IntegInt(a), Displacement(a), IntByDistance(a)] = second_channel_intensity(x1(a), x2(a), distance, intensity);

end



data_table = table(Filenames', Displacement', IntegInt', IntByDistance');


writetable(data_table, fullfile(path2,'Second_Channel_results.csv'));    

%%
%end %this is the end for the switch case
