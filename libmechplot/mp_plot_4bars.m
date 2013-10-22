function [  ] = mp_plot_4bars( q, q_fixed, varargin )
%MP_PLOT_4BARS Wrapper for Mechplot that renders a planar 4 bars linkage
% * "q" is expected to hold the Cartessian coordinates: [x1 y1 x2 y2]
% * "q_fixed" holds the Cartessian coordinates of the fixed or "ground" points 
%   A and B: [x_a y_a x_b y_b]
% * Other optional arguments to customize the representation: ...
% 
% 
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    s=mpMechanism();  % Create new, empty mechanism object
    
    % LINK #2
    b = mpLink('id',2);
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',1, 'fixed_y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    s.add(b);

    % LINK #3
    b = mpLink('id',3);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    s.add(b);

    % LINK #4
    b = mpLink('id',4);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',3, 'fixed_y_idx',4);
    s.add(b);
    
    % Set fixed points:
    s.q_fixed = q_fixed;
    
    s.plot(q);
    
end

