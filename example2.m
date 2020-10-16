% Animation of the position problem for different input lever angles:
addpath('libmechplot');
close all;

q       = [0.8 0.6 2  0.8]; % (x1 y1 x2 y2): vector of Cartesian coordinates
q_fixed = [0   0   1 -0.2]; % (xa ya xb yb): coordinates of fixed points
s=mp_plot_4bars(q, q_fixed, ...
  {'FaceColor',[0.8 0.8 0.8]},...    % Params for bar1 
  {'R',[0.25 0.15],'z_order',-2},... % Params for bar2
  { },...                            % Params for bar3 
  {'orientation',pi/4},...           % Params for ground #1
  {} ...                             % Params for ground #2
  );

% Second configuration:
fprintf('Pausing 1 second and updating plot...\n');
pause(1.0);

q2       = [0.9 0.5 2  0.8]; % (x1 y1 x2 y2): vector of Cartesian coordinates
s.plot(q2);
