classdef mpLink < mpRenderizable
    %MPLINK A link or element of a mechanical structure
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpLink(), mpLink('id',123), etc.
        % Add points with link.points(end+1)=mpPoint(...);
        function s = mpLink(varargin)
            s.id=0;
            s=mpi_add_props(s,varargin{:});
        end
    end

    
    %% Properties
    properties(GetAccess=public, SetAccess=public)
        id; % Identifier (Optional, only for the user to name each link)
        points = mpPoint.empty; % The list of 2+ points that define the link.
        render_style = mpLinkRenderStyle.PlanarBar;
        
        % Render params for "SimpleLine"
        SimpleLineColor = [0 0 0];
        
        % Render params for "PlanarBar" (all have defaults values)
        r;
        R; 
        FaceColor = [0.9 0.9 0.9]; 
        LineWidth = 1; 
    end
    
    % "Static" data: precomputed stuff
    properties(Constant, GetAccess=private)
        SINCOS_N_POINTS = 20;
        SINs = sin(linspace(0,pi,mpLink.SINCOS_N_POINTS))';
        COSs = cos(linspace(0,pi,mpLink.SINCOS_N_POINTS))';
    end
    
    %% Public methods:
    methods(Access=public)
        
        % Render link:
        function draw(me, q,parent)
            nPts = length(me.points);
            assert(nPts==2); % For now...
            % Get the coords of all points:
            % -----------------------------
            pts=zeros(nPts,2);
            for i=1:nPts,
               if (me.points(i).is_fixed)
                   pts(i,1) = parent.q_fixed( me.points(i).fixed_x_idx );
                   pts(i,2) = parent.q_fixed( me.points(i).fixed_y_idx );
               else
                   pts(i,1) = q( me.points(i).x_idx );
                   pts(i,2) = q( me.points(i).y_idx );
               end
            end
            
            % Draw them: (TODO) simplex, lines, custom shapes, etc.
            % 
            switch (me.render_style) 
                case mpLinkRenderStyle.SimpleLine
                    plot([pts(1,1) pts(2,1)], [pts(1,2) pts(2,2)],'Color',me.SimpleLineColor,'LineWidth',me.LineWidth);
                    
                case mpLinkRenderStyle.PlanarBar
                    % Render parameters:
                    r_ = mpi_get_param(me.r, parent.problemMaxDim*0.01* ones(2,1));
                    R_ = mpi_get_param(me.R, parent.problemMaxDim*0.03* ones(2,1));

                    % Draw nice, rounded filled bar:
                    ang = atan2(pts(2,2)-pts(1,2),pts(2,1)-pts(1,1));
                    xs=[]; ys=[]; % Build shape array incrementally
                    [xs, ys]=mpi_transform_shape(xs,ys, mpLink.COSs*R_(1),mpLink.SINs*R_(1), pts(1,1),pts(1,2),ang+pi/2);
                    [xs, ys]=mpi_transform_shape(xs,ys, mpLink.COSs*R_(2),mpLink.SINs*R_(2), pts(2,1),pts(2,2),ang-pi/2);
                    fill(xs,ys,me.FaceColor,'LineWidth',me.LineWidth);
                    
                    % Draw "pin" points
                    for k=1:2,
                        rectangle('Position',[pts(k,1)-r_(k) pts(k,2)-r_(k) 2*r_(k) 2*r_(k)],...
                            'Curvature',[1 1],  'FaceColor',[1 1 1],...
                            'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
                    end
                    
                otherwise
                    error('Unknown render style for link: "%s"',char(me.render_style));
            end
            
        end
    end
    
end

