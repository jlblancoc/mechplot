classdef mpPinnedGround < mpRenderizable
    %MPPINEDGROUND A point fixed to ground, with a "pinned" joint.
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpPinnedGround(1,2), mpPinnedGround(1,2,'Param',value), etc.
        function me = mpPinnedGround(fixed_x_idx,fixed_y_idx, varargin)
            me.fixed_x_idx = fixed_x_idx;
            me.fixed_y_idx = fixed_y_idx;
            me=mpi_add_props(me,varargin{:});
        end
    end

    
    %% Properties
    properties(GetAccess=public, SetAccess=public)
        fixed_x_idx; % Index of the x coordinate, in "parent.q_fixed"
        fixed_y_idx; % Index of the x coordinate, in "parent.q_fixed"
        
        % Render params (all have default values)
        r; % Inner pinned radius
        R; % Outter radius 
        L; % vertical length from pin point to the ground line
        orientation = pi/2; % Orientation in radians (default: 90 degrees)
        FaceColor = [0.9 0.9 0.9]; 
        LineWidth = 1; 
        drawGroundLine = 1;  % 0/1 (default: 1)
        drawGroundHatch = 1; % 0/1 (default: 1)
        grounWidth;      % Width of the hatched part below the ground.
        grounLineLineWidth = 2; % Line width of the ground line
        groundHatchLineWidth = 2;  % Line width for the hatch
        L2; % depth of the hatched area below the ground line
    end
    
    % "Static" data: precomputed stuff
    properties(Constant, GetAccess=private)
        SINCOS_N_POINTS = 16;
        SINs = sin(linspace(0,pi,mpPinnedGround.SINCOS_N_POINTS))';
        COSs = cos(linspace(0,pi,mpPinnedGround.SINCOS_N_POINTS))';
    end
    
    %% Public methods:
    methods(Access=public)
        
        % Render link:
        function draw(me, ~, parent)
            % Get the coords of the fixed point:
            x =  parent.q_fixed( me.fixed_x_idx );
            y =  parent.q_fixed( me.fixed_y_idx );
            
            % Render parameters:
            r_         = mpi_get_param(me.r, parent.problemMaxDim*0.01);
            R_         = mpi_get_param(me.R, parent.problemMaxDim*0.04);
            L_         = mpi_get_param(me.L, parent.problemMaxDim*0.05);
            grounWidth_half = 0.5 * mpi_get_param(me.grounWidth, parent.problemMaxDim*0.11);
            L2_        = mpi_get_param(me.L2, parent.problemMaxDim*0.03);

            % Draw rounded part:
            xs=[]; ys=[]; % Build shape array incrementally
            [xs, ys]=mpi_transform_shape(xs,ys, mpPinnedGround.COSs*R_,mpPinnedGround.SINs*R_, x,y,me.orientation-pi/2);
            bottom_xs=[-R_ +R_ +R_]'; bottom_ys=[-L_ -L_ 0]';
            [xs, ys]=mpi_transform_shape(xs,ys, bottom_xs,bottom_ys, x,y,me.orientation-pi/2);
            fill(xs,ys,me.FaceColor,'LineWidth',me.LineWidth);
            
            % Draw hatched ground part:
            if (me.drawGroundLine)
                [xs, ys]=mpi_transform_shape([],[], [-grounWidth_half +grounWidth_half],[-L_ -L_], x,y,me.orientation-pi/2);
                plot(xs,ys,'k','LineWidth',me.grounLineLineWidth);
            end
            if (me.drawGroundHatch)
                N = 8;
                xs=[];ys=[];
                xps=linspace(-grounWidth_half,grounWidth_half,N);
                for i=1:N,
                    lx = [xps(i) ; xps(i)-L2_];
                    ly = [-L_ ; -L_-L2_ ];
                    [xs(:,i), ys(:,i)]=mpi_transform_shape([],[],lx,ly,x,y,me.orientation-pi/2);
                end
                line(xs,ys,'Color',[0 0 0],'LineWidth',me.groundHatchLineWidth);
            end
            

            % Draw "pin" point
            rectangle('Position',[x-r_ y-r_ 2*r_ 2*r_],...
                'Curvature',[1 1],  'FaceColor',[1 1 1],...
                'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
        end
    end
end

