function [ final_temp_array ] = dynamic_rod ( left_temp, length, ...
                            num_pieces, diffusivity, duration, timestep )
% 
% DESCRIPTION
%
%     Determine temperature as a function of time and position for a thin
%     heated rod.
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

%{
Additional Documentation:
%}

% Check starting values :
%Physical
assert(left_temp >= 0, ...
    'Temperatures are given in Kelvin, and as such must be above absolute zero.');
assert(num_pieces > 0 && rem(num,1) == 0,...
    'You must give a positive, nonzero, integer number of pieces to break the rod into.')
assert(length > 0,'You must give a positive nonzero length for the rod.');
assert(diffusivity
%Temporal
assert(duration >= timestep,...
    'Your duration must be greater than your timestep.');
assert(duration > 0 && duration > timestep,...
    'Your duration must be positive and nonzero.');
assert(timestep > 0, 'Your timestep must be positive and nonzero.');
    

final_temp_array = [ left_temp zeros(1,num_pieces)];
dx = length / num_pieces;
dx_squared = dx^2;

hasnt_warned_yet = true;


PSEUDOCODE

for time zero, until duration, time + timestep
    old = final
    parfor each piece (not the leftmost end) UP UNTIL SECOND-TO-LAST
        new_piece_change_in_temp = ((old_right piece + old_left piece - 2*old_current piece)/dx_squared)
        * diffusivity * timestep;
    end
      if hasnt_warned_yet && abs(change) is > left_temp
            warning('UR VALUES ARE BLOWING UP');
            hasnt_warned_yet = false;
      end
        make changes
end
    
        
    
    
    
    
end % function