% ------------------------------------------------------------------------
% All Velocities Chart
% ------------------------------------------------------------------------
clear 
load w_velocities
load t_velocities

load ASL_data
all_vel = [w_velocities,t_velocities];

% Finds empty rows in combine data
empty_indices = find(cellfun('isempty',combine{:,2}));

% Chart of New combine (removed empty rows)
all_vel(:,empty_indices) = [];


% Creates d: list of all the lengths of the items
for i=1:length(w_velocities) 
    k=w_velocities{1,i};
    d{i,1} = height(k);
end
for i=1:length(t_velocities)
    k=t_velocities{1,i};
    d{i+length(w_velocities),1} = height(k);
end

% Removes items that exceed ExceedVal (over this value are 
% the items that contain long trantition (transitions between sentences))
ExceedVal = 70;
d = cell2mat(d);
ir = d > ExceedVal; 
irrelavant = d(ir); % The values
idx = find(ir); % index of the values
d(ir) = [];
all_vel(:,[idx]) = [];

% Max length of all item -> Let's us know width of columns
max_length = max(d);
 

% Fills in space of items with length < max_length with repeated last value
revised_vel = cell(length(all_vel), max_length*3);
for i = 1:length(all_vel)
    k = all_vel{1,i};
    k = table2cell(k);
    if size(k,1) < max_length
        fil_vel = cell(max_length,3);
        last_x = k(size(k,1),1);
        last_y = k(size(k,1),2);
        last_z = k(size(k,1),3);
        fil_vel(1:size(k,1),1:3) = k;
        fil_vel(size(k,1)+1:end,1) = last_x;
        fil_vel(size(k,1)+1:end,2) = last_y;
        fil_vel(size(k,1)+1:end,3) = last_z;
        long_fv = fil_vel(:)';
        revised_vel(i,:) = long_fv;
    else
        long_k = k(:)';
        revised_vel(i,:) = long_k;
    end
end
        
% Final chart with item names, all velocities, and label
item = combine{:,1};
item([empty_indices,],:) = [];
item([idx,],:) = [];
label = combine{:,end};    
label([empty_indices,],:) = [];
label([idx],:) = [];
all_vel_chart = [item revised_vel label];

% Apply support vector machine -------------------------------------------
x = cell2mat(all_vel_chart(:,2:end-1));

% x(empty_indices ,:) = [];
y = cell2mat(all_vel_chart(:,end)).';
% y(:,empty_indices) = [];
md1=fitcecoc(x,y);

% Train and Test Data
train_amount = floor(size(all_vel_chart,1)*0.8);
train_rand = randperm(size(all_vel_chart,1), train_amount);
train = all_vel_chart(train_rand,:);

test_rand = setdiff(1:size(all_vel_chart,1),train_rand); 
test = all_vel_chart(test_rand,:);

trainX = cell2mat(train(:,2:end-1));
trainY = cell2mat((train(:,end)).');
testX = cell2mat(test(:,2:end-1));
testY = cell2mat((test(:,end)).'); 

% Train the classifier with the training data and labels
Mdl = fitcecoc(trainX,trainY);
predictions = predict(Mdl,testX);
testing_accuracy = sum(testY==predictions.')/length(testY)*100;
disp(['SVM Testing Accuracy: ' num2str(testing_accuracy) '%.']);

%Artificial Neural Network Using Matlab;
net = patternnet(10);
% mynet.trainParam.epochs=300;
[net, tr] = train(net,trainX.',trainY');

view(net)
pred2 = round(net(testX.'));
testing_accuracy = sum(testY==pred2)/length(testY)*100;
disp(['ANN Testing Accuracy: ' num2str(testing_accuracy) '%.']);

    
   

