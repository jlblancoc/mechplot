function [ s ] = mp_new_link( varargin )
%MP_NEW_LINK Creates a new link (or "element") of a structure, with an optional list of properties:
%   ...
%
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot

mpi_add_paths();
s=struct('class','link');
s=mpi_add_props(s,varargin{:});

end

