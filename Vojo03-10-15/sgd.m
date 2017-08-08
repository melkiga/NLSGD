function [] = sgd(numb_data,dim,shift,lambda,numb_epochs,choice,seed0,etam)
% Stochastic Gradient Descent, SGD, algorithm, implemented as the classic SGD, for LINEAR SVM	
% Up to 500 data it compares with QUADPROG. If more data not!
% sgd(10,2,2,1e0,2,1,0,0.5)
close all, format compact, pause(1)
Quadprog = 0;		libsvm = 0;		added_1 = 0;					% added_1 = 1, means there is no BIAS, because we have an EXPLICITE BIAS TERM 
data_shift = 10000;	kernel = 2; deg=1;	% kernel and degree needed for LIBSVM

if ~even(numb_data),numb_data = numb_data + 1;  end

if seed0 ~= 0, rand('seed',seed0),		randn('seed',seed0),	end
X = [randn(numb_data/2,dim)+data_shift;   randn(numb_data/2,dim)+data_shift + shift];	Y = [ones(numb_data/2,1);-ones(numb_data/2,1)];	

	X=[[2*randn(numb_data/2,1) 0.5*randn(numb_data/2,dim-1)]+data_shift;...
	   [0.5*randn(numb_data/2,1) randn(numb_data/2,dim-1)]+data_shift + shift];
	Y = [ones(numb_data/2,1);-ones(numb_data/2,1)];	

meanX=mean(X);	norma_meanX=norm(meanX);
% shuffling data, which makes everything stochastic, JUST to avoid choosing random index below in SGD loop.
t0=cputime; 
	[val ind] = sort(rand(numb_data,1));	X=X(ind,:);	Y=Y(ind);	
t0=cputime-t0;
X=scale(X);				% DATA SCALING
X0=X;

if added_1 == 1,	X = [X ones(numb_data,1)];	end

	indp=find(Y==1);indn=find(Y==-1);
	if dim==2,		plot(X(indp,1),X(indp,2),'ro'),hold on,plot(X(indn,1),X(indn,2),'bo'),grid,	end	

% SGD is below		SGD is below		SGD is below		SGD is below		SGD is below		SGD is below		SGD is below		SGD is below
t2=cputime;									% SGD is below		SGD is below		SGD is below		SGD is below		SGD is below		SGD is below
maxIter = numb_epochs*numb_data;	C = 1/lambda;

if added_1 == 0,	w2 = zeros(dim,1);		else,		w2=zeros(dim+1,1);	end
X2=X;

wold = w2 + 1e-3;			tol = 1e-2*lambda;	% VK's line, neaded just for STOPPING criterion, which doesn't usually work
iter = 0;			w_norm_change = zeros(maxIter,1);		W = w2;			bias_SGD = 0;

if choice == 1
	R = [];		for i = 1:numb_epochs;		R  = [R; randint0(numb_data,numb_data)];	end
end
	
for t = 1:maxIter
	if choice == 1
		ind = R(t);
	else
		iter=iter+1;	if iter > numb_data,	iter = 1;	end,	ind=iter;% Data are shuffled and we go cyclically in the loop for SGD here!!!!
	end
	x = X2(ind,:);		y = Y(ind);

	eta = 1/(lambda*sqrt(t));		eta = 1/(lambda*t);
	
	if y*x*w2+bias_SGD < 1
		w2 = (1-eta*lambda)*w2 + eta*y*x' + etam*(w2 - wold);
		%bias_SGD = bias_SGD + y/(lambda*t);
		%bias_SGD = mean(Y-X2*w2);
	else
		w2 = (1-eta*lambda)*w2 + etam*(w2 - wold);
		%bias_SGD = mean(Y-X2*w2);
	end
	% norma=norm(w2); 	if norm(w2-wold)/norma < tol, break,		end	% Just a stopping criterion, but it ususally doesn't work
	if t > 0.5*maxIter,	W = W + w2;		end,
  w_norm_change(t) = norm(w2-wold);				wold=w2; %if w_norm_change(t) < 1e-5*lambda,	break,	end
end
bias_SGD
Iterations_SGD = t
w2_LAST = w2;
w2 = W/t;
%if added_1 == 0,	bias_SGD = mean(Y-X2*w2);	else,	bias_SGD=0;	end

O = sign(X2*w2 + bias_SGD);
Accuracy_SGD = 100 - 100*length(find(Y-O))/length(Y)
disp('SGD time')
t2=cputime-t2
Margin = 1/norm(w2)
O = X2*w2 + bias_SGD;
zeta = Y.*O;	figure(4),plot(zeta),figure(1)
indSV = find(zeta < 1);

%figure(3),plot(zeta),pause

numb_SVecs = length(indSV)

if length(w2)<101	,			wSGD = w2',		end

if dim == 2 & numb_data > 500
	x_for_plotting=[min(min(X(:,1))):0.25:max(max(X(:,1)))];
	k2 = w2(1)/(-w2(2));
	l2 = bias_SGD/(-w2(2));
	y_opt_pinv2 = k2*x_for_plotting+l2;
	plot(x_for_plotting,y_opt_pinv2,'r','linewidth',1.5)
	plot(x_for_plotting,y_opt_pinv2+Margin,'b:','linewidth',1.5)
	plot(x_for_plotting,y_opt_pinv2-Margin,'b','linewidth',1.5)	
	title('Datapoints and linear separation boundary for SGD')
			legend('Class +','Class -', 'SGD Sep Line')
	axis([(min(X(:,1)))-0.5 (max(X(:,1)))+2 (min(X(:,2)))-0.5 (max(X(:,2)))+2])		
end

