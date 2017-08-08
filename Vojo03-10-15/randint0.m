function [randint] = randint0(N,ntr)
% Program za generiranje _ntr_ slucajnih integera izmedju 
% brojeva 1 : N , BEZ PONAVLJANJA
% Creating NTR random integers between 1:N, say
% randint(23,6) will pick up 6 random integers between 1 and 23 (possibly, also including) numbers 1 and 23! NO REPETITION

[val,randind] = sort(rand(N,1));
randint = randind(1:ntr);



    
  
