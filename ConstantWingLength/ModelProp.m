function param = ModelProp(ModelPropList, Data)

    Cstar = ModelPropList(1);
    g = ModelPropList(2);
    Mb = ModelPropList(3);
    Mw = ModelPropList(4);
    Ibx = ModelPropList(5);
    b = ModelPropList(6);
    k_i = ModelPropList(7);
    

    T_init = Data(1,1);
    T_final = Data(end,1);
    
    param.T_final = T_final;
    param.T_init = T_init;

    param.g=g;
    param.a = 0;
%     param.b = 0.0117;
%     param.b = 0.012; % Hummingbird : Selasphorus rufus (Tobalske JEB 2007)
%     param.b = 0.05;
%     param.b = 0.0415;
%     param.b = 0.0108; % hummingbird : Chaetocercus mulsant
%     param.b = 0.0129; % hummingbird : Calypte anna
%       param.b = 0.0152; % hummingbird : Amazilia_tzacatl
%       param.b = 0.0146; % hummingbird : Amazilia_saucerottei
%       param.b = 0.022; % hummingbird : Colibri_coruscans
%     param.b = 0.017; % Hummingbird : Florisuga mellivora
%     param.b = 0.0164; % Hummingbird : Lafresnaya lafresnayi
%     param.b = 0.0172; % Hummingbird : Metallura tyrianthina
%     param.b = 0.0745 / 3; % to provide AR = 5 for Mellivora
%     param.b = 0.0525 / 5.0; % to provide AR = 5 for Anna
    param.b = b;
    param.Mb=Mb;
    param.Iby=2e-6;  % kg.m^2
    Iby = (1/5)*Mb*(0.02^2+0.02^2);
    param.Iby = Iby;
    
    param.Ibx=Ibx;
    param.Ibz=6e-6;
%     param.mw = Istar * 3*Iby/(sbar^2);
%     param.mw = 3.5e-3;
    param.mw = Mw;
    % param.RofCd = Cstar * (8*param.Iby/param.b/(sbar^4));
    
    param.Rof = Cstar * (1.2);
    param.k_i = k_i;
    
%     param.Rof = Cstar * (8*Iby/0.05/(sbar^4))/1.135;

%     
    
    t = Data(:,1);
    param.t = t;
      
    
%     [wing] = WingMotion(Data,t);

    param.ddqx = Data(:,2);
    param.ddqy = Data(:,3);
    param.ddqz = Data(:,4);
    param.ddwl = Data(:,5);
    

end