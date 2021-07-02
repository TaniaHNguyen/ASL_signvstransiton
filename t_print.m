% -------------------------------------------------------------------------
% Prints 3D Graphs of transitions only
% -------------------------------------------------------------------------

% Find all coordinates btwn each word's time frame 
ts = readtable('Batch1.xlsx');
tran_coor = cell(1,length(transition_table{:,1}));
for row= 1
    for tr = 1:length(tran_coor)
        % Index start and end time of T data table
        t_start = transition_table{tr,1};
        t_end = transition_table{tr,2};

        % In case of offset in motion capture
        offset_mc = 1.32;
        cor_time= ts{:,2}+offset_mc;
        % i=index of closest value in ts,mi=difference of 2 times
        [m,i]= min(abs(cor_time-t_start));
        [n,j]= min(abs(cor_time-t_end));
        
        % Create table for word
        N=ts(i:j,2:5);
        
        
        % Cell Arrary with All matrices of words
        tran_coor{row,tr} = N;
    end
    
end

% Finding max and min x,y,z coordinates for scale 
t_chart=zeros(length(tran_coor),6);
for each=1:length(tran_coor)
    tran_t = tran_coor{1,each};
    t_x_min = min(tran_t{:,2});
    t_x_max = max(tran_t{:,2});
    t_y_min = min(tran_t{:,3});
    t_y_max = max(tran_t{:,3});
    t_z_min = min(tran_t{:,4});
    t_z_max = max(tran_t{:,4});
    t_chart(each,1)=t_x_min;
    t_chart(each,2)=t_x_max;
    t_chart(each,3)=t_y_min;
    t_chart(each,4)=t_y_max;
    t_chart(each,5)=t_z_min;
    t_chart(each,6)=t_z_max;
end
maxs_chart = array2table(t_chart);
t_all_x_min = min(maxs_chart{:,1});
t_all_x_max = max(maxs_chart{:,2});
t_all_y_min = min(maxs_chart{:,3});
t_all_y_max = max(maxs_chart{:,4});
t_all_z_min = min(maxs_chart{:,5});
t_all_z_max = max(maxs_chart{:,6});

% % Plotting 3D Figures
% for each=1:length(tran_coor) % Plot all figures
% % for each=25 % number/range of figure/s
%     thisfig=figure();
%     % Plot 3D graph of each word
%     plot_tran = tran_coor{1,each};
%     x= plot_tran{:,2}; % 2:back/forth
%     y= plot_tran{:,4}; % 3:right/left
%     z= plot_tran{:,3}; % 4:up/down
%     plot3(x,y,z) 
%     xlabel('x - back/forth')
%     ylabel('z - right/left')
%     zlabel('y - up/down')
%     title(sprintf('Transition %d',each));
%     xlim([floor(t_all_x_min/10)*10 ceil(t_all_x_max/10)*10]);
%     zlim([floor(t_all_y_min/10)*10 ceil(t_all_y_max/10)*10]);
%     ylim([floor(t_all_z_min/10)*10 ceil(t_all_z_max/10)*10]);
% 
% end
