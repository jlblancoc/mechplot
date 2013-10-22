classdef mpPoint
    %MPPOINT Description of a point within a mechanism. 
    % Used in the array mpLink.points(:)
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpPoint(), mpPoint('is_fixed',0), ...
        function s = mpPoint(varargin)
            s.is_fixed = 0;
            s=mpi_add_props(s,varargin{:});
        end
    end
    
    
    %% Properties
    properties(GetAccess=public, SetAccess=public)
        is_fixed;  % 0 / 1
        fixed_x_idx; % Index in q_fixed()
        fixed_y_idx; % Index in q_fixed() 
        x_idx; % Index in q()
        y_idx; % Index in q()
    end
    
    %% Methods:
    methods
    end
    
end

