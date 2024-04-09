% clc
% clear all
% 
% 
% %path = 'Z:\working\fallest\Projects\Tommy_Mau\Node_Matlab';
% %file = 'Ch3_CASPR.csv';
% 
% [file_ch1, path]=uigetfile('*.csv', 'Choose the First Channel file');
% 
% 
% data = readtable(fullfile(path, file_ch1)); %load the file
% variable_names = data.Properties.VariableNames;
% containsVar = cellfun(@(x) contains(x, 'Var'), variable_names); %logical array to take out the ones that contain 'Var'
% file_cells= variable_names(~containsVar);
% data(1,:)=[];
% 
% 
% for a=1:length(file_cells) %run over a loop of the variables, it'll iterate through the different files in the spreadsheet
%     x_dist =  [];
%     intensity =[];
%     x_dist=str2double(table2array(data(2:end,1*a))); %using the variable "a" as the multiplier, we will get the correct columns for each file
%     intensity = str2double(table2array(data(2:end,2*a)));
%     filename_ch1 = file_cells{a}; %get the filename
%     
% end


x = [1,2,3,4,5];

col2_value = x*2
col2_value = x*2 - 1



