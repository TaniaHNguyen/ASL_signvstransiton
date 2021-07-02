% -------------------------------------------------------------------------
% Find Velocities of transitions 
% -------------------------------------------------------------------------

% Prints cell array on velocities on each word
t_velocities = cell(1,length(tran_coor));
for idx = 1:length(tran_coor)
    tr_idx = tran_coor{1,idx};
    vel = zeros(length(tr_idx{:,1})-1,3);
    for i = 1:length(tr_idx{:,1})-1    
        pos_x = table2array(tr_idx(i+1,2))-table2array(tr_idx(i,2));
        pos_y = table2array(tr_idx(i+1,3))-table2array(tr_idx(i,3));
        pos_z = table2array(tr_idx(i+1,4))-table2array(tr_idx(i,4));
        tim = table2array(tr_idx(i+1,1))-table2array(tr_idx(i,1));
        vel(i,1) = pos_x/tim;
        vel(i,2) = pos_y/tim;
        vel(i,3) = pos_z/tim;
    end
        vel=array2table(vel);
        vel.Properties.VariableNames = {'X-Velocities' 'Y-Velocities' 'Z-Velocities'};
        t_velocities{1,idx}=vel;
end

% Preallocated Space ***** why does it take longer when preallocating??
x_min_vel = cell(length(t_velocities),1);
x_max_vel = cell(length(t_velocities),1);
y_min_vel = cell(length(t_velocities),1);
y_max_vel = cell(length(t_velocities),1);
z_min_vel = cell(length(t_velocities),1);
z_max_vel = cell(length(t_velocities),1);
transition_title = cell(length(t_velocities),1);

% Table of each word's max/min velocity
for A = 1:length(t_velocities)
    grab = t_velocities{1,A};
    x_min_vel{A,1} = min(grab{:,1});
    x_max_vel{A,1} = max(grab{:,1});
    y_min_vel{A,1} = min(grab{:,1});
    y_max_vel{A,1} = max(grab{:,1});
    z_min_vel{A,1} = min(grab{:,1});
    z_max_vel{A,1} = max(grab{:,1});
    transition_title{A,1} = sprintf('Transition %d',A);
end

% Chart for Max & Min velocities of each transition on each axis
mm_t_velocities= table(transition_title,x_min_vel, x_max_vel, y_min_vel, y_max_vel,z_min_vel, z_max_vel);

