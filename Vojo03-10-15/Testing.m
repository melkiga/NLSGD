
%% Tesing script for SGD
% different numbers of data [20, 50, 100, 500, 1000, 10000, 500000]
% different dimensionality [2 100 500] --> only if the data > dim
% different lambda values [1e-2 1e-1 1e0 1e1 1e2 1e3 ~1e5?]
% with or without bias--> added_1 = [0 1]
% number of epochs [1 10 20]
% play with eta as well--> 1/lambda*sqrt(t) or 1/lambda*t
% play with bias values (how to update)
% play with stopping criteria
% RETURN: bias, iterations, num_errors, margin, nSV, time
% ,bias_QP{l,e}(i,j),...
% Accuracy_Quadprog{l,e}(i,j),tQP{l,e}(i,j),numb_SVecsQP{l,e}(i,j),...
% 

clear; clc; close all, format compact;

%% Initialize Algorithm Parameter Values
data_shift = 0;
Quadprog = 0;	% if n < 501
added_1 = 0;	% added_1 = 1, means there is EXPLICITE BIAS TERM
libsvm = 1;	kernel = 2; deg = 1; % kernel and degree needed for LIBSVM	 

k = 10;
%1. n = [20 50 100 500 1000 10000 50000];
n = [50000];
nlen = length(n);
%1. dim = [2 100 500]; % only if n > dim
dim = [100];
ndim = length(dim);
shift = 1; % shift = 2; maybe play with shift value, if dim is high, use 2
lambda = [1e-2 1e-1 1e0 1e1 1e2 1e3]; % could also try 1e5 or 1e-3
nlam = length(lambda);
nepochs = [1 10 20];
nepo = length(nepochs);
choice = 2; % choice 3 doesn't work quite right, so try 1||2
seed = 0;
etam = 0.5;
bias_SGD = cell(nlam,1);
Iterations_SGD = cell(nlam,1);
Accuracy_SGD = cell(nlam,1);
tSGD = cell(nlam,1);
numb_SVecsSGD = cell(nlam,1);
Errors_SGD = cell(nlam,1);
% bias_QP = cell(nlam,1);
% Accuracy_Quadprog = cell(nlam,1);
% tQP = cell(nlam,1);
% numb_SVecsQP = cell(nlam,1);
bias_LIBSVM = cell(nlam,1);
Accuracy_LIBSVM = cell(nlam,1);
tLIBSVM = cell(nlam,1);
numb_SVecs_LIBSVM = cell(nlam,1);

%% CVa
for e = 1:nepo
    for l = 1:nlam
        for i = 1:ndim
            for j = 1:nlen
                if dim(i) < n(j)
                    [Iterations_SGD{l,e}(i,j),Accuracy_SGD{l,e}(i,j),...
                     tSGD{l,e}(i,j),numb_SVecsSGD{l,e}(i,j),Errors_SGD{l,e}(i,j),...
                     Accuracy_LIBSVM{l,e}(i,j),tLIBSVM{l,e}(i,j),...
                     numb_SVecs_LIBSVM{l,e}(i,j),] = sgdCrossVal(n(j),dim(i),shift,...
                     lambda(l),nepochs(e),choice,seed,etam,added_1,data_shift,Quadprog,libsvm,kernel,deg,k);  
                end
                fprintf('Done with numb_data %d \n',j);
            end
            fprintf('Done with dim %d \n',i);
        end
        fprintf('Done with Lambda %d \n',l);
    end
    fprintf('Done with epoch %d \n',e);
end

%% Build Table
for e = 1:nepo
    varNames{e} = sprintf('Epochs%d',nepochs(e));
end

for l = 1:nlam
    RowNames{l} = sprintf('Lambda%d',lambda(l));
end

AccuracyResults = cell2table(Accuracy_SGD,'VariableNames',varNames,'RowNames',RowNames);
TimeResults = cell2table(tSGD,'VariableNames',varNames,'RowNames',RowNames);
SVResults = cell2table(numb_SVecsSGD,'VariableNames',varNames,'RowNames',RowNames);

AccuracyResults_LIBSVM = cell2table(Accuracy_SGD,'VariableNames',varNames,'RowNames',RowNames);
TimeResults_LIBSVM = cell2table(tSGD,'VariableNames',varNames,'RowNames',RowNames);
SVResults_LIBSVM = cell2table(numb_SVecsSGD,'VariableNames',varNames,'RowNames',RowNames);

clearvars e l i j
%% ANALYSIS
% tSGDFin = tSGD+tSort;
% if Quadprog == 1
%     fprintf('Number of SV SGD: %d QP: %d \n',numb_SVecsSGD,numb_SVecsQP);
% 	%numb_SVecs_SGD_QP = [numb_SVecsSGD numb_SVecsQP]
%     fprintf('Accuracy SGD: %.2f QP: %.2f \n',Accuracy_SGD,Accuracy_Quadprog);
% 	%Accuracies_SGD_Quadprog = [Accuracy_SGD Accuracy_Quadprog]
% 	if Accuracy_SGD > Accuracy_Quadprog
% 		disp('Accuracy of SGD is better than the QUADPROG'' one')
% 	elseif Accuracy_SGD == Accuracy_Quadprog
% 	 disp('Accuracies of SGD and QUADPROG are EQUAL')
% 	else
% 		disp('Accuracy of QUADPROG is better than the SGD''s one')
%     end
%     if tSGDFin < tQP
%         disp(['SGD is ', num2str(tQP/(tSGDFin)), ' times faster than QUADPROG'])
%     elseif tSGDFin == tQP
%         disp('Same speed for SGD and QUADPROG')
%     else
%         disp(['SGD is ', num2str((tSGDFin)/tQP), ' times slower than QUADPROG'])
%     end	
% 
% 	if added_1 == 0;	
%         Ratio_of_Weights = (wSGD./wQP')	
%     else
%         Ratio_of_Weights = (wSGD./[wQP' bias_QP])
%     end
% elseif libsvm == 1	
%     fprintf('Number of SV SGD: %.2f LIBSVM: %.2f \n',numb_SVecsSGD,numb_SVecs_LIBSVM);
% 	%numb_SVecs_SGD_QP = [numb_SVecsSGD numb_SVecs_LIBSVM]
%     fprintf('Accuracy SGD: %.2f QP: %.2f \n',Accuracy_SGD,Accuracy_LIBSVM);
%     %Accuracy_SGD_LIBSVM = [Accuracy_SGD Accuracy_LIBSVM],	
%     if tSGDFin < tLIBSVM
%         disp(['SGD is ', num2str(tLIBSVM/(tSGDFin)), ' times faster than LIBSVM'])
%     elseif tSGDFin == tLIBSVM
%         disp('Same speed for SGD and LIBSVM')
%     else
%         disp(['SGD is ', num2str((tSGDFin)/tLIBSVM), ' times slower than LIBSVM'])
%     end			
% end