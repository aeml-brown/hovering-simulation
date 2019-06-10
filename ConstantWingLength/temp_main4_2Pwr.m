clear all
load power_IndVel1_IStr10_AR4_mw0_v4_Pwr2Scenarios_v2

OutputData_ModifiedRound5 = [];
% OutputData_ModifiedRound5 = OutputData_ModifiedRound4;
for iii = 1:length(OutputData_ModifiedRound4)
    State_space = OutputData_ModifiedRound4(iii,1:6);
    Control_param = OutputData_ModifiedRound4(iii,7:9);
    [f_star, MechWrk_zeroNeg_Normlz, MechWrk_AlgebraicSum_Normlz, MechWrk_AlgebraicSum4EachDoF_Normlz, err] = ...
    PowerCalculation_v4_function(State_space, Control_param);
    OutputData_ModifiedRound5(iii,:) = [State_space Control_param err f_star MechWrk_zeroNeg_Normlz MechWrk_AlgebraicSum_Normlz MechWrk_AlgebraicSum4EachDoF_Normlz];
end

save power_IndVel1_IStr10_AR4_mw0_v4_Pwr2Scenarios_v3
