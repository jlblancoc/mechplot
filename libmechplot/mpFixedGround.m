classdef mpFixedGround < mpRenderizable
    %MPFIXEDGROUND A point fixed to ground, with a "fixed" joint (can't
    %rotate)
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpFixedGround(1,2), mpFixedGround(1,2,'Param',value), etc.
        function me = mpFixedGround(fixed_x_idx,fixed_y_idx, varargin)
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
        orientation = pi/2; % Orientation in radians (default: 90 degrees)
        drawGroundLine = 1;  % 0/1 (default: 1)
        drawGroundHatch = 1; % 0/1 (default: 1)
        grounWidth;      % Width of the hatched part below the ground.
        grounLineLineWidth = 2; % Line width of the ground line
        groundHatchLineWidth = 2;  % Line width for the hatch
        L2; % depth of the hatched area below the ground line
        transparent = 0; % 0/1 (Default=0). Whether to clear the background first.
    end
    
    %% Public methods:
    methods(Access=public)
        
        % Render link:
        function draw(me, ~, parent)
            % Get the coords of the fixed point:
            x =  parent.q_fixed( me.fixed_x_idx );
            y =  parent.q_fixed( me.fixed_y_idx );
            
            % Render parameters:
            grounWidth_half = 0.5 * mpi_get_param(me.grounWidth, parent.problemMaxDim*0.11);
            L2_        = mpi_get_param(me.L2, parent.problemMaxDim*0.035);

            % Erase background first:
            if (~me.transparent)
                [xs, ys]=mpi_transform_shape([],[], [-grounWidth_half-L2_, grounWidth_half, grounWidth_half,-grounWidth_half-L2_]',[-L2_,-L2_,0,0]',x,y,me.orientation-pi/2);
                fill(xs,ys,[1 1 1],'EdgeColor',[1 1 1]);
            end

            % Draw hatched ground part:
            if (me.drawGroundLine)
                [xs, ys]=mpi_transform_shape([],[], [-grounWidth_half +grounWidth_half],[0 0], x,y,me.orientation-pi/2);
                plot(xs,ys,'k','LineWidth',me.grounLineLineWidth);
            end
            if (me.drawGroundHatch)
                N = 8;
                xs=[];ys=[];
                xps=linspace(-grounWidth_half,grounWidth_half,N);
                for i=1:N,
                    lx = [xps(i) ; xps(i)-L2_];
                    ly = [0 ; -L2_ ];
                    [xs(:,i), ys(:,i)]=mpi_transform_shape([],[],lx,ly,x,y,me.orientation-pi/2);
                end
                line(xs,ys,'Color',[0 0 0],'LineWidth',me.groundHatchLineWidth);
            end
        end
    end
end

