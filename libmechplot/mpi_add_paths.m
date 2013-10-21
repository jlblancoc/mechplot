function [] = mpi_add_paths()
%MPI_ADD_PATHS Internal helper function to make sure we have Mechplot in PATH
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot

if ~exist('mpi_add_props.m','file')
    addpath([pwd,'/internal']);
end

end

