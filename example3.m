% Five bar linkages: 
addpath('libmechplot');

q       = [1 1 2 -0.8 3 1.4]; % (x1 y1 x2 y2 x3 y3): vector of Cartesian coordinates
q_fixed = [0 0 4  0 ]; % (xa ya xb yb): coordinates of fixed points
mp_plot_5bars(q, q_fixed, ...
  {'render_style',mpLinkRenderStyle.Disc,'FaceColor',[0.95 0.95 0.95]},... % Params for bar1
  {},...                   % Params for bar2 
  {},...                   % Params for bar3 
  {},...                   % Params for bar4 
  {},...                   % Params for ground #1
  {'orientation',pi} ...   % Params for ground #2
  );