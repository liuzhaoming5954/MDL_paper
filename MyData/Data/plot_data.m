%% plot joint position
 figure(1);
 plot(time,j1p,'DisplayName','j1');hold all;plot(time,j2p,'DisplayName','j2');plot(time,j3p,'DisplayName','j3');plot(time,j4p,'DisplayName','j4');plot(time,j5p,'DisplayName','j5');hold off;
 legend('J1','J2','J3','J4','J5');
 
 %% plot joint velocity
 figure(2);
 plot(time,j1v,'DisplayName','j1');hold all;plot(time,j2v,'DisplayName','j2');plot(time,j3v,'DisplayName','j3');plot(time,j4v,'DisplayName','j4');plot(time,j5v,'DisplayName','j5');hold off;
 legend('J1','J2','J3','J4','J5');
 
 %% data preparing
 figure(1);
 plot(PVT.time,PVT.j1p,'DisplayName','j1');hold all;plot(PVT.time,PVT.j2p,'DisplayName','j2');plot(PVT.time,PVT.j3p,'DisplayName','j3');plot(PVT.time,PVT.j4p,'DisplayName','j4');plot(PVT.time,PVT.j5p,'DisplayName','j5');hold off;
 legend('J1','J2','J3','J4','J5');
 
 %% move time to 0ms
time = PVT1.time(1);
 for i=1:1:length(PVT1.time)
     PVT1.time(i)= PVT1.time(i)-time;
 end 
 time = PVT2.time(1);
 for i=1:1:length(PVT2.time)
     PVT2.time(i)= PVT2.time(i)-time;
 end
 time = PVT3.time(1);
 for i=1:1:length(PVT3.time)
     PVT3.time(i)= PVT3.time(i)-time;
 end
 time = PVT4.time(1);
 for i=1:1:length(PVT4.time)
     PVT4.time(i)= PVT4.time(i)-time;
 end
 time = PVT5.time(1);
 for i=1:1:length(PVT5.time)
     PVT5.time(i)= PVT5.time(i)-time;
 end
 time = PVT6.time(1);
 for i=1:1:length(PVT6.time)
     PVT6.time(i)= PVT6.time(i)-time;
 end
 time = PVT7.time(1);
 for i=1:1:length(PVT7.time)
     PVT7.time(i)= PVT7.time(i)-time;
 end
 time = PVT8.time(1);
 for i=1:1:length(PVT8.time)
     PVT8.time(i)= PVT8.time(i)-time;
 end