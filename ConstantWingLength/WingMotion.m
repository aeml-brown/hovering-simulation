function [wing] = WingMotion(Data,t)

    
    wing.t = t;

    wing.ddwl = 0 * t;
    wing.ddqy = 0 * t;
    wing.ddqx = 0 * t;
    wing.ddqz = 0 * t;

    tt = Data(:,1);
    ddqx = Data(:,2);
    ddqy = Data(:,3);
    ddqz = Data(:,4);
    ddwl = Data(:,5);
    
    wing.ddqx = interp1(tt,ddqx,t);
    wing.ddqy = interp1(tt,ddqy,t);
    wing.ddqz = interp1(tt,ddqz,t);
    wing.ddwl = interp1(tt,ddwl,t);
    
end