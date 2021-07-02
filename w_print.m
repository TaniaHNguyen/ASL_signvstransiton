% -------------------------------------------------------------------------
% Prints 3D Graphs of signs only
% -------------------------------------------------------------------------

% ts = time series files
% Find all coordinates btwn each word's time frame
% Make sure time in excel sheet is pasted number, not equation
ts = readtable('Batch1.xlsx');
word_coor = cell(1,length(T{:,1}));
for row= 1
    for word = 1:length(word_coor)
        % Index start and end time of T data table
        ws = T{word,2};
        we = T{word,3};
        word_st = ws;
        word_ed = we;

        % In case of offset in motion capture
        offset_mc = 1.32;
        correct_time= ts{:,2}+offset_mc;
        % i=index of closest value in ts,mi=difference of 2 times
        [m,i]= min(abs(correct_time-word_st));
        [n,j]= min(abs(correct_time-word_ed));
        
        % Create table for word
        F=ts(i:j,2:5);
        
        
        % Cell Arrary with All matrices of words
        word_coor{row,word} = F;
    end
    
end

% Finding max and min x,y,z coordinates for scale 
m_chart=zeros(length(word_coor),6);
for each=1:length(word_coor)
    word_m = word_coor{1,each};
    x_min = min(word_m{:,2});
    x_max = max(word_m{:,2});
    y_min = min(word_m{:,3});
    y_max = max(word_m{:,3});
    z_min = min(word_m{:,4});
    z_max = max(word_m{:,4});
    m_chart(each,1)=x_min;
    m_chart(each,2)=x_max;
    m_chart(each,3)=y_min;
    m_chart(each,4)=y_max;
    m_chart(each,5)=z_min;
    m_chart(each,6)=z_max;
end
maxs_chart = array2table(m_chart);
all_x_min = min(maxs_chart{:,1});
all_x_max = max(maxs_chart{:,2});
all_y_min = min(maxs_chart{:,3});
all_y_max = max(maxs_chart{:,4});
all_z_min = min(maxs_chart{:,5});
all_z_max = max(maxs_chart{:,6});

% for each=1:length(word_coor) % Plot all figures
% % for each=25 % number/range of figure/s
%     thisfig=figure();
%     % Plot 3D graph of each word
%     plot_word = word_coor{1,each};
%     x= plot_word{:,2}; % 2:back/forth
%     y= plot_word{:,4}; % 3:right/left
%     z= plot_word{:,3}; % 4:up/down
%     plot3(x,y,z)
%     xlabel('x - back/forth')
%     ylabel('z - right/left')
%     zlabel('y - up/down')
%     C= table2cell(T(each,1));
%     B= string(C);
%     title(sprintf('%s',B));
%     xlim([floor(all_x_min/10)*10 ceil(all_x_max/10)*10]);
%     zlim([floor(all_y_min/10)*10 ceil(all_y_max/10)*10]);
%     ylim([floor(all_z_min/10)*10 ceil(all_z_max/10)*10]);
% 
% end

