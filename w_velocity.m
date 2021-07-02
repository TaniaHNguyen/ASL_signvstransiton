% -------------------------------------------------------------------------
% Find Velocities of signs 
% -------------------------------------------------------------------------

% Prints cell array on velocities on each word
w_velocities = cell(1,length(word_coor));
for idx = 1:length(word_coor)
    wd_idx = word_coor{1,idx};
    vel = zeros(length(wd_idx{:,1})-1,3);
    for i = 1:length(wd_idx{:,1})-1    
        pos_x = table2array(wd_idx(i+1,2))-table2array(wd_idx(i,2));
        pos_y = table2array(wd_idx(i+1,3))-table2array(wd_idx(i,3));
        pos_z = table2array(wd_idx(i+1,4))-table2array(wd_idx(i,4));
        tim = table2array(wd_idx(i+1,1))-table2array(wd_idx(i,1));
        vel(i,1) = pos_x/tim;
        vel(i,2) = pos_y/tim;
        vel(i,3) = pos_z/tim;
    end
        vel=array2table(vel);
        vel.Properties.VariableNames = {'X-Velocities' 'Y-Velocities' 'Z-Velocities'};
        w_velocities{1,idx}=vel;
end

% Preallocated Space ***** why does it take longer when preallocating??
x_min_vel = cell(length(w_velocities),1);
x_max_vel = cell(length(w_velocities),1);
y_min_vel = cell(length(w_velocities),1);
y_max_vel = cell(length(w_velocities),1);
z_min_vel = cell(length(w_velocities),1);
z_max_vel = cell(length(w_velocities),1);


% Table of each word's max/min velocity
for A = 1:length(w_velocities)
    grab = w_velocities{1,A};
    x_min_vel{A,1} = min(grab{:,1});
    x_max_vel{A,1} = max(grab{:,1});
    y_min_vel{A,1} = min(grab{:,1});
    y_max_vel{A,1} = max(grab{:,1});
    z_min_vel{A,1} = min(grab{:,1});
    z_max_vel{A,1} = max(grab{:,1});
end

% Chart for Max & Min velocities of each sign on each axis
mm_w_velocities= table(Words,x_min_vel, x_max_vel, y_min_vel, y_max_vel,z_min_vel, z_max_vel);

