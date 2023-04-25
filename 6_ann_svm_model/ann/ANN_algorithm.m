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


%% ANN

% tStart = cputime

disp('------ANN------')

trainFcn = 'trainlm';
hiddenLayerSize = 5;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 0/100;
net.trainParam.showWindow = false;

[net,tr] = train(net,train_inputs',train_output');

% train ANN model 

predict_train_output = net(train_inputs')';
train_mse = immse(predict_train_output,train_output);
train_rsquare = 1 - sum((train_output - predict_train_output).^2)/sum((train_output - mean(train_output)).^2);
disp(['Train MSE is ', num2str(train_mse)])
disp(['Train R^2 is ', num2str(train_rsquare)])

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

% test ANN model
predict_test_output = net(test_inputs')';
test_mse = immse(predict_test_output,test_output);
test_rsquare = 1 - sum((test_output - predict_test_output).^2)/sum((test_output - mean(test_output)).^2);
disp(['Test MSE is ', num2str(test_mse)]);
disp(['Test R^2 is ', num2str(test_rsquare)]);


% Save results for test set

test_errors= test_output - predict_test_output;
test_accuracy = 1-abs(test_errors./test_output);
test_average_accuracy = mean(test_accuracy);
disp(['Test_Average_Accuracy: ', num2str(test_average_accuracy)]);

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
xlswrite([Path '\data_output_ann(train)'], OutputDataA);
xlswrite([Path '\data_output_ann(test)'], OutputDataB);
save([Path '\data_output_ann1'],'net')

tEnd = cputime - tStart
disp(['CPU Time is ', num2str(tEnd)]);

