function [ final_temp_array ] = dynamic_rod ( left_temp, length, ...
                            num_pieces, diffusivity, duration, timestep )
% 
% DESCRIPTION
%
%     Determine temperature as a function of time and position for a thin
%     heated rod. The left end is attached to a heating element, while the
%     right end is insulated.
%     
%
% ARGUMENTS
%                         
%     left_temp         temperature of left end of rod (Kelvin)
% 
%     length            length of rod (meters)
% 
%     num_pieces        number of sections into which we break rod
%                          for numerical calculations and output
% 
%     diffusivity       coeff of thermal diffusivity
%                          (m*m/s)
% 
%     duration          total time over which to run simulation
%                          (seconds)
% 
%     timestep          timestep for simulation (seconds)
% 
% 
% RETURNS
% 
%     final_temp_array  an array of temperature values,
%                          one per piece of rod
% 
% AUTHOR
%     Kevin Granger <kmg2728@rit.edu>
%     2013-01-25


% Check starting values :

%Physical
assert(left_temp >= 0, ...
    'Temperatures are given in Kelvin, and as such must be above absolute zero.');
assert(num_pieces > 0 && rem(num_pieces,1) == 0,...
    'You must give a positive, nonzero, integer number of pieces to break the rod into.')
assert(length > 0,'You must give a positive nonzero length for the rod.');
assert(diffusivity > 0, 'Diffusivity must be positive and nonzero.');
%Temporal
assert(duration >= timestep,...
    'Your duration must be greater than your timestep.');
assert(duration > 0 && duration > timestep,...
    'Your duration must be positive and nonzero.');
assert(timestep > 0, 'Your timestep must be positive and nonzero.');


% Set up initial values:

% Build the initial array of temperatures for the rod. Yes, it says final,
% but it's going to get put on the old value at the start of the loop
% anyway.
final_temp_array = [ left_temp zeros(1,num_pieces)];
% Also create an array for the change in temp each step, so that we can
% track our values and see if anything's blowing up.
change_in_temp = zeros(1,num_pieces+1);
% The size of each fraction of rod is the length divided by the number of
% pieces.
dx = length / num_pieces;
% But, we only use dx^2 in calculations anyway, so why not save us some
% time each loop?
dx_squared = dx^2;

% This will have the loop warn us that our values are starting to explode
% only once. 
warned_yet = false;


%The main body of the program:

for time=0:timestep:duration
    % copy over the last used temperatures to be used for this loop
    old_temp_array = final_temp_array;
    
    % for each piece that isn't an insulated endpiece, or the heat source:
    % (in parallel, if enabled on your machine)
    parfor i=2:num_pieces
        change_in_temp(i) = ((old_temp_array(i-1) + old_temp_array(i+1)...
            - (2*old_temp_array(i))) / dx_squared)...
            * diffusivity * timestep;
    end
    
    % Now work on the insulated piece
    change_in_temp(end) = -diffusivity *...
        (old_temp_array(end) - old_temp_array(end-1)) * timestep;
    
    %If the change in temperature is greater than the temperature of the
    %heating element, that means that the simulation is likely blowing up.
    %Still, keep running in case this is desired behavior, and only warn
    %once.
    if (~warned_yet) && abs(max(change_in_temp)) > left_temp
        warning('VALUES ARE BLOWING UP');
        warned_yet = true;
    end
    
    %Finally, apply changes to the temperature, and loop again if there's
    %time left.
    final_temp_array = final_temp_array + change_in_temp;
end

%Shave off temperature source
final_temp_array = final_temp_array(2:end);
    
end % function