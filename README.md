mechplot
========

Library to render structures and mechanisms (in MATLAB)

In a **very** early stage of development!


Examples: 
----------

* Four bar linkages: 

        q       = [1 1 2 1.4]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0 0 4  0 ]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed);

![mp_plot_4bars_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/mp_plot_4bars_demo1.png)

        q       = [0.8 0.6 2  0.8]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0   0   1 -0.2]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed, ...
          {'FaceColor',[0.8 0.8 0.8]},...    % Params for bar1 
          {'R',[0.25 0.15],'z_order',-2},... % Params for bar2
          { },...                            % Params for bar3 
          {'orientation',pi/4},...           % Params for ground #1
          {} ...                             % Params for ground #2
          );

![mp_plot_4bars_demo2](https://raw.github.com/jlblancoc/mechplot/master/doc/mp_plot_4bars_demo2.png)

        q       = [1.2 0.5 2 3]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0   0   4 0]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed, ...
          {'render_style',mpLinkRenderStyle.Disc,'FaceColor',[0.8 0.8 0.8]},...    % Params for bar1 
          {},...                        % Params for bar2
          {},...                        % Params for bar3 
          {'drawGroundHatch',0},...     % Params for ground #1
          {} ...                        % Params for ground #2
          );

![mp_plot_4bars_demo3](https://raw.github.com/jlblancoc/mechplot/master/doc/mp_plot_4bars_demo3.png)




