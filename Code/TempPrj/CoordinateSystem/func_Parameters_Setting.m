%% 参数设定
function Para = func_Parameters_Setting(sigmaDy,sigmaDz)
Para.Qg_0 = 20;
Para.fay = 3.25;
Para.fay_ground = 200;
Para.Angle_3sigma = 19;
Para.Range = 2612;
Para.Vt = 0;
Para.Range_3sigma = 700;

Para.ratio = 0.443;
Para.Rng_min = 0.79;
Para.amp_min = sqrt(Para.Rng_min);
Para.Number_scan = size(sigmaDy,1);
Para.Azi = sigmaDy;
Para.Ele = sigmaDz;
Para.Qg = Para.Qg_0-Para.Ele;
Para.H = (Para.Range*sind(Para.Qg_0)).*ones(1,Para.Number_scan);
  .Error_3sigma = Para.Angle_3sigma;

Para.Center_x = Para.H(1)/tand(Para.Qg(1));
Para.Cenrer_y = 0;
Para.Ori = [Para.Center_x;Para.Center_y];

Para.WaveGate_AZI_Number = (2*Para.Angle_3sigma/0.05)+1;
Para.WaveGate_ELE_Number = (2*Para.Angle_3sigma/0.05)+1;

Para.Range_scan = floor(Para.H(1)/tand(Para.Qg(1)))-floor(Para.H(1)/tand(Para.Qg(1)+Para.Angle_3sigma));
Para.WaveGate_RNG_Number = 2*Para.Range_scan/1+1;

Para.AZI_scan = floor(atand(Para.Range_3sigma/Para.Range));
Para.WaveGate_AZI_Number_limit = 2*Para.AZI_scan/0.05+1;
Para.WaveGate_RNG_Number_limit = 2*Para.Range_3sigma/1+1;
end

