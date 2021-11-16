% 各帧视线角理论值添加惯导误差
function Para = func_Paraters_Setting_err(Para)
frm_num = length(Para.Azi);

Para.yaw_err = 3;
Para.pitch_err = 3;
Para.roll_err = 5;
Para.yaw = 0;
Para.pitch = -Para.Qg_0;
Para.roll_w = 2160;
Para.roll0 = 0;
Para.roll = zeros(frm_num,1);
Para.frm_period = 0.01;

Para.Azi_err = zeros(frm_num,1);
Para.Qg_err = zeros(frm_num,1);

point_angle = [];


for frm_idx = 1:frm_num
    roll = Para.roll+(frm_idx-1)*Para.frm_period*Para.roll_w;
    Para.roll(frm_idx) = roll;
    range = Para.H(1)*sqrt(1+1/cosd(Para.Azi(frm_idx))^2/tand(Para.Qg(frm_idx))^2);
    [ele_point_angle,azi_point_angle] = fcn_sight_coor_2_antenna_coor(range,-Para.Qg(frm_idx),Para.Azi(frm_idx),roll+Para.roll_err,Para.pitch+Para.pitch_err,Para.yaw+Para.yaw_err);
    [ele_sight_angle,azi_sight_angle] = fcn_antenna_coor_2_sight_coor(range,ele_point_angle,azi_point_angle,Para.yaw,Para.pitch,roll);
    Para.range_theory(frm_idx) = range;
    point_angle = [point_angle;ele_point_angle,azi_point_angle];
    Para.Azi_err(frm_idx) = azi_sight_angle;
    Para.Qg(frm_idx) = -ele_sight_angle;
    Para.Ele_err(frm_idx) = Para.Qg_0-Para,Qg_err(frm_idx);
    
    
end


Para.point_angle = point_angle;
Para.Center_x_err = Para.H(1)/tand(Para.Qg_err(1));
Para.Center_y_err = 0;
Para.Ori_err = [Para.Center_x_err;Para,Center_y_err];



end

