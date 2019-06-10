function Wing_fn = WngFns(t, param )

Omega=param.Omega;
FlpAmp=param.FlpAmp;
ProAmp=param.ProAmp;
SwpAmp=param.SwpAmp;
WngSpn=param.WngSpn;
Flp_shft=param.Flp_shft;
Pro_shft=param.Pro_shft;
Swp_shft=param.Swp_shft;
Flp_phs=param.Flp_phs;
Pro_phs=param.Pro_phs;
Swp_phs=param.Swp_phs;
pro=Pro_shft + ProAmp*sin(Pro_phs + Omega*t);
flp=- Flp_shft - FlpAmp*cos(Omega*t);
swp=Swp_shft - (SwpAmp*(cos(Omega*t) - 1))/2;
len=WngSpn*ones(size(flp));
dpro=Omega*ProAmp*cos(Pro_phs + Omega*t);
dflp=FlpAmp*Omega*sin(Omega*t);
dswp=(Omega*SwpAmp*sin(Omega*t))/2;
dlen=0*ones(size(flp));
ddpro=-Omega^2*ProAmp*sin(Pro_phs + Omega*t);
ddflp=FlpAmp*Omega^2*cos(Omega*t);
ddswp=(Omega^2*SwpAmp*cos(Omega*t))/2;
ddlen=0*ones(size(flp));
Wing_fn=[pro;flp;swp;len;dpro;dflp;dswp;dlen;ddpro;ddflp;ddswp;ddlen];
end


