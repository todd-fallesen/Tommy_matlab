clear all;
clc;
close all;
rootpath    = uigetdir;
files       = dir([rootpath '/*.csv']);

pixelSize = 1;


for a = 1:length(files)
    data = csvread([rootpath '/' files(a).name],2,0);

    filename        = files(a).name(1:end-4);
    rawIntensity    = data(1:end,2:2:end);
    rawIntensity(rawIntensity==0)=nan;
    

    [row,col] = size(rawIntensity);
      for i=1:col
          noderaw = rawIntensity(1:end,i);
    isnan(noderaw);
    ~any(isnan(noderaw));
    noderawno_nans = noderaw(~any(isnan(noderaw),2),:); %keep rows which have no nans
    
    distance        = data(~any(isnan(noderaw),2),2*i-1);
    
    [nodeLength(i)] = nodelengthcalculatorLIVE(distance, noderawno_nans, pixelSize);
    
    % Create a PNG filename.
	pngFileName = sprintf('%s_%d',filename, i);
	fullFileName = fullfile(rootpath, pngFileName);
		
	% Then save it
	print(fullFileName, '-dpng');
    close all
    
    
      end
   
   
   
   
end 

csvwrite(fullfile(rootpath,'noderesults.csv'),nodeLength);


    