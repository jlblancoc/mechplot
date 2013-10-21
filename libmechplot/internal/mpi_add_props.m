function [ s ] = mpi_add_props( s, varargin )
%MPI_ADD_PROPS Adds a variable set of properties/values to "s"
%   Example: s = mpi_add_props(s,'Color',[1 1 1],'Type',4);
%
% Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
% License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
assert( mod(length(varargin),2)==0 );

for i = 1 : 2 : length(varargin)
    s = setfield(s, varargin{i},varargin{i+1});
end

end

