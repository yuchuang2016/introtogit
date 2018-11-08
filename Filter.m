bhi = firls(18,[0 0.45 0.55 1],[1 1 0 0],[1 100]);
blo = firls(18,[0 0.45 0.55 1],[1 1 0 0],[100 1]);
b = firls(18,[0 0.45 0.55 1],[1 1 0 0],[1 1]);
hfvt = fvtool(bhi,1,blo,1,b,1,'MagnitudeDisplay','Zero-phase');
legend(hfvt,'bhi: w = [1 100]','blo: w = [100 1]','b: w = [1 1]')
