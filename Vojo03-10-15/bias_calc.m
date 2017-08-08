function bias = bias_calc(alpha,x,y,C,kernel,parameters,coeff_for_order_1b,tacno)

	indSV=find(alpha >= tacno);	xSV=x(indSV,:);	ySV=y(indSV);	alfa=alpha(indSV);	alfaY=alfa.*ySV;

	ind_Free = find(alpha >= tacno & alpha <= C-tacno)';	% elimination of alfas that are equal C, 
	if ~isempty(ind_Free)
		X_Free = x(ind_Free,:);				Y_Free = y(ind_Free);
			if kernel == 1
				G2 = grbf_fast(X_Free,xSV,parameters);
			else
				if parameters == 1,	G2 = (X_Free*xSV'+coeff_for_order_1b);	else;		G2 = (X_Free*xSV'+1).^parameters;	end
			end
		bias = sum(Y_Free - G2*alfaY)/length(Y_Free); % biasEqCons=EQUAL_CONSTR_NNLSC_no_BIAS;% follows from Eq. for b (2.57b)

	else,		%disp('Bounded vectors only - NNLS_C')
			if kernel == 1
				G2 = grbf_fast(xSV,xSV,parameters);	
			else
				if parameters == 1,G2 = (xSV*xSV'+coeff_for_order_1b);	else,	G2 = (xSV*xSV'+1).^parameters;	end
			end
		bias = sum(ySV - G2*alfaY)/length(ySV);	%	bias=EQUAL_CONSTR_NNLSC_no_BIAS,			biasEqCons=EQUAL_CONSTR_NNLSC_no_BIAS;

	end			
