% Four bar linkage: 
addpath('libmechplot');

q       = [1 1 2 1.4]; % (x1 y1 x2 y2): vector of Cartesian coordinates
q_fixed = [0 0 4  0 ]; % (xa ya xb yb): coordinates of fixed points
mp_plot_4bars(q, q_fixed);