if numb_data <=500			% SVM by quadprog   QUADPROG		QUADPROG		QUADPROG   QUADPROG		QUADPROG		QUADPROG
X=X0;
	disp('Below is a CLASSIC L1 SVM solved by QUADPROG')
	Quadprog = 1;
	C = 1/lambda;  % ???, Possibly C = 1/lambda only
	tQP=cputime;
	G = X*X' + 0;
	% QUADPROG Solving Dual Lagrangian for ALPHAs
	H = (Y*Y').*G;			H = H + eye(numb_data)*1e-7;%condH = cond(H),	
	f = -ones(numb_data,1);
	lb = zeros(size(Y));	ub = C*ones(size(Y));
	Aeq = Y';	b = 0;	neqcstr = 1;	x0 = zeros(numb_data,1);	options = optimset('maxIter',1e6,'LargeScale','off','Display','off');

	alpha = quadprog(H,f,[],[],Aeq,b,lb,ub,x0,options);			Alpha = alpha';
	indsv = find(alpha > 1e-3);
	indsvfree = find(alpha > 1e-3 & alpha < C-1e-8);	indsvbounded = find(alpha > C-1e-3 & alpha < C+1e-3);
	AY = [];
	for i=1:dim
		AY = [AY alpha(indsv).*Y(indsv)];
	end

	w_All_SVecs = sum([AY].*X(indsv,:) )
	wQP = w_All_SVecs';
	v = (alpha(indsv).*Y(indsv));
	bias_QP = bias_calc(alpha,X,Y,C,2,1,1,1e-5)
	O = sign(X*wQP+bias_QP);
	Accuracy_Quadprog = 100 - 100*length(find(Y-O))/length(Y);
	disp('QUADPROG TIME')	
	tQP=cputime-tQP;
	
	if dim == 2
		x_for_plotting=[min(min(X(:,1))):0.25:max(max(X(:,1)))];		
		k2 = w2(1)/(-w2(2));
		l2 = bias_SGD/(-w2(2));
		y_opt_pinv2 = k2*x_for_plotting+l2;
		plot(x_for_plotting,y_opt_pinv2,'r','linewidth',1.5)
		axis([(min(X(:,1)))-0.5 (max(X(:,1)))+2 (min(X(:,2)))-0.5 (max(X(:,2)))+2])		
		
		k3 = wQP(1)/(-wQP(2));
		l3 = bias_QP/(-wQP(2));
		y_opt_pinv3 = k3*x_for_plotting+l3;
		plot(x_for_plotting,y_opt_pinv3,'b','linewidth',1.5)
		legend('Class +','Class -', 'SGD Sep Line','Quadprog Sep Line')
		Accuracies_SGD_Quadprog = [Accuracy_SGD Accuracy_Quadprog]
		title('Datapoints and linear separation boundaries for SGD and Quadprog')
	end
else		%    below is a LIBSVM SOLVER		LIBSVM SOLVER		LIBSVM SOLVER		LIBSVM SOLVER
	X=X0;	libsvm=1;
	tLIBSVM=cputime;
  if kernel == 1
  	kern=2;	% Gaussian kernel
		model = svmtrain([],Y, X, ['-t ', num2str(kern), ' -c ', num2str(C), ' -g ', num2str(0.5/s^2)]);
	else
	 	if deg==1,kern=0;else,kern=1;end		% Polynomial kernel
		model = svmtrain([],Y, X, ['-t ', num2str(kern), ' -c ', num2str(C), ' -d ', num2str(deg)]);
	end
	Xtest=X;Ytest=Y;
	[Ytestapprox, accuracy, dec_values] = svmpredict(Ytest, Xtest, model); % test the training data				
	%model,bias=full(model.rho),alpha = full(model.sv_coef)', Xsv=full(model.SVs),pause
	%bias = -model.rho;	numb_SVecs = sum(model.nSV);
	numb_SVecs_LIBSVM = sum(model.nSV)
	Accuracy_LIBSVM = 100 - 100*length(find(Ytest-Ytestapprox))/length(Ytest);
	tLIBSVM=cputime - tLIBSVM
end

if Quadprog == 1
	Accuracy_SGD_Quadprog = [Accuracy_SGD Accuracy_Quadprog]
	if Accuracy_SGD > Accuracy_Quadprog
		disp('Accuracy of SGD is better than the QUADPROG'' one')
	elseif Accuracy_SGD == Accuracy_Quadprog
	 disp('Accuracies of SGD and QUADPROG are EQUAL')
	else
		disp('Accuracy of QUADPROG is better than the SGD''s one')
	end
		if t2+t0 < tQP
			disp(['SGD is ', num2str(tQP/(t2+t0)), ' times faster than QUADPROG'])
		elseif t2+t0 == tQP
			disp('Same speed for SGD and QUADPROG')
		else
			disp(['SGD is ', num2str((t2+t0)/t1), ' times slower than QUADPROG'])
		end	
	Ratio_of_Weights = (w2./wQP)'
else 
	if libsvm==1,	
		Accuracy_SGD_LIBSVM = [Accuracy_SGD Accuracy_LIBSVM],	
		if t2+t0 < tLIBSVM
			disp(['SGD is ', num2str(tLIBSVM/(t2+t0)), ' times faster than LIBSVM'])
		elseif t2+t0 == tLIBSVM
			disp('Same speed for SGD and LIBSVM')
		else
			disp(['SGD is ', num2str((t2+t0)/tLIBSVM), ' times slower than LIBSVM'])
		end			
	end
end


figure(2),		plot(w_norm_change), title('Change in the weight difference norm'),xlabel('Iterations')

if dim == 2,		figure(1),		end



C,   format long,		lambda_C_tol = [lambda C tol];	format short


