%%
% Results measurements of wind tunnels
%% closed circuit with axial fan
% 
% disp('Measurements')
% length1  = [0,  11.5, 14.3, 17.1, 17.7, 17.8, 20, 20.5, 20.7, 22.2, 34.2, 34.7, 38.7, 42.7, 42.8, 43.2, 44.2];
% p1       = [184, 100,   94,   88,   59,   54, 50,   39,   16,   15,    0,  -5.6  -29, -50,   -78,  -79,  184];
% 
% % plot the bunch
% %plot (flowrate, p_closed, 'b-', 'LineWidth',2); hold on;
% plot (length1, p1  , 'r-', 'LineWidth',2); hold on;
% 
% %legend ('Closed circuit', 'Open circuit');
% title ('pressure loss closed circuit wind tunnel with axial fan');
% xlabel ('Length (m)');
% ylabel ('p (Pa)');

%% closed circuit with centrifugal fan 1 - reuse all David parts
% length2  = [  0, 14.5, 15.7, 17.1, 20.1, 20.4, 20.6, 20.8, 22.3, 29.3, 30.3,   31, 31.2,  32];
% p2       = [223,   95,   72,   56,   46,   39,   30,   10,    9,    0,   -5, -136, -143, 223];
% 
% % plot the bunch
% %plot (flowrate, p_closed, 'b-', 'LineWidth',2); hold on;
% plot (length2, p2  , 'r-', 'LineWidth',2); hold on;
% 
% %legend ('Closed circuit', 'Open circuit');
% title ('pressure loss closed circuit wind tunnel with axial fan');
% xlabel ('Length (m)');
% ylabel ('p (Pa)');

%% closed circuit wind tunnel centrifugal 2 - with new corners

length3  = [  0, 14.5, 18.1, 21.7, 23.2, 23.5, 23.7, 23.9, 24.9, 32.9, 33.9, 35.6, 35.8, 36.6];
p3       = [260,   84,   80,   76,   75,   66,   53,   24,   22,    0,   -1,  -22,  -35, 260];

% plot the bunch
%plot (flowrate, p_closed, 'b-', 'LineWidth',2); hold on;
plot (length3, p3  , 'r-', 'LineWidth',2); hold on;

%legend ('Closed circuit', 'Open circuit');
title ('pressure loss closed circuit wind tunnel with axial fan 2');
xlabel ('Length (m)');
ylabel ('p (Pa)');