mechplot
========

MATLAB library (toolkit) to render structures and mechanisms.

Based on MATLAB classes, can render an arbitrary set of links, joints and other 
visual components. The appearance of each object can be highly customized. 

Animations of structures can be easily achieved by repeatedly rendering
it with a different vector of coordinates ("q").

Wrapper functions are provided for drawing some common problems (e.g. 4-bar linkages) 
without having to deal with MATLAB classes. 


Examples: 
----------

* Four bar linkages: 

        q       = [1 1 2 1.4]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0 0 4  0 ]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed);

![mp_plot_4bars_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_4bars_demo1.png)

  Animation of the position problem for different input lever angles:

![mp_plot_4bars_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/animations/position_problem_4bars.gif)

        q       = [0.8 0.6 2  0.8]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0   0   1 -0.2]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed, ...
          {'FaceColor',[0.8 0.8 0.8]},...    % Params for bar1 
          {'R',[0.25 0.15],'z_order',-2},... % Params for bar2
          { },...                            % Params for bar3 
          {'orientation',pi/4},...           % Params for ground #1
          {} ...                             % Params for ground #2
          );

![mp_plot_4bars_demo2](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_4bars_demo2.png)

        q       = [1.2 0.5 2 3]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0   0   4 0]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed, ...
          {'render_style',mpLinkRenderStyle.Disc,'FaceColor',[0.8 0.8 0.8]},...    % Params for bar1 
          {},...                        % Params for bar2
          {},...                        % Params for bar3 
          {'drawGroundHatch',0},...     % Params for ground #1
          {} ...                        % Params for ground #2
          );

![mp_plot_4bars_demo3](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_4bars_demo3.png)


* Five bar linkages: 

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

![mp_plot_5bars_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_5bars_demo1.png)


* Slider-crank mechanisms: 

        q       = [1.5 2  5 1]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0 0  3 -1  8 4]; % (xa ya xb yb xc yc): coordinates of fixed points
        mp_plot_slider_crank(q, q_fixed);

![mp_plot_slider_crank_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_slider_crank_demo1.png)


        q       = [0 -2  -5 -3]; % (x1 y1 x2 y2): vector of Cartesian coordinates
        q_fixed = [0 0  0 -3  -9 -3]; % (xa ya xb yb xc yc): coordinates of fixed points
        mp_plot_slider_crank(q, q_fixed,...
          {'render_style',mpLinkRenderStyle.Disc},...    % Params for bar1 
          {'R',[0.15 0.15]},...              % Params for bar2
          { },...                            % Params for slider block 
          { },...                            % Params for guide bar 
          {'drawGroundHatch',0},...          % Params for ground A
          {}, ...                            % Params for ground B
          {} ...                             % Params for ground C
          );            

![mp_plot_slider_crank_demo2](https://raw.github.com/jlblancoc/mechplot/master/doc/imgs/mp_plot_slider_crank_demo2.png)

