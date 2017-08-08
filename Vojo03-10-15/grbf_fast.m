function [G] = grbf_fast(Data,center,s);
% GRBF_FAST calculates the design matrix G(# of data, # of centers). Auckland 2002.
% GRBF_FAST is THE FASTET version FOR GRBF in MATLAB for a diagonal covariance matrix.
% You can give s as a single scalar but s WILL BE THEN TRANSFORMED INTO a VECTOR of STD. DEVS. (1, dim). 
% GAUSSIANS MAY HAVE SAME or DIFFERENT VARIANCES !!!
% Written by Vojislav Kecman - VCU, Richmond, VA, The University of Auckland, New Zealand
% First versions written in Yugoslavia and Germany
% 	Program description:
% 	Inputs:		Data, centers and s must be of same dimensionality
% 		Data		  Input pattern for training 		
%			center		Matrix of the Gaussian centers
%   		s		    scalar OR VECTOR for a shape of Gaussians (IF SCALAR, ALL GAUSSIANS have same shape)
%	Output:  matrix G, 				Copyright (c) 1991-2015 by Vojislav KECMAN
[nd,dimd]=size(Data)	;
[nc,dimc]=size(center);if dimc ~= dimd;	disp('Data and centers must have same dimension');	return;	end;
 if length(s) == 1,		 	s = s*ones(1,dimd);			end
	if length(unique(s)) ~= 1	
 		disp('All variances must be equal for using GRBF_FAST,');	
		disp('             or, use GRBF! ');			return
	end

x = diag(1./s)*Data';	c = diag(1./s)*center';

xx = sum(x.*x,1); 		cc = sum(c.*c,1); 		xc = x'*c; 
d = (repmat(xx',[1 size(cc,2)]) + repmat(cc,[size(xx,2) 1]) - 2*xc);		

G = exp(-0.5*d);



