function [even] = even(number)
% Checks whether the number is an even or an odd one. Paran-Neparan?
% If EVEN, the even = 1, otherwise EVEN = 0. 

even = 1;

if abs(round(number/2) - number/2)  > 0
even = 0;
end


