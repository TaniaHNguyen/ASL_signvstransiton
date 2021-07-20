% ------------------------------------------------------------------------
% Fourier Transform of all Velocity Data 
% ------------------------------------------------------------------------
load w_velocities
load t_velocities
load ASL_data
all_vel = [w_velocities,t_velocities];

% Finds empty rows in combine data
empty_indices = find(cellfun('isempty',combine{:,2}));

% Chart of New combine (removed empty rows)
all_vel(:,empty_indices) = [];

d = cell(length(w_velocities)+length(t_velocities),1);
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



% fourier length
fl = 30;

fourier_table = cell(length(all_vel),fl*6+1);
% Do signs and transition fourier table seperately first
for i = 1:length(all_vel)
    get= all_vel{1,i};
    get = table2cell(get);
    get= cell2mat(get);
    if size(get,1) ~= 1
        fourier = fft(get,fl);
        x_real = real(fourier(:,1));
        x_imag = imag(fourier(:,1));
        y_real = real(fourier(:,2));
        y_imag = imag(fourier(:,2));
        z_real = real(fourier(:,3));
        z_imag = imag(fourier(:,3));
        new = [x_real',x_imag',y_real',y_imag',z_real',z_imag'];
        new = num2cell(new);
        fourier_table(i,1:end-1) = new;
    else 
        x_fourier = fft(get(1,1),fl)';
        x_real = real(x_fourier);
        x_imag = imag(x_fourier);
        y_fourier = fft(get(1,2),fl)';
        y_real = real(y_fourier);
        y_imag = imag(y_fourier);
        z_fourier = fft(get(1,3),fl)';
        z_real = real(z_fourier);
        z_imag = imag(z_fourier);
        new = [x_real',x_imag',y_real',y_imag',z_real',z_imag'];
        new = num2cell(new);
        fourier_table(i,1:end-1) = new;
    end
end

label_word = num2cell(1);
label_tran = num2cell(0);
fourier_table(1:length(w_velocities),fl*6+1) = label_word;
fourier_table(length(w_velocities)+1:end,fl*6+1) = label_tran;


% Train and test sets -------------------------------------------
x = cell2mat(fourier_table(:,1:end-1));

% x(empty_indices ,:) = [];
y = cell2mat(fourier_table(:,end)).';
% y(:,empty_indices) = [];
md1=fitcecoc(x,y);

% Train and Test Data
train_amount = floor(size(fourier_table,1)*0.8);
train_rand = randperm(size(fourier_table,1), train_amount);
train = fourier_table(train_rand,:);

test_rand = setdiff(1:size(fourier_table,1),train_rand); 
test = fourier_table(test_rand,:);
    
trainX = cell2mat(train(:,1:end-1));
trainY = cell2mat(train(:,end)).';
testX = cell2mat(test(:,1:end-1));
testY = cell2mat(test(:,end)).'; 

% SVM ---------------------------------------------------------------------
% Train the classifier with the training data and labels
Mdl = fitcecoc(trainX,trainY');
predictions = predict(Mdl,testX);
testing_accuracy = sum(testY==predictions.')/length(testY)*100;
disp(['fft SVM Testing Accuracy: ' num2str(testing_accuracy) '%.']);

 % Random Trees -----------------------------------------------------------
nTrees=500;
B = TreeBagger(nTrees,trainX,trainY, 'Method', 'classification'); 
predChar1 = B.predict(testX);  % Predictions is a char though. We want it to be a number.
c = str2double(predChar1);
consistency=sum(c==testY)/length(testY);
accuracy_rf = mean(consistency);
disp(['fft Random Forest Testing Accuracy: ' num2str(accuracy_rf*100) '%.']);

% K-Nearest Neighbors -----------------------------------------------------
kn = fitcknn(trainX,trainY);
predict_kn = predict(kn,testX);
kn_accuracy = sum(testY==predict_kn.')/length(testY)*100;
disp(['fft K-Nearest Neighbor Testing Accuracy: ' num2str(kn_accuracy) '%.']);

% LDA (Linear Discriminant Analysis) --------------------------------------
lda = fitcdiscr(trainX,trainY,'discrimType','pseudoLinear');
predict_lda = predict(lda,testX);
lda_accuracy = sum(testY==predict_lda.')/length(testY)*100;
disp(['fft LDA Testing Accuracy: ' num2str(lda_accuracy) '%.']);



