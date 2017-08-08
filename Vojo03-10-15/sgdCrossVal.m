function [Iterations_SGD,Accuracy_SGD,Time_SGD,numb_SVecsSGD,Errors_SGD,Accuracy_LIBSVM,tLIBSVM,numb_SVecs_LIBSVM] = sgdCrossVal(numb_data,dim,shift,lambda,numb_epochs,choice,seed0,etam,added_1,data_shift,Quadprog,libsvm,kernel,deg,k)
% Stochastic Gradient Descent, SGD, algorithm, implemented as the classic SGD, for LINEAR SVM	
% bias_QP,Accuracy_Quadprog,tQP,numb_SVecsQP,bias_LIBSVM,Accuracy_LIBSVM,tLIBSVM,numb_SVecs_LIBSVM,
% [bias_SGD,Iterations_SGD,Accuracy_SGD,Time_SGD,numb_SVecsSGD,Errors_SGD,bias_LIBSVM,Accuracy_LIBSVM,tLIBSVM,numb_SVecs_LIBSVM] = sgdCrossVal(numb_data,dim,shift,lambda,numb_epochs,choice,seed0,etam,added_1,data_shift,Quadprog,libsvm,kernel,deg,k)
if ~even(numb_data),numb_data = numb_data + 1;  end

if seed0 ~= 0, rand('seed',seed0), randn('seed',seed0),	end

X = [[2*randn(numb_data/2,1) 0.5*randn(numb_data/2,dim-1)]+data_shift;...
     [0.5*randn(numb_data/2,1) randn(numb_data/2,dim-1)]+data_shift + shift];
Y = [ones(numb_data/2,1);-ones(numb_data/2,1)];	

tSort = cputime; 
[~,ind] = sort(rand(numb_data,1)); X = X(ind,:); Y = Y(ind);	
tSort = cputime - tSort;
X = scale(X);				% DATA SCALING
X0 = X;

if added_1 == 1, X = [X ones(numb_data,1)];	end % ADD BIAS COLUMN

bias_LIBSVM = 0; Accuracy_LIBSVM = 0; tLIBSVM = 0; numb_SVecs_LIBSVM = 0;
% Cross Validation 
CV = cvpartition(numb_data,'kfold',k);
Errors = nan(k,1);
Accuracy = nan(k,1);
tSGD = nan(k,1);
C = 1/lambda;
%% SGD && LIBSVM is below with CV

for K = 1:k
    % Create Train and Test Set
    Xtrain = X(training(CV,K),:);
    Ytrain = Y(training(CV,K),:);
    Xtest = X(test(CV,K),:);
    Ytest = Y(test(CV,K),:);
    
    % SGD Train
    tSGD(K) = cputime;	
    [bias_SGD,wSGD,Iterations_SGD,Accuracy_SGD,numb_SVecsSGD,Numb_Errors_SGD] = ...
        SGD_func(Xtrain,Ytrain,lambda,numb_epochs,added_1,choice,etam);
    % SGD Predict
    O = sign(Xtest*wSGD + bias_SGD);
    Errors(K) = length(find(Ytest-O));
    Accuracy(K) = 100 - 100*Errors(K)/length(Ytest);
    tSGD(K) = (cputime-tSGD(K))+tSort;
end

Accuracy_SGD = mean(Accuracy);
Errors_SGD = mean(Errors);
Time_SGD = mean(tSGD);

if libsvm == 1
    X = X0;
    tLIBSVM = cputime;
    if kernel == 1
        kern = 2;	% Gaussian kernel
        model = svmtrain([],Y, X, ['-t ', num2str(kern), ' -c ', num2str(C), ' -g ', num2str(0.5/s^2)]);
    else
        if deg == 1, kern = 0; else kern = 1; end		% Polynomial kernel
        model = svmtrain([],Y, X, ['-t ', num2str(kern), ' -c ', num2str(C), ' -d ', num2str(deg)]);
    end
    Xtest=X;Ytest=Y;
    [Ytestapprox] = svmpredict(Ytest, Xtest, model); % test the training data				
    %model,bias=full(model.rho),alpha = full(model.sv_coef)', Xsv=full(model.SVs),pause
    %bias_LIBSVM = -model.rho;
    numb_SVecs_LIBSVM = sum(model.nSV);
    Accuracy_LIBSVM = 100 - 100*length(find(Ytest-Ytestapprox))/length(Ytest);
    tLIBSVM = cputime - tLIBSVM;
