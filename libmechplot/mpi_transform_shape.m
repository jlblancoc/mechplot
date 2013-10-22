function [ xs,ys ] = mpi_transform_shape( xs,ys, shape_xs,shape_ys, cx,cy,ang )
%MPI_TRANSFORM_SHAPE Appends the shape points (shape_xs,shape_ys) to
%(xs,ys) after transforming them by rotating "ang" radians and movint to
%(cx,cy).
    xs=[xs(:); cx+cos(ang)*shape_xs-sin(ang)*shape_ys]; 
    ys=[ys(:); cy+sin(ang)*shape_xs+cos(ang)*shape_ys];
end

