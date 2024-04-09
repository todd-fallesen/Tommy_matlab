function [nodeLength, x1, x2] = nodelengthcalculatorLive(distance, noderaw, pixelSize)

% also need: 'intersections' function (Douglas Schwarz,
% http://uk.mathworks.com/matlabcentral/fileexchange/11837-fast-and-robust-curve-intersections/content/intersections.m

%nodelengthcalculator computes the node length byt calculating the full
%width half max of lack of intensity between two positive paranodes. As in
%Arancibia-Carcamo et al., elife 2017.

%filename must be the full path to a .csv file containing the caspr
%intensity profile obtained in imageJ. The data must have 1 column with the
%distance and the second column must contain the intensities.

%The node length is calculated in whatever units the first column of the
%csv file is.

%A plot showing the raw intesity profile, a smoothed (by rolling average)
%intensity profile, the peak intensities for each paranode, the minimum 
%intensity at the node,and the points at which the FWHM are measured will also
%be displayed

    
    
    % adjust parameters
    level           = 0.5; % set where the point at which to read the fullwidth. For FWHM the level should be 0.5
    
    % smooth the data
    intensity = movmean(noderaw,5);
    
    
    % find min intensity in a bounded area around the middle of the trace
    upperNodeBoundary   = round((length(distance)/2)+1/6*(length(distance)));
    lowerNodeBoundary   = round((length(distance)/2)-1/6*(length(distance)));
    
    NodeSection      = lowerNodeBoundary:upperNodeBoundary;      % indices of middle section
    NodeMinIntensity = min(intensity(NodeSection));              % min intensity VALUE in middle section
    minIdx           = find(intensity == NodeMinIntensity);      % index (in regard to whole trace) of that value
    
    % find peak in first paranode area
    PN1UpperBoundary    = minIdx;
    PN1LowerBoundary    = 1;
    PN1section          = PN1LowerBoundary : PN1UpperBoundary;      % indices of max section
    PN1Peak             = max(intensity(PN1section));               % max intensity VALUE in bounded area before middle min intensity
    PN1PeakIdx          = intensity==PN1Peak;
    
 
    % find peak in second paranode area
    PN2LowerBoundary    = minIdx;
    PN2UpperBoundary    = round((length(distance)));
    PN2Section          = PN2LowerBoundary : PN2UpperBoundary;      % indices of max section
    PN2Peak             = max(intensity(PN2Section));               % max intensity VALUE in bounded area after middle min intensity
    PN2Idx              = intensity==PN2Peak;
    
    % find inbetween value between max and min
    PN1HalfMax       = ((PN1Peak - NodeMinIntensity)* level)+ NodeMinIntensity;
    PN2HalfMax       = ((PN2Peak - NodeMinIntensity)* level)+ NodeMinIntensity;
   
    % plot trace, add straight line at HalfMax for each paranode
    figure;
    plot(distance,intensity)
    hold on
    plot(distance,noderaw,'k:');
    plot(distance(minIdx),NodeMinIntensity,['*','r']);
    plot(distance(PN2Idx),PN2Peak,['*', 'g']);
    plot(distance(PN1PeakIdx),PN1Peak,['*','g']);
    line(distance([1 minIdx]),[PN1HalfMax PN1HalfMax]);
    line(distance([minIdx end]),[PN2HalfMax PN2HalfMax]);
    
    %find intersection point of line and data
    y1 = [PN1HalfMax PN1HalfMax];
    [intersecPN1] = intersections(distance,intensity,distance([1, minIdx]),y1);
    y2 = [PN2HalfMax PN2HalfMax]; 
    [intersecPN2] = intersections(distance,intensity,distance([minIdx, end]),y2);
    
    % Highlight the intersection points closest to the node
    plot(max(intersecPN1), PN1HalfMax, 'ro', 'MarkerSize', 8);
    plot(min(intersecPN2), PN2HalfMax, 'ro', 'MarkerSize', 8);
    plot(max(intersecPN1),PN1HalfMax, ['*', 'b']);
    plot(min(intersecPN2),PN2HalfMax, ['*','b']);
    
    x1 = max(intersecPN1); %where the positions are that the ends of the nodes are in the x-axis
    x2 = min(intersecPN2);
    
    % calculate distance between relevant intersection points
    nodeLength = (min(intersecPN2)-max(intersecPN1))*pixelSize;
    
    title([' Node Length: ' num2str(nodeLength), ' um']);
    hold off
    
    
    
    
     
    