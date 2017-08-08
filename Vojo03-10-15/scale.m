function Xs = scale(X)
% Scale the dataset into the one having zero means and unit variances
%   Usage: Xs = scale(X)

Mu = mean(X);		Sd = std(X);
if any(Sd == 0)
    ind = find(Sd == 0);
    error(['Feature ' num2str(ind) ' of X1 cannot be scaled']),return
end
%for i = 1:size(X,2),	    Xs(:,i) = (X(:,i) - Mu(i))/Sd(i);	end

Xs = (X-ones(size(X))*diag(Mu))*diag(1./Sd);