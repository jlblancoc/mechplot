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
        r;  % radiuses of the holes (vector, length=2)
        R;  % radiuses of the rounded ends of the bar (vector, length=2)
        FaceColor = [0.9 0.9 0.9]; 
        LineWidth = 1; 
        
        % Render params for "Disc" (all have defaults values)
        % r;  % (Shared with other renderers) radiuses of the holes (vector, length=2)
        %FaceColor  % (Shared with other renderers)
        %LineWidth  % (Shared with other renderers)
        RadialHoleCount = 4 % Number of "large" holes in the middle of the disc. "0" to disable.
        RadialHolePosRatio    = 0.65;
        RadialHoleRadiusRatio = 0.25;
        DiscCenterPointIdx = 1; % The index in "points()" for the disc center (default=1, the first point)
        DiscRadiusPointIdx = 2; % The index in "points()" for determining the disc radius (default=2, the second point)
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
            % Get the coords of all points:
            % -----------------------------
            pts = getAllPointsCoords(me,q,parent);
            nPts = size(pts,1);
            
            % Draw them:
            switch (me.render_style) 
                % Render: SimpleLine 
                % ---------------------------------
                case mpLinkRenderStyle.SimpleLine
                    assert(nPts==2); % For now...
                    plot([pts(1,1) pts(2,1)], [pts(1,2) pts(2,2)],'Color',me.SimpleLineColor,'LineWidth',me.LineWidth);
                    
                % Render: PlanarBar 
                % ---------------------------------
                case mpLinkRenderStyle.PlanarBar
                    assert(nPts==2); % For now...
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
                        if (r_(k)>0)
                            rectangle('Position',[pts(k,1)-r_(k) pts(k,2)-r_(k) 2*r_(k) 2*r_(k)],...
                                'Curvature',[1 1],  'FaceColor',[1 1 1],...
                                'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
                        end
                    end

                % Render: Disc 
                % ---------------------------------
                case mpLinkRenderStyle.Disc
                    assert(nPts>=2);
                    r_ = mpi_get_param(me.r, parent.problemMaxDim*0.01* ones(2,1));
                    
                    idx1=me.DiscCenterPointIdx; % The index in "points()" for the disc center
                    idx2=me.DiscRadiusPointIdx; % The index in "points()" for determining the disc radius

                    ang = atan2(pts(idx2,2)-pts(idx1,2),pts(idx2,1)-pts(idx1,1));
                    DiscKinematicRadius = hypot(pts(idx2,2)-pts(idx1,2),pts(idx2,1)-pts(idx1,1));
                    DiscInnerRadius = DiscKinematicRadius - r_(2)*1.9;
                    DiscRadius = DiscKinematicRadius + r_(2)*1.9;
                    
                    % Draw disc circle: 
                    rectangle('Position',[pts(idx1,1)-DiscRadius pts(idx1,2)-DiscRadius 2*DiscRadius 2*DiscRadius],...
                        'Curvature',[1 1],  'FaceColor',me.FaceColor,...
                        'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );

                    % Draw "big holes":
                    if (me.RadialHoleCount>0)
                        holeAngs = linspace(0,2*pi,me.RadialHoleCount+1);
                        holeRadiusToCenter = me.RadialHolePosRatio * DiscInnerRadius;
                        holeRadius = me.RadialHoleRadiusRatio * DiscInnerRadius;
                        for i=1:me.RadialHoleCount,
                           th = ang+holeAngs(i);
                           cx = pts(idx1,1) + cos(th)*holeRadiusToCenter;
                           cy = pts(idx1,2) + sin(th)*holeRadiusToCenter;
                           rectangle('Position',[cx-holeRadius cy-holeRadius holeRadius*[2 2]],...
                                'Curvature',[1 1],  'FaceColor',[1 1 1],...
                                'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
                        end
                    end
                    
                    % Draw "pin" points
                    for k=1:2,
                        if (r_(k)>0)
                            rectangle('Position',[pts(k,1)-r_(k) pts(k,2)-r_(k) 2*r_(k) 2*r_(k)],...
                                'Curvature',[1 1],  'FaceColor',[1 1 1],...
                                'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
                        end
                    end
                    
                    
                otherwise
                    error('Unknown render style for link: "%s"',char(me.render_style));
            end
            
        end % End of function draw()
        
        % Returns the current coordinates of all the points defined in the
        % link, as a Nx2 matrix with N the number of points.
        function [pts] = getAllPointsCoords(me,q,parent)
            nPts = length(me.points);
            pts=zeros(nPts,2);
            for i=1:nPts,
                pts(i,1:2)=me.points(i).getCurrentCoords(q,parent);
            end
        end % of getAllPointsCoords()
        
    end
    
end