end
% 
% bias_QP = 0; Accuracy_Quadprog = 0; tQP = 0; numb_SVecsQP = 0;
% if Quadprog == 1			% SVM by quadprog   QUADPROG		QUADPROG		QUADPROG   QUADPROG		QUADPROG		QUADPROG
%     X = X0;
% 	%disp('Below is a CLASSIC L1 SVM solved by QUADPROG')
% 	%Quadprog = 1;
% 	C = 1/lambda;  
% 	tQP = cputime;
% 	G = X*X' + 0;
% 	% QUADPROG Solving Dual Lagrangian for ALPHAs
% 	H = (Y*Y').*G;	H = H + eye(numb_data)*1e-7; %condH = cond(H),	
% 	f = -ones(numb_data,1);
% 	lb = zeros(size(Y));	ub = C*ones(size(Y));
% 	Aeq = Y';	b = 0;	neqcstr = 1;	x0 = zeros(numb_data,1);	options = optimset('maxIter',1e6,'LargeScale','off','Display','off');
% 
% 	alpha = quadprog(H,f,[],[],Aeq,b,lb,ub,x0,options);			Alpha = alpha';
% 	indsv = find(alpha > 1e-3);
% 	numb_SVecsQP = length(indsv);
% 	indsvfree = find(alpha > 1e-3 & alpha < C-1e-8);	indsvbounded = find(alpha > C-1e-3 & alpha < C+1e-3);
% 	AY = [];
% 	for i=1:dim
% 		AY = [AY alpha(indsv).*Y(indsv)];
% 	end
% 
% 	w_All_SVecs = sum(AY.*X(indsv,:));
% 	wQP = w_All_SVecs';
% 	v = (alpha(indsv).*Y(indsv));
% 	bias_QP = bias_calc(alpha,X,Y,C,2,1,1,1e-5);
% 	O = sign(X*wQP+bias_QP);
% 	Accuracy_Quadprog = 100 - 100*length(find(Y-O))/length(Y);
% 	%disp('QUADPROG TIME')	
% 	tQP = cputime-tQP;
	
% 	if dim == 2
% 		x_for_plotting=[min(min(X(:,1))):0.25:max(max(X(:,1)))];		
% 		k2 = wSGD(1)/(-wSGD(2));
% 		l2 = bias_SGD/(-wSGD(2));
% 		y_opt_pinv2 = k2*x_for_plotting+l2;
% 		plot(x_for_plotting,y_opt_pinv2,'r','linewidth',1.5)
% 		plot(X(indsvSGD,1),X(indsvSGD,2),'k+','linewidth',1)
% 		
% 		k3 = wQP(1)/(-wQP(2));
% 		l3 = bias_QP/(-wQP(2));
% 		y_opt_pinv3 = k3*x_for_plotting+l3;
% 		plot(x_for_plotting,y_opt_pinv3,'b','linewidth',1.5)
% 		if added_1 == 0;
% 			plot(x_for_plotting,y_opt_pinv2 + Dist_Sep_Bound,'r:','linewidth',1.)
% 			plot(x_for_plotting,y_opt_pinv2 - Dist_Sep_Bound,'r:','linewidth',1.)	
% 			axis([(min(X(:,1)))-0.5 (max(X(:,1)))+2 (min(X(:,2)))-0.5 (max(X(:,2)))+2])				
% 			legend('Class +','Class -', 'SGD Sep Line', 'SVecs SGD', 'Pos Margin SGD','Neg Margin SGD', 'Quadprog Sep Line')
% 		else
% 			legend('Class +','Class -', 'SGD Sep Line', 'SVecs SGD', 'Quadprog Sep Line')
% 		end
% 		title('Datapoints and linear separation boundaries for SGD and Quadprog')
% 	end


% if Quadprog == 1
% 	numb_SVecs_SGD_QP = [numb_SVecsSGD numb_SVecsQP]
% 	Accuracies_SGD_Quadprog = [Accuracy_SGD Accuracy_Quadprog]
% 	if Accuracy_SGD > Accuracy_Quadprog
% 		disp('Accuracy of SGD is better than the QUADPROG'' one')
% 	elseif Accuracy_SGD == Accuracy_Quadprog
% 	 disp('Accuracies of SGD and QUADPROG are EQUAL')
% 	else
% 		disp('Accuracy of QUADPROG is better than the SGD''s one')
% 	end
% 		if t2+t0 < tQP
% 			disp(['SGD is ', num2str(tQP/(t2+t0)), ' times faster than QUADPROG'])
% 		elseif t2+t0 == tQP
% 			disp('Same speed for SGD and QUADPROG')
% 		else
% 			disp(['SGD is ', num2str((t2+t0)/tQP), ' times slower than QUADPROG'])
% 		end	
% 
% 	if added_1 == 0;	Ratio_of_Weights = (wSGD./wQP'),	else,		Ratio_of_Weights = (wSGD./[wQP' bias_QP]),  end
% else 
% 	if libsvm==1,	
% 	numb_SVecs_SGD_QP = [numb_SVecsSGD numb_SVecs_LIBSVM]
% 		Accuracy_SGD_LIBSVM = [Accuracy_SGD Accuracy_LIBSVM],	
% 		if t2+t0 < tLIBSVM
% 			disp(['SGD is ', num2str(tLIBSVM/(t2+t0)), ' times faster than LIBSVM'])
% 		elseif t2+t0 == tLIBSVM
% 			disp('Same speed for SGD and LIBSVM')
% 		else
% 			disp(['SGD is ', num2str((t2+t0)/tLIBSVM), ' times slower than LIBSVM'])
% 		end			
% 	end
% end
% 
% 
% figure(2),		plot(w_norm_change), title('Change in the weight difference norm'),xlabel('Iterations')
% 
% if dim == 2,		figure(1),		end
% 
% 
% 
% C,   format long,		lambda_C_tol = [lambda C tol];	format short


