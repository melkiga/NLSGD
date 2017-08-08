function [randint] = randint2(n1,n2,ntr)
% Program za generiranje _ntr_ slucajnih integera izmedju 
% broja n1 i n2 tj izmedju _ndata_ brojeva od n1 do n2, BEZ PONAVLJANJA
% Creating NTR random integers between n1 and n2, say
% randint(3,23,6) will pick up 6 random integers between (possibly including too) numbers 3 and 26! NO REPETITION

%if n2 < n1, n = fliplr([n1 n2]);	n1=n(1);n2=n(2); end		% n10=n2;	n2=n1;	n1=n10;
%if n1 == 0,	n1=1;	end
%if ntr > n2-n1,	ntr=n2-n1+1;	end

[val,r1] = sort(rand(1,n2));
%a = r1 + n1 - 1; [val ind] = find(n1 <= a & a <= n2);

%randint = a(ind(1:ntr));



    
  
