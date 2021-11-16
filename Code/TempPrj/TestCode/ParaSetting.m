function Para = ParaSetting()
    k = 2;
    Para.PlatEle = ConstantClass.PLAT_ELE;
    Para.PlatAzi = ConstantClass.PLAT_AZI;
    Para.PlatRoll = ConstantClass.PLAT_ROLL_theta0+(k-1)*ConstantClass.PLAT_ROLL_W...
        *ConstantClass.FRM_PERIOD;
    Para.WavepointEle = ConstantClass.WAVEPOINT_ELE;
    Para.WavepointAzi = ConstantClass.WAVEPOINT_AZI;
    
end

