function [bias_SGD,wSGD,Iterations_SGD,Accuracy_SGD,numb_SVecsSGD,Numb_Errors_SGD] = SGD_func(X,Y,lambda,numb_epochs,added_1,choice,etam)
%SGD from VK's code 

[numb_data,dim] = size(X);
maxIter = numb_epochs*numb_data; C = 1/lambda;

if added_1 == 0, wSGD = zeros(dim,1); else wSGD=zeros(dim+1,1);	end
X_SGD = X;

wold = wSGD + 1e-3;	%tol = 1e-2*lambda;	% VK's line, neaded just for STOPPING criterion, which doesn't usually work
iter = 0; w_norm_change = zeros(maxIter,1);	W = wSGD; bias_SGD = 0;

if choice == 1
    R = [];	for i = 1:numb_epochs; R = [R; randint0(numb_data,numb_data)]; end
elseif choice == 3,
    fraction_rand = 0.0002;	numb_rand = max(1,round(fraction_rand*numb_data));
    R = [];	for i = 1:maxIter; R = [R; randint0(numb_data,numb_rand)];	end
end

for t = 1:maxIter
    if choice == 1
        ind = R(t);
    elseif choice == 2
        iter=iter+1; if iter > numb_data, iter = 1;	end, ind=iter; % Data are shuffled and we go cyclically in the loop for SGD here!!!!
    else		% Taking a chunk numb_rand of random data and looking for worst violator among them. DOESN'T WORK QUITE RIGHT and IT'S SLOW!!!
        iter=iter+1;	
        ind0 = R((iter-1)*numb_rand + 1:iter*numb_rand);
        viol = Y(ind0).*(X_SGD(ind0,:)*wSGD); [~,ind] = min(viol);
    end
    x = X_SGD(ind,:); y = Y(ind);
    %eta = 1/(lambda*sqrt(t)); 
    eta = 1/(lambda*t);

    if y*(x*wSGD+bias_SGD) < 1
        wSGD = (1-eta*lambda)*wSGD + eta*y*x' + etam*(wSGD - wold);
        %bias_SGD = bias_SGD + y/(lambda*t);
        %bias_SGD = mean(Y-X_SGD*wSGD);
    else
        wSGD = (1-eta*lambda)*wSGD + etam*(wSGD - wold);
        %bias_SGD = mean(Y-X_SGD*wSGD);
    end
    % norma=norm(wSGD); if norm(wSGD-wold)/norma < tol, break, end	% Just a stopping criterion, but it ususally doesn't work
    if t > 0.5*maxIter,	W = W + wSGD; end,
    w_norm_change(t) = norm(wSGD-wold); wold=wSGD; %if w_norm_change(t) < 1e-5*lambda,	break,	end
end

bias_SGD;
Iterations_SGD = t;
wSGD_LAST = wSGD;
wSGD = W/t;
%if added_1 == 0,	bias_SGD = mean(Y-X_SGD*wSGD);	else,	bias_SGD=0;	end

O = sign(X_SGD*wSGD + bias_SGD);
Numb_Errors_SGD = length(find(Y-O));
Accuracy_SGD = 100 - 100*length(find(Y-O))/length(Y);
%disp('SGD time')

Margin = 1/norm(wSGD);
O = X_SGD*wSGD + bias_SGD;
zeta = Y.*O;						

alfa=atan(wSGD(1)/(-wSGD(2)));		Dist_Sep_Bound = Margin/cos(alfa);
indsvSGD = find(zeta < 1);

numb_SVecsSGD = length(indsvSGD);
end

