function [val] = mpi_get_param(param, defaultValue)
    %MPI_GET_PARAM Returns the parameter or, if undefined, the default
    %value.
    %   
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    if (isempty(param))
        val = defaultValue;
    else 
        val = param;
    end
end

