function [  ] = mp_plot_4bars( q, q_fixed, varargin )
%MP_PLOT_4BARS Wrapper for Mechplot that renders a planar 4 bars linkage
% * "q" is expected to hold the Cartessian coordinates: [x1 y1 x2 y2]
% * "q_fixed" holds the Cartessian coordinates of the fixed or "ground" points 
%   A and B: [x_a y_a x_b y_b]
% * Optionally, you can add 3 cells, each with extra properties for each
% bar. 
%
% Examples:
%  mp_plot_4bars([1 1 2 1.4],[0 0 4 0]);
%  mp_plot_4bars([0.8 0.6 2 0.8],[0 0 1 -0.2], ...
%    {'FaceColor',[0.8 0.8 0.8]},...
%    {'R',[0.25 0.15],'z_order',-2},...
%    {'LineWidth',2} );
% 
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    assert( length(varargin)==0 | length(varargin)==3,'Provide either none or 3 cells as extra arguments');

    s=mpMechanism();  % Create new, empty mechanism object
    
    params_bar=cell(3,1);
    for i=1:3
        if (~isempty(varargin) & ~isempty(varargin{i}))
            params_bar{i}=varargin{i};
        else
            params_bar{i}={};
        end
    end
    
    % LINK #2
    b = mpLink('id',2, params_bar{1}{:});
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',1, 'fixed_y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    s.add(b);

    % LINK #3
    b = mpLink('id',3, params_bar{2}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    s.add(b);

    % LINK #4
    b = mpLink('id',4, params_bar{3}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',3, 'fixed_y_idx',4);
    s.add(b);


    
    % Set fixed points:
    s.q_fixed = q_fixed;
    
    s.plot(q);
    
end

