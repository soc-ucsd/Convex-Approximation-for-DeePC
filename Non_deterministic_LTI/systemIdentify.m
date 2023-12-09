
load('trajectory.mat')
sysdata = iddata(yd_noi',ud',1);
sysModel = n4sid(sysdata,8,'DisturbanceModel','none');
fprintf('SystemID successful')
save(['sysModel'], 'sysModel')
