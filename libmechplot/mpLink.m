classdef mpLink
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
        points = mpPoint.empty;
        id;
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
            plot([pts(1,1) pts(2,1)], [pts(1,2) pts(2,2)],'Color',[0 0 0],'LineWidth',3);
        end
    end
    
end

