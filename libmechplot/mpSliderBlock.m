classdef mpSliderBlock < mpRenderizable
    %MPSLIDERBLOCK A "block" element (hollow tube section) that slides on a line defined by two arbitrary (fixed or moving) points.
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpSliderBlock(), mpSliderBlock('id',123), etc.
        % Add points with link.points(end+1)=mpPoint(...);
        function s = mpSliderBlock(varargin)
            s.id=0;
            s=mpi_add_props(s,varargin{:});
        end
    end

    
    %% Properties
    properties(GetAccess=public, SetAccess=public)
        id; % Identifier (Optional, only for the user to name each link)
        joint_point; % The center point. Must be set to a mpPoint() object.
        guide_points = mpPoint.empty(2,0); % A vector of length 2 with the two points that define the orientation of this block
        
        % Render params (all have defaults values)
        r;  % radius of the center hole at the pin joint.
        Width;  % width (diameter of the tube)
        Length; %
        FaceColor = [0.8 0.8 0.8];
        LineWidth = 1; 
    end
    
    %% Public methods:
    methods(Access=public)
        
        % Render link:
        function draw(me, q,parent)
            % Get the coords of all points:
            % -----------------------------
            assert(isa(me.joint_point,'mpPoint'));
            assert(length(me.guide_points)==2);
            
            % Center point:
            ct_coords = me.joint_point.getCurrentCoords(q,parent);
            
            guide_coords(1,1:2) = me.guide_points(1).getCurrentCoords(q,parent);
            guide_coords(2,1:2) = me.guide_points(2).getCurrentCoords(q,parent);
                          
            
            % Render parameters:
            r_ = mpi_get_param(me.r, parent.problemMaxDim*0.01);
            Width_ = mpi_get_param(me.Width, parent.problemMaxDim*0.07);
            Length_ = mpi_get_param(me.Length, parent.problemMaxDim*0.18);

            % orientation of the slider:
            ang = atan2(guide_coords(2,2)-guide_coords(1,2),guide_coords(2,1)-guide_coords(1,1));
                        
            [xs, ys]=mpi_transform_shape([],[], Length_*[-0.5,0.5,0.5,-0.5],Width_*[-0.5,-0.5,0.5,0.5], ct_coords(1,1),ct_coords(1,2),ang);
            fill(xs,ys,me.FaceColor,'LineWidth',me.LineWidth);
                    
            % Draw "pin" point:
            if (r_>0)
                rectangle('Position',[ct_coords(1)-r_,ct_coords(2)-r_,2*r_,2*r_],...
                    'Curvature',[1 1],  'FaceColor',[1 1 1],...
                    'EdgeColor',[0 0 0],  'LineWidth',me.LineWidth );
            end
           
        end % End of function draw()
       
    end
    
end

