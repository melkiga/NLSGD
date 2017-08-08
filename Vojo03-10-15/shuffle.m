function [Xshuffled,Yshuffled] = shuffle(X,Y,n)
    rand('seed',1);
    [val ind] = sort(rand(n,1));
    Xshuffled = X(ind,:);
    Yshuffled = Y(ind);
    
end