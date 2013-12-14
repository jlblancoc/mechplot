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
        % Optional: If >0, mechplot will use this fixed length for 2-points
        % links (bars), instead of the line connecting the two points. Only
        % useful for didactic purposes to illustrate a "broken" mechanism,
        % for example.
        bar_length = 0; 
        
        % Render params for "Disc" (all have defaults values)
        % r;  % (Shared with other renderers) radiuses of the holes (vector, length=2)
        %FaceColor  % (Shared with other renderers)
        %LineWidth  % (Shared with other renderers)
        RadialHoleCount = 4 % Number of "large" holes in the middle of the disc. "0" to disable.
        RadialHolePosRatio    = 0.65;
        RadialHoleRadiusRatio = 0.25;
        DiscCenterPointIdx = 1; % The index in "points()" for the disc center (default=1, the first point)
        DiscRadiusPointIdx = 2; % The index in "points()" for determining the disc radius (default=2, the second point)
        
        % Render params for "ExternalSpurGear" & "InternalSpurGear" (all have defaults values)
        % *All of "Disc"* above, plus:
        gearNumTeeth = 50;  % Number of teeth
        gearAddendum;   % In distance units
        gearDedendum;   % In distance units
        
        % Additional render params for "InternalSpurGear"
        internalGearOutermostRadius; % In distance units 
        
    end
    
    % "Static" data: precomputed stuff
    properties(Constant, GetAccess=private)
        SINCOS_N_POINTS = 20;
        SINs = sin(linspace(0,pi,mpLink.SINCOS_N_POINTS))';
        COSs = cos(linspace(0,pi,mpLink.SINCOS_N_POINTS))';
    end
    
    % "Cached" data
    properties(GetAccess=private,SetAccess=private)
        GEAR_PROFILE_PTS = [];  % Cache of gear profiles: (x,y) points
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
                    ang = atan2(pts(2,2)-pts(1,2),pts(2,1)-pts(1,1));
                    
                    % Get the cooords of both bar end points:
                    if (me.bar_length>0)
                        % Truncate bar length:
                        pts(2,:)=pts(1,:)+[cos(ang) sin(ang)]*me.bar_length;
                    end

                    % Draw nice, rounded filled bar:
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

                % Render: Disc or gears
                % ---------------------------------
                case {mpLinkRenderStyle.Disc, mpLinkRenderStyle.ExternalSpurGear, mpLinkRenderStyle.InternalSpurGear}
                    assert(nPts>=2);
                    me.drawDiscGear(q,parent,pts);
                    
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
        
    end % end public methods

	%% Private methods:
    methods(Access=private)

        % Renders the link as a disc / gear
        function [] = drawDiscGear(me,q,parent,pts)
            r_ = mpi_get_param(me.r, parent.problemMaxDim*0.01* ones(2,1));

            idx1=me.DiscCenterPointIdx; % The index in "points()" for the disc center
            idx2=me.DiscRadiusPointIdx; % The index in "points()" for determining the disc radius

            ang = atan2(pts(idx2,2)-pts(idx1,2),pts(idx2,1)-pts(idx1,1));
            DiscKinematicRadius = hypot(pts(idx2,2)-pts(idx1,2),pts(idx2,1)-pts(idx1,1));
            DiscInnerRadius = DiscKinematicRadius - r_(2)*1.9;
            DiscRadius = DiscKinematicRadius + r_(2)*1.9;

            % Draw perimeter shape: 
            switch (me.render_style) 
                % Draw disc circle: 
                case mpLinkRenderStyle.Disc
                    rectangle('Position',[pts(idx1,1)-DiscRadius pts(idx1,2)-DiscRadius 2*DiscRadius 2*DiscRadius],...
                        'Curvature',[1 1],  'FaceColor',me.FaceColor,...
                        'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );

                % Draw external spur gear: 
                case {mpLinkRenderStyle.ExternalSpurGear,mpLinkRenderStyle.InternalSpurGear}
                    % Generate the shape, if not done before:
                    if (isempty(me.GEAR_PROFILE_PTS))
                        assert(me.gearNumTeeth>=13);
                        gR = DiscKinematicRadius; % "Gear radius"
                        gRadd_ = mpi_get_param(me.gearAddendum, parent.problemMaxDim*0.01);
                        gRded_ = mpi_get_param(me.gearAddendum, parent.problemMaxDim*0.01);
                        gROut_ = mpi_get_param(me.internalGearOutermostRadius, gR + 3*gRded_);
                        
                        if (me.render_style==mpLinkRenderStyle.InternalSpurGear)
                            gR1 = gR-gRded_;  % external radius
                            gR2 = gR+gRadd_;  % internal radius
                        else
                            gR1 = gR+gRadd_;  % external radius
                            gR2 = gR-gRded_;  % internal radius
                        end                        

                        % Gear drawing aux. params:
                        dA = 2*pi/me.gearNumTeeth;  % angle between teeth

                        me.GEAR_PROFILE_PTS=[];
                        for k=1:me.gearNumTeeth,
                            a = dA*(k-1);  % Start angle of this tooth
                            me.GEAR_PROFILE_PTS=[me.GEAR_PROFILE_PTS, ...
                                gR1*[cos(a);sin(a)],...
                                gR1*[cos(a+dA/8);sin(a+dA/8)],...
                                gR*[cos(a+dA/4);sin(a+dA/4)],...
                                gR2*[cos(a+dA/4);sin(a+dA/4)],...
                                gR2*[cos(a+dA*3/4);sin(a+dA*3/4)],...
                                gR*[cos(a+dA*3/4);sin(a+dA*3/4)],...
                                gR1*[cos(a+dA*7/8);sin(a+dA*7/8)] ...
                                ];
                        end
                        % For internal gears, add the solid part of the
                        % disc, from the teeth to "gROut_" radius:
                        if (me.render_style==mpLinkRenderStyle.InternalSpurGear)
                            angs = linspace(0,2*pi,100);
                            me.GEAR_PROFILE_PTS=[me.GEAR_PROFILE_PTS, ...
                                gROut_.*[cos(angs);sin(angs)] ];                            
                        end
                    end % end generate shape for first time
                    % Render shape:
                    [xs, ys]=mpi_transform_shape([],[], me.GEAR_PROFILE_PTS(1,:),me.GEAR_PROFILE_PTS(2,:), pts(1,1),pts(1,2),ang);
                    fill(xs,ys,me.FaceColor,'LineWidth',me.LineWidth);                            
            end % end switch

            % Draw "big holes":
            if (me.RadialHoleCount>0 && me.render_style~=mpLinkRenderStyle.InternalSpurGear)
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
        end % end drawDiscGear()
        
    end % end private methods

    
end

