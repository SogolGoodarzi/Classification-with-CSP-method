%% Sogol Goodarzi  810198467   HW#5
%% Change the averages of each channel to zero
clear;
load('hw5.mat');
for i=1:60
    for j=1:30
        TrainData_class1(j,:,i) = TrainData_class1(j,:,i)-mean(TrainData_class1(j,:,i));
        TrainData_class2(j,:,i) = TrainData_class2(j,:,i)-mean(TrainData_class2(j,:,i));
    end
end
for i=1:40
    for j=1:30
        TestData(j,:,i) = TestData(j,:,i)-mean(TestData(j,:,i));
    end
end
%% Part(a): CSP
R1 = zeros(30,30);
for k=1:60
    R1 = R1+TrainData_class1(:,:,k)*(TrainData_class1(:,:,k))';
end
R1 = R1/60;
R2 = zeros(30,30);
for k=1:60
    R2 = R2+TrainData_class2(:,:,k)*(TrainData_class2(:,:,k))';
end
R2 = R2/60;
[U,D] = eig(R1,R2);
[~, index] = sort(diag(D));
W_csp =[];
for k=length(index):-1:1
    W_csp = [W_csp,U(:,index(k))./norm(U(:,index(k)))];
end
W1 = W_csp(:,1);
W30 = W_csp(:,30);
class1_49_W1 = W1'*TrainData_class1(:,:,49);
class1_49_W30 = W30'*TrainData_class1(:,:,49);
subplot(2,1,1);
plot(class1_49_W1,'b','DisplayName','Filter:W_1');
hold on 
plot(class1_49_W30,'r','DisplayName','Filter:W_{30}');
legend show
ylabel("$Var(W_i^TX)$",'Interpreter','latex')
title("Filtered 49th test of class 1");
hold off
class2_49_W1 = W1'*TrainData_class2(:,:,49);
class2_49_W30 = W30'*TrainData_class2(:,:,49);
subplot(2,1,2);
plot(class2_49_W1,'b','DisplayName','Filter:W_1');
hold on 
plot(class2_49_W30,'r','DisplayName','Filter:W_{30}');
legend show
ylabel("$Var(W_i^TX)$",'Interpreter','latex')
title("Filtered 49th test of class 2");
hold off
Var = [var(class1_49_W1),var(class1_49_W30);var(class2_49_W1),var(class2_49_W30)];
fprintf("Variance of the 49th test for both classes:\n             Filter:W1     Filter:W30\n Var(Class1):%0.3f           %0.3f",Var(1,1),Var(1,2));
fprintf("\n Var(Class2):%0.3f           %0.3f\n",Var(2,1),Var(2,2));
%% Part(b): 
subplot(2,1,1);
plot(abs(W1),'b');
ylabel("$|W_1(t)|$",Interpreter="latex");
title("Absolute value of the first filter (W_1(t))");
subplot(2,1,2);
plot(abs(W30),'b');
ylabel("$|W_{30}(t)|$",Interpreter="latex");
title("Absolute value of the last filter (W_{30}(t))");
%% Part(c): LDA
W14 = [W_csp(:,1:7),W_csp(:,24:30)];
for k=1:60
    Class1_filtered_W14(:,:,k) = W14'*TrainData_class1(:,:,k);
    Class2_filtered_W14(:,:,k) = W14'*TrainData_class2(:,:,k);
    feature_class1(:,:,k) = (var(Class1_filtered_W14(:,:,k)'))';
    feature_class2(:,:,k) = (var(Class2_filtered_W14(:,:,k)'))';
end
Sum1 = zeros(14,1);
Sum2 = zeros(14,1);
for k=1:60
    Sum1 = Sum1 + feature_class1(:,:,k);
    Sum2 = Sum2 + feature_class2(:,:,k);
end 
mu1 = Sum1./60;
mu2 = Sum2./60;
Mu_matrix = (mu1-mu2)*(mu1-mu2)';
S1 = zeros(14,14);
S2 = zeros(14,14);
for i=1:60
    S1 = S1 + (feature_class1(:,:,i)-mu1)*(feature_class1(:,:,i)-mu1)';
    S2 = S2 + (feature_class2(:,:,i)-mu2)*(feature_class2(:,:,i)-mu2)';
end
cov_class1 = S1./60;
cov_class2 = S2./60;
Cov_matrix = cov_class1 + cov_class2;
[W_,D_] = eig(Mu_matrix,Cov_matrix);
[~, index] = sort(diag(D_));
W_LDA = W_(:,index(end));
W_LDA = W_LDA./norm(W_LDA);
mu_1 = W_LDA'*mu1;
mu_2 = W_LDA'*mu2;
c = 1/2*(mu_1+mu_2);
fprintf("W_LDA :\n");
fprintf("%g \n",W_LDA);
fprintf("c : %.4f \n",c);
%% Part(d): Labeling Test data
for k=1:40
    Test_filtered_W14(:,:,k) = W14'*TestData(:,:,k);
    feature_Test(:,:,k) = (var(Test_filtered_W14(:,:,k)'))';
    feature_WLDA(:,:,k) = W_LDA'* feature_Test(:,:,k);
end
label = [];
for i=1:40
    comparison = feature_WLDA(:,:,i)>c;
    if(comparison == 1)
        label = [label,1];
    else 
        label = [label,2];
    end
end
%% Part(e): plotting true and estimated labels
number_tests = 1:length(TestLabel);
scatter(number_tests,TestLabel,'blue');
hold on
scatter(number_tests,label,'*r');
ylim([0,3]);
legend("True Labels","Estimated Labels");
xlabel("Number of tests",Interpreter="latex");
ylabel("Class of the data",Interpreter="latex");
title("Scatter plot of the true labels and estimated ones");
hold off








