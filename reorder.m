% Data of Shoeboxdata
sb = readtable('Batch1_Shoebox_NA.xlsx');
% t1 = sb(startsWith(sb.Column1,'\Gloss'),:);
% find(sb(strcmp(sb.Column1,'\Gloss'),:))

index = find(strcmp(sb{:,1},'\Gloss'));
st_idx=sb{index+1,2};
en_idx=sb{index+2,2};
Words=sb{index,2};

% in case of need offset in annotations
offset_anot_batch1 = 0.266;
% Batch 1 has no annotation offset
Start=cellfun(@str2num,st_idx)+offset_anot_batch1;
End=cellfun(@str2num,en_idx)+offset_anot_batch1;

% Final Table w/ Words, Start Time, End Time
T=table(Words, Start, End);
T(1:size(index,1),:);

% Transition Time
tran_tab=zeros(length(T{:,1})-1,2);
r=1;
for i=1:length(T{:,1})-1
    Tran_st= T{i,3};
    Tran_ed=T{i+1,2};
    tran_tab(r,1)=Tran_st;
    tran_tab(r,2)=Tran_ed;
    r=r+1;
end
hc={'Start Transition' 'End Transition'};
transition_table = cell2table([num2cell(tran_tab)]);
transition_table.Properties.VariableNames = {'Start Transition' 'End Transition'};

% Export Table
%writetable(T,'reorder.xlsx','Sheet',1);
