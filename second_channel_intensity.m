%%Want to make a function that sums the intensity between the two full
%%width half max points on the data. Because the original code found the
%%FWHM from interpolation, we've got to find the original data point that
%%is closest to that

%1.) input the data
%2.) Find the closest points to the FWHM points
%3.) Sum the intensity between those points
%4.) Return the integrated intensity and the intensity divided by distance

function [IntegInt, Displacement, IntByDistance] = second_channel_intensity(x_start, x_end, distance, data)

%section 1, import the data
distance2= data(:,1);

%section 2, find the closest FWHM points
    [row_start, col_start, start_value] = nearest_value(x_start, distance);
    [row_end, col_end, end_value] = nearest_value(x_end, distance);

%section 3 find the intensity and length of the anti-node thing
Displacement = end_value - start_value;
IntegInt = sum(data(row_start:row_end, 1));

%section 4, integrated intesntiy by length
IntByDistance = IntegInt/Displacement;


    

    
%this is a nested function. 
    function [row, col, value] = nearest_value(value, dataset)
       
        % Calculate absolute differences
        abs_diff= abs(dataset - value);

        % Find the minimum absolute difference
        [min_diff, min_index] = min(abs_diff(:));

        % Convert linear index to row and column indices
        [row, col] = ind2sub(size(dataset), min_index);
        value = dataset(row,col);
    end

end