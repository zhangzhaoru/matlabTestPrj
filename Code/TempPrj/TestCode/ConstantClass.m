classdef ConstantClass
    %CONSTANTCLASS 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties(Constant = true)
        % 平台姿态角
        PLAT_ELE = 20;
        PLAT_AZI = 0;
        PLAT_ROLL_W = 300;
        PLAT_ROLL_theta0 = 0;
        
        % 帧扫描周期
        FRM_PERIOD = 0.1;
        
        % 波束指向角
        WAVEPOINT_ELE = 20;
        WAVEPOINT_AZI = 20;
                
    end
    
    
end

