function [  ] = mp_plot_slider_crank( q, q_fixed, varargin )
%MP_PLOT_SLIDER_CRANK Wrapper for Mechplot that renders a slider crank
% * "q" is expected to hold the Cartessian coordinates: [x1 y1 x2 y2]
% * "q_fixed" holds the Cartessian coordinates of the fixed or "ground" point 
%   at the lever (A) and the two fixed points that define the slider guide
%   (B and C): [x_a y_a x_b y_b x_c y_c]
% * Optionally, you can add 7 cells, each with extra properties for 
% bars 1 and 2, the slider block, the fixed guide bar, and ground points A, B and C. 
%
% Example:
%   q       = [1.5 2  5 1]; % (x1 y1 x2 y2): vector of Cartesian coordinates
%   q_fixed = [0 0  3 -1  8 4]; % (xa ya xb yb xc yc): coordinates of fixed points
%   mp_plot_slider_crank(q, q_fixed);
% 
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    assert( length(varargin)==0 | length(varargin)==7,'Provide either none or 7 cells as extra arguments');

    s=mpMechanism();  % Create new, empty mechanism object
    
    extra_params=cell(7,1);
    for i=1:7
        if (~isempty(varargin) && ~isempty(varargin{i}))
            extra_params{i}=varargin{i};
        else
            extra_params{i}={};
        end
    end

    % Dummy fixed bar, guide of the slider block. 
    b = mpLink('r',[0 0],extra_params{4}{:});
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',3, 'fixed_y_idx',4);
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',5, 'fixed_y_idx',6);
    s.add(b);

    % Slider block over fixed guide
    b = mpSliderBlock('id',4,extra_params{3}{:}); 
    b.joint_point = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    b.guide_points(1) = mpPoint('is_fixed',1, 'fixed_x_idx',3, 'fixed_y_idx',4);
    b.guide_points(2) = mpPoint('is_fixed',1, 'fixed_x_idx',5, 'fixed_y_idx',6);
    s.add(b);


    % Link #1 is the "ground/fixed element"

    % LINK #2
    b = mpLink('id',2,extra_params{1}{:});
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',1, 'fixed_y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    s.add(b);

    % LINK #3
    b = mpLink('id',3,extra_params{2}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    s.add(b);


    % Ground point #1
    s.add( mpPinnedGround(1,2,extra_params{5}{:}) );

    % Ground points of the fixed guide bar:
    guide_ang = atan2(q_fixed(6)-q_fixed(4),q_fixed(5)-q_fixed(3));
    s.add( mpFixedGround(3,4,'orientation',0+guide_ang, extra_params{6}{:} ));
    s.add( mpFixedGround(5,6,'orientation',pi+guide_ang, extra_params{7}{:} ));

    % Set fixed points:
    s.q_fixed = q_fixed;
    s.plot(q);
end
