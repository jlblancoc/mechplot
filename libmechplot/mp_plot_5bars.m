function [ varargout ]  = mp_plot_5bars( q, q_fixed, varargin )
%MP_PLOT_5BARS Wrapper for Mechplot that renders a planar 5 bars linkage
% * "q" is expected to hold the Cartessian coordinates: [x1 y1 x2 y2 x3 y3]
% * "q_fixed" holds the Cartessian coordinates of the fixed or "ground" points 
%   A and B: [x_a y_a x_b y_b]
% * Optionally, you can add 6 cells, each with extra properties for 
% bars 1,2,3,4 and ground points 1 and 2. 
%
% As an optional output of the function, you can get the assembled
% mpMechanism object, which can be used to refresh the plot with new "q"
% values.
%
% Example:
%  mp_plot_5bars([1 1 2 -0.8 3 1.4],[0 0 4 0],...
%   {'render_style',mpLinkRenderStyle.Disc,'FaceColor',[0.95 0.95 0.95]},...
%   {},{},{},{},{'orientation',pi});
% 
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    assert( length(varargin)==0 | length(varargin)==6,'Provide either none or 6 cells as extra arguments');

    s=mpMechanism();  % Create new, empty mechanism object
    
    extra_params=cell(6,1);
    for i=1:6
        if (~isempty(varargin) && ~isempty(varargin{i}))
            extra_params{i}=varargin{i};
        else
            extra_params{i}={};
        end
    end
    
    % LINK #2
    b = mpLink('id',2, extra_params{1}{:});
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',1, 'fixed_y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    s.add(b);

    % LINK #3
    b = mpLink('id',3, extra_params{2}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',1, 'y_idx',2);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    s.add(b);

    % LINK #4
    b = mpLink('id',4, extra_params{3}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',3, 'y_idx',4);
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',5, 'y_idx',6);
    s.add(b);

    % LINK #5
    b = mpLink('id',5, extra_params{4}{:});
    b.points(end+1) = mpPoint('is_fixed',0, 'x_idx',5, 'y_idx',6);
    b.points(end+1) = mpPoint('is_fixed',1, 'fixed_x_idx',3, 'fixed_y_idx',4);
    s.add(b);
    
    % Ground points #1 and #2:
    s.add( mpPinnedGround(1,2,extra_params{5}{:}) );
    s.add( mpPinnedGround(3,4,extra_params{6}{:}) );
    
    % Set fixed points:
    s.q_fixed = q_fixed;
    
    s.plot(q);    

    if (nargout>=1)
        varargout{1} = s;
    end    
end

