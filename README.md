% this code generates 2D n-th order spline, plots it and gives the
% polynomials for each spline in a cell array (polynomial_cell_array)
% it uses multible polynomial , one polynomial between two point
% unlike matlab built in spline generator which uses interpolation that
% connect all point in one single polynomial, the proplem with this is when
% you have large data ( eg. 100 point ) it will generate 100-th order
% polynomial that will have hard osillation at the end.
% matrix = [ y-axis  ; x-axis]
% example at the end
