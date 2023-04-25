clc
clear

tStart = cputime
Path = 'S:\3_dynamic_simulations';
raw_data_table = readtable([Path, '\data_input_ann_svm.xlsx']);
data = rmmissing(raw_data_table{:,1:3});
[training_data, test_data] = dividerand(data', 0.7, 0.3);
training_data = training_data';
train_inputs = training_data(:, 1:2);
train_output = training_data(:, 3);
test_data = test_data';
test_inputs = test_data(:, 1:2);
test_output = test_data(:, 3);

rng(0);


%% SVM

disp('------SVM------')

Model = fitrsvm(train_inputs,train_output,'KernelFunction','rbf','Standardize',true);

% train SVM model

predict_train_output = predict(Model,train_inputs);
train_mse = immse(predict_train_output,train_output);
train_rsquare = 1 - sum((train_output - predict_train_output).^2)/sum((train_output - mean(train_output)).^2);
disp(['Training resub MSE is ', num2str(train_mse)])
disp(['Training resub R2 is ', num2str(train_rsquare)])

% save results for training set

train_errors= train_output - predict_train_output;
train_accuracy = 1-abs(train_errors./train_output);
train_average_accuracy = mean(train_accuracy);
disp(['Train_Average Accuracy: ', num2str(train_average_accuracy)]);

OutputData(:,1) = train_output;
OutputData(:,2) = predict_train_output;
OutputData(:,3) = train_accuracy;
OutputData(2,4) = train_average_accuracy;
OutputData(2,5) = train_mse;
OutputData(2,6) = train_rsquare;

HeadLine(1,1) = "Train_Target";
HeadLine(1,2) = 'Train_Predicted Value'; 
HeadLine(1,3) = 'Train_Accuracy';
HeadLine(1,4) = 'Train_Average_Accuracy';
HeadLine(1,5) = 'Train_MSE';
HeadLine(1,6) = 'Train_Rsquare';

% test SVM model

predict_test_output = predict(Model, test_inputs);
test_mse = immse(predict_test_output,test_output);
test_rsquare = 1 - sum((test_output - predict_test_output).^2)/sum((test_output - mean(test_output)).^2);
disp(['Test MSE is ', num2str(test_mse)]);
disp(['Test R2 is ', num2str(test_rsquare)]);

% New measurement

RTest = corrcoef(predict_test_output,test_output);
RSquareTest = RTest(2:2)*RTest(2:2);
disp(['New R^2 of Test Set (1/3) ',num2str(RSquareTest)])

% Save result for test set

test_errors= test_output - predict_test_output;
test_accuracy = 1-abs(test_errors./test_output);
test_average_accuracy = mean(test_accuracy)
disp(['Average Accuracy: ', num2str(test_average_accuracy)]);

tEnd = cputime - tStart

OutputData1(:,7) = test_output;
OutputData1(:,8) = predict_test_output;
OutputData1(:,9) = test_accuracy;
OutputData1(2,10) = test_average_accuracy;
OutputData1(2,11) = test_mse;
OutputData1(2,12) = test_rsquare;

HeadLine1(1,7) = "Test_Target";
HeadLine1(1,8) = 'Test_Predicted Value'; 
HeadLine1(1,9) = 'Test_Accuracy';
HeadLine1(1,10) = 'Test_Average Accuracy';
HeadLine1(1,11) = 'Test_MSE';
HeadLine1(1,12) = 'Test_Rsquare';


OutputDataA = [HeadLine; OutputData];
OutputDataB = [HeadLine1; OutputData1];

xlswrite([Path '\data_output_svm(train)'], OutputDataA);
xlswrite([Path '\data_output_svm(test)'], OutputDataB);
save([Path '\SVM25'],'Model')

disp(['CPU Time is ', num2str(tEnd)]);


