program rddisttestk, rclass
	/* This program tests whether a discrete RD running variable
	exhibits manipulation at the threshold.
	*/
	version 12
	syntax varlist(min=1 max=1 numeric) [if] [in]  , THReshold(real) [K(real 0)] 
	
	/*
	 syntax: rddisttestk runningvar, THReshold(real) 
	example: rddisttestk r, threshold(0) k(.05)
	Comments:
	*/
	marksample touse
	preserve
	qui keep if `touse'
	tempname p F n nc ncm ncp freqs c
	tempvar freq rank 

	tokenize `varlist'

	local r `1'
	
	gen byte `freq'=1
	collapse (count) `freq',by(`r')
	egen `rank'=rank(`r')
	qui sum `rank' if float(`r')>=float(`threshold')
	scalar `c'=r(min)
	* i need to do the following in mata so as not to run into matsize problems.
	mata _computep("`p'","`c'","`freq'",`k')
 
	return scalar p=`p'
	return scalar k=`k'
	local pvalstr="p-value = " + string(`p',"%5.3f") 
	display "RD Density Test Results, k = `k'" _n
	display "`pvalstr'"
	
	restore
end

*Define MATA programs:
mata:
void _computep(string scalar pscalar, string scalar cscalar, string scalar freqvar, real scalar k)
{
	c=st_numscalar(cscalar)
	freqs=st_data(.,freqvar)
	nc=freqs[c,1]
	ncm=freqs[c-1,1]
	ncp=freqs[c+1,1]
	n= nc+ncm+ncp
	
	if (k==0) {
		areaatandbelow=binomial(n,nc,1/3)
		areaatandabove=1-binomial(n,nc,1/3)
		p=2*min((areaatandbelow,areaatandabove))
		st_numscalar(pscalar,p)
	}
	else {
		// compute cdf at low and high
		plow=(1-k)/(3-k)
		phigh=(1+k)/(3+k)
		flow=binomialp(n,nc,plow)
		fhigh=binomialp(n,nc,phigh)
		areaplow=J(1,2,0)
		areaphigh=J(1,2,0)
		if (floatround(flow)>=floatround(fhigh)){
			areaplow[1]=binomial(n,nc,plow)
			areaphigh[1]=binomial(n,nc,phigh)
			//printf("is areaphigh less than areaplow?\n")
			//printf("areaphigh = %f, areaplow = %f\n",sum(areaphigh),sum(areaplow))
			ncp=n+1
			areaphigh[2]=0
			areaplow[2]=0
			while (floatround(areaphigh[2])<floatround(areaplow[1])) {
				diffprev=abs(floatround(areaphigh[2])-floatround(areaplow[1]))
				ncp--
				areaphigh[2]=1-binomial(n,ncp-1,phigh)
				areaplow[2]=1-binomial(n,ncp-1,plow)
				diffnew=abs(floatround(areaphigh[2])-floatround(areaplow[1]))
				//printf("ncp = %f, areaphigh = %f, areaplow = %f\n",ncp,sum(areaphigh),sum(areaplow))
			}
			if (diffprev<diffnew) {
				// if previous difference was smaller then back off one
				ncp++
				areaphigh[2]=1-binomial(n,ncp-1,phigh)
				areaplow[2]=1-binomial(n,ncp-1,plow)
			}
			p=min((1,max((sum(areaplow),sum(areaphigh)))))
		}
		else {
			areaplow[2]=1-binomial(n,nc-1,plow)
			areaphigh[2]=1-binomial(n,nc-1,phigh)
			//printf("is areaphigh greater than areaplow?\n")
			//printf("areaphigh = %f, areaplow = %f\n",sum(areaphigh),sum(areaplow))
			ncp=-1
			areaphigh[1]=0
			areaplow[1]=0
			while (floatround(areaplow[1])<floatround(areaphigh[2])) {
				diffprev=abs(floatround(areaplow[1])-floatround(areaphigh[2])) 
				ncp++
				areaphigh[1]=binomial(n,ncp,phigh)
				areaplow[1]=binomial(n,ncp,plow)
				diffnew=abs(floatround(areaplow[1])-floatround(areaphigh[2])) 
				//printf("ncp = %f, areaphigh = %f, areaplow = %f\n",ncp,sum(areaphigh),sum(areaplow))
			}
			if (diffprev<diffnew) {
				// if previous difference was smaller then back off one
				ncp--
				areaphigh[1]=binomial(n,ncp,phigh)
				areaplow[1]=binomial(n,ncp,plow)
			}
			p=min((1,max((sum(areaplow),sum(areaphigh)))))
		}

		st_numscalar(pscalar,p)
	}
}
end
