classdef mpRenderizable
    %MPRENDERIZABLE Base class for all drawable objects.
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    %% Constructor
    methods
        % Can be called like: mpLink(), mpLink('id',123), etc.
        % Add points with link.points(end+1)=mpPoint(...);
        function me = mpRenderizable(varargin)
            me.z_order=0;
            me=mpi_add_props(me,varargin{:});
        end
    end

    %% Properties
    properties(GetAccess=public, SetAccess=public)
        z_order; % Z-depth drawing order (larger values are "on the top" of smaller values)
    end
end

