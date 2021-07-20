% ------------------------------------------------------------------------
% Combine Minimum and Maximum velocities + TSNE fourier 
% ------------------------------------------------------------------------

load new_combine
load fourier_table

% TSNE of fft of all items
tsneX = tsne(cell2mat(fourier_table(:,1:end-1)));
tsneX = num2cell(tsneX);
new_combine = table2cell(new_combine);
mm_tsne_chart = [new_combine(:,1:7) tsneX new_combine(:,end)];

% Apply support vector machine -------------------------------------------

% Train and Test Data
train_amount = floor(length(mm_tsne_chart)*0.8);
train_rand = randperm(length(mm_tsne_chart), train_amount);
train = mm_tsne_chart(train_rand,:);

test_rand = setdiff(1:length(mm_tsne_chart),train_rand); 
test = mm_tsne_chart(test_rand,:);
    
trainX = cell2mat(train(:,2:end-1));
trainY = cell2mat(train(:,end)).';
testX = cell2mat(test(:,2:end-1));
testY = cell2mat(test(:,end)).'; 


% Train the classifier with the training data and labels
Mdl = fitcecoc(trainX,trainY);
predictions = predict(Mdl,testX);
testing_accuracy = sum(testY==predictions.')/length(testY)*100;
disp(['SVM Testing Accuracy: ' num2str(testing_accuracy) '%.']);

% Random Trees ------------------------------------------------------------------------
nTrees=500;
B = TreeBagger(nTrees,trainX,trainY, 'Method', 'classification'); 
predChar1 = B.predict(testX);  % Predictions is a char though. We want it to be a number.
c = str2double(predChar1);
consistency=sum(c==testY)/length(testY);
accuracy_rf = mean(consistency);
disp(['Random Forest Testing Accuracy: ' num2str(accuracy_rf*100) '%.']);

% Naive Bayes -------------------------------------------------------------------------
Nb = fitcnb(trainX,trainY);
predict_nb = predict(Nb,testX);
Nb_accuracy = sum(testY==predict_nb.')/length(testY)*100;
disp(['Naive Bayes Testing Accuracy: ' num2str(Nb_accuracy) '%.']);

% LDA (Linear Discriminant Analysis) ---------------------------------------------------------------------
lda = fitcdiscr(trainX,trainY);
predict_lda = predict(lda,testX);
lda_accuracy = sum(testY==predict_lda.')/length(testY)*100;
disp(['LDA Testing Accuracy: ' num2str(Nb_accuracy) '%.']);


