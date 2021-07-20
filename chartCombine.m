% -------------------------------------------------------------------------
% Combining the max and min Velocity charts of the signs and Transitions
%
% July 7, 2021: Added duration (length of coordinates in words/transitions)
% -------------------------------------------------------------------------
load word_coor
load tran_coor

load mm_w_velocities % only for batch 1
load mm_t_velocities % only for batch 1 
mm_w_velocities.Properties.VariableNames = {'Item' 'x_min_vel' 'x_max_vel'...
    'y_min_vel' 'y_max_vel' 'z_min_vel' 'z_max_vel' 'label'};
mm_t_velocities.Properties.VariableNames = {'Item' 'x_min_vel' 'x_max_vel'...
    'y_min_vel' 'y_max_vel' 'z_min_vel' 'z_max_vel' 'label'};

d = cell(length(word_coor)+length(tran_coor),1);
for i=1:length(word_coor) 
    d{i,1} = height(word_coor{:,i});
end
for i=1:length(tran_coor)
    d{i+length(word_coor),1} = height(tran_coor{:,i});
end

duration = num2cell(d);
dur = cell2table(duration);


combine = [mm_w_velocities; mm_t_velocities;];
load ASL_data % only for batch 1 
new_combine = [combine{:,1:7} dur combine{:,8}];
new_combine.Properties.VariableNames = {'Item' 'x_min_vel' 'x_max_vel'...
    'y_min_vel' 'y_max_vel' 'z_min_vel' 'z_max_vel' 'duration' 'label'};

% Finds empty rows in combine data
empty_indices = find(cellfun('isempty',new_combine{:,2}));

% Chart of New combine (removed empty rows)
new_combine(empty_indices ,:) = [];


% Removes items that exceed ExceedVal (over this value are 
% the items that contain long trantition (transitions between sentences))
ExceedVal = 70;
d = cell2mat(d);
ir = d > ExceedVal; 
irrelavant = d(ir); % The values
idx = find(ir); % index of the values
d(ir) = [];
new_combine([idx],:) = [];

% Apply support vector machine -------------------------------------------
x = cell2mat(table2array(new_combine(:,2:end-1)));

% x(empty_indices ,:) = [];
y = cell2mat(num2cell(table2array(new_combine(:,end)))).';
% y(:,empty_indices) = [];
md1=fitcecoc(x,y);

% Train and Test Data
train_amount = floor(height(new_combine)*0.8);
train_rand = randperm(height(new_combine), train_amount);
train = new_combine(train_rand,:);

test_rand = setdiff(1:height(new_combine),train_rand); 
test = new_combine(test_rand,:);
    
trainX = cell2mat(train{:,2:end-1});
trainY = cell2mat(num2cell(train{:,end})).';
testX = cell2mat(test{:,2:end-1});
testY = cell2mat(num2cell(test{:,end})).'; 


% Train the classifier with the training data and labels
Mdl = fitcecoc(trainX,trainY);
predictions = predict(Mdl,testX);
testing_accuracy = sum(testY==predictions.')/length(testY)*100;
disp(['m&m SVM Testing Accuracy: ' num2str(testing_accuracy) '%.']);

% Random Trees ------------------------------------------------------------------------
nTrees=500;
B = TreeBagger(nTrees,trainX,trainY, 'Method', 'classification'); 
predChar1 = B.predict(testX);  % Predictions is a char though. We want it to be a number.
c = str2double(predChar1);
consistency=sum(c==testY)/length(testY);
accuracy_rf = mean(consistency);
disp(['m&m Random Forest Testing Accuracy: ' num2str(accuracy_rf*100) '%.']);

% K-Nearest Neighbors -----------------------------------------------------
kn = fitcknn(trainX,trainY);
predict_kn = predict(kn,testX);
kn_accuracy = sum(testY==predict_kn.')/length(testY)*100;
disp(['m&m K-Nearest Neighbor Testing Accuracy: ' num2str(kn_accuracy) '%.']);

% LDA (Linear Discriminant Analysis) ---------------------------------------------------------------------
lda = fitcdiscr(trainX,trainY,'discrimType','pseudoLinear');
predict_lda = predict(lda,testX);
lda_accuracy = sum(testY==predict_lda.')/length(testY)*100;
disp(['m&m LDA Testing Accuracy: ' num2str(lda_accuracy) '%.']);


