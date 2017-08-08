% w=pegasosSGD(X,Y,lambda,nepochs)
% Solve the SVM optimization problem without kernels:
%  w = argmin lambda w'*w + 1/m * sum(max(0,1-Y.*X*w)), NO BIAS HERE		NO BIAS HERE		NO BIAS HERE
% Input:
%  X - matrix of instances (each row is an instance)
%  Y - column vector of labels over {+1,-1}
%  lambda - scalar
%  nepochs - how many times to go over the training set
% Output: 
%  w - column vector of weights
%  

function [w b] = pegasosSGD(X,Y,lambda,nepochs)

[m,d] = size(X);
w = zeros(d,1);
t = 1;
wold=w+1e-3;tol=1e-1*lambda;	W = w;		b = 0;	% VK's line
for i=1:nepochs      % iterations over the full data
    for tau=1:m      % pick a single data point
    %b=mean(Y-X*w);
    T=sqrt(t);	T=t;	Yt=Y(tau);Xt=X(tau,:);YXt=Yt*Xt; 
        if (YXt*w + b < 1)   % distance of data point from  separator is too small          
                               % or data point is on the other side of the separator take a step towards the gradient
            w = (1-1/T)*w + 1/(lambda*T)*YXt';
            b = b + Yt/(lambda*T);
        else
            w = (1-1/T)*w;
        end
        
        %norma(t)=norm(w);
        W = W + w; 				
        %if norm(w-wold)/norm(w) < tol, break,		end,         wold=w;	% VK's line
        t=t+1;         % increment counter
    end
end
w = W/t;
%b=mean(Y-X*w);
%figure,plot(norma)
IterationsPEGASOS = t	% VK's line