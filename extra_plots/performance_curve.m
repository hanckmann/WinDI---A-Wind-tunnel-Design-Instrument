%% performance curves open and closed wind tunnel Ats = 3 m^2, Vts = 20m/s
% % Results measurements of wind tunnels
% disp('Measurements')
% flowrate  = [ 72,  66,  60,  54,  48,  42,  36,  30,  24, 18, 12, 6, 0];
% p_closed  = [376, 317, 263, 213, 169, 130,  96,  68,  44, 25, 11, 3, 0];
% p_open    = [453, 381, 315, 256, 203, 156, 115,  80,  52, 29, 13, 3.3, 0];
% 
% % plot the bunch
% plot (flowrate, p_closed, 'b-', 'LineWidth',2); hold on;
% plot (flowrate, p_open  , 'r-', 'LineWidth',2); hold on;
% 
% %legend ('Closed circuit', 'Open circuit');
% title ('Performance curve open & closed circuit wind tunnel');
% xlabel ('flowrate (m^3/s)');
% ylabel ('p (Pa)');
% 


%% performance curve of closed wind tunnel with centrifugal fan.
% reuse of 3 david corners (CF1) reuse of 1 david corner (CF2).
% 
% flowrate  = [     30,     27,   21.9,     18,     15,     12,     9,     6,     3,  1.5];
% cf1       = [ 990.14, 807.03, 537.83, 367.96, 258.68, 168.17, 96.63, 44.33, 11.76, 3.14];
% cf2       = [  560.2,  455.5,  302.1,  205.7, 144.02,  93.33, 53.14, 24.12,  6.27, 1.63];
% 
% flowrate_cf1 = 18;
% Pa_cf1       = 367.96;
% flowrate_cf2 = 21.9;
% Pa_cf2       = 302.1;
% 
% flowrate_fan = 5.7;
% Pa_fan       = 1168.29;
% 
% % pos_flowrate_fan = [    3,  5.688,  10,  13,  15,  18,  20,  22.5];
% % pos_Pa_fan       = [ 1250, 1168.3, 975, 805, 675, 495, 365, 170];
% flowrate_fan1 = [3.61, 4.17,    5, 5.56, 5.7, 8.333, 10, 11.1];
% Pa_fan1 =        [2200, 1800, 1350, 1200, 1160, 750, 550, 450];
% 
% pos_flowrate_fan = [11.1, 13, 15,  20];
% pos_Pa_fan       = [ 450,330, 250, 80];
% 
% % plot the bunch
% plot (flowrate_cf1, Pa_cf1, 'b*', 'LineWidth',4); hold on;
% plot (flowrate_cf2, Pa_cf2, 'c*', 'LineWidth',4); hold on;
% plot (flowrate_fan, Pa_fan, 'r*', 'LineWidth',4); hold on;
% plot (flowrate, cf1, 'b-', 'LineWidth',2); hold on;
% plot (flowrate, cf2, 'c-', 'LineWidth',2); hold on;
% plot (flowrate_fan1, Pa_fan1, 'r-', 'LineWidth',1.5); hold on;
% plot (pos_flowrate_fan, pos_Pa_fan, 'r--', 'LineWidth',1.5); hold on;
% 
% %legend ('Closed circuit', 'Open circuit');
% %title ('Performance curves closed circuit wind tunnel with centrifugal fan');
% legend ('Proposed operation WT 1', 'Proposed operation WT 1', 'Operation ABL Leuven', 'Performance WT 1', 'Performance WT 2', 'Centrifugal fan curve');
% xlabel ('flowrate (m^3/s)');
% ylabel ('p (Pa)');

%%
%% performance curve of closed wind tunnel with centrifugal fan.
% reuse of 3 david corners (CF1) reuse of 1 david corner (CF2).

flowrate  = [     30,     27,   21.9,     18,     15,     12,     9,     6,     3,  1.5];
cf1       = [ 990.14, 807.03, 537.83, 367.96, 258.68, 168.17, 96.63, 44.33, 11.76, 3.14];
cf2       = [  560.2,  455.5,  302.1,  205.7, 144.02,  93.33, 53.14, 24.12,  6.27, 1.63];


% pos_flowrate_fan = [    3,  5.688,  10,  13,  15,  18,  20,  22.5];
% pos_Pa_fan       = [ 1250, 1168.3, 975, 805, 675, 495, 365, 170];
flowrate_fan1 = [3.61, 4.17,    5, 5.56, 5.7, 8.333, 10, 11.1];
Pa_fan1 =        [2200, 1800, 1350, 1200, 1160, 750, 550, 450];

pos_flowrate_fan = [11.1, 13, 15,  20];
pos_Pa_fan       = [ 450,330, 250, 80];

% plot the bunch
plot (flowrate, cf1, 'b-', 'LineWidth',2); hold on;
plot (flowrate, cf2, 'c-', 'LineWidth',2); hold on;
plot (flowrate_fan1, Pa_fan1, 'r-', 'LineWidth',1.5); hold on;
plot (pos_flowrate_fan, pos_Pa_fan, 'r--', 'LineWidth',1.5); hold on;

%legend ('Closed circuit', 'Open circuit');
%title ('Performance curves closed circuit wind tunnel with centrifugal fan');
legend ('Performance WT 1 with centrifugal fan', 'Performance WT 2 with centrifugal fan', 'Centrifugal fan curve');
xlabel ('flowrate (m^3/s)');
ylabel ('p (Pa)');