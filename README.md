mechplot
========

Library to render structures and mechanisms (in MATLAB)

In a **very** early stage of development!


Examples: 
----------

* Four bar linkages: 

        q       = [1 1 2 1.4]; % (x1 y1 x2 y3):  vector of Cartesian coordinates
        q_fixed = [0 0 4  0 ]; % (xa ya xb yb): coordinates of fixed points
        mp_plot_4bars(q, q_fixed);

![mp_plot_4bars_demo1](https://raw.github.com/jlblancoc/mechplot/master/doc/mp_plot_4bars_demo1.png)

        mp_plot_4bars([0.8 0.6 2 0.8],[0 0 1 -0.2], ...
        {'FaceColor',[0.8 0.8 0.8]},{'R',[0.25 0.15],'z_order',-2},...
        { }, {'orientation',pi/4}, {} );

![mp_plot_4bars_demo2](https://raw.github.com/jlblancoc/mechplot/master/doc/mp_plot_4bars_demo2.png)





