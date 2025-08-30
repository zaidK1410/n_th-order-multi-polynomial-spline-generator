% this code generates 2D n-th order spline, plots it and gives the
% polynomials for each spline in a cell array (polynomial_cell_array)
% it uses multible polynomial , one polynomial between two point
% unlike matlab built in spline generator which uses interpolation that
% connect all point in one single polynomial, the proplem with this is when
% you have large data ( eg. 100 point ) it will generate 100-th order
% polynomial that will have hard osillation at the end.
% matrix = [ y-axis  ; x-axis]
% example at the end



global final_time_frame ;
global polynomial_cell_array;
polynomial_cell_array=[];

n = input("order of spline: ");

function times = generate_splines(matrix, m)
global polynomial_cell_array;

times = matrix(end, :);
times = transpose(times);

for r = 1:height(matrix) - 1
    points = matrix(r, :);
    points = transpose(points);

    nOfp = height(points);
    n = nOfp - 1;

    syms t;
    ts = t.^(0:m);  % Create powers of t for polynomial basis

    syms a [n m+1];
    matrix_polynomial = a * ts.';  % Polynomial matrix for each segment

    % Define equations for the constraints
    eqn = [];

    % Left boundary points
    for i = 1:n
        eqn = [eqn, subs(matrix_polynomial(i), t, times(i)) == points(i)];
    end

    % Right boundary points
    for i = 1:n
        eqn = [eqn, subs(matrix_polynomial(i), t, times(i + 1)) == points(i + 1)];
    end

    % Derivative continuity
    for k = 1:m-1
        for i = 1:n-1
            eqn = [eqn, subs(diff(matrix_polynomial(i), t, k), t, times(i + 1)) == ...
                       subs(diff(matrix_polynomial(i + 1), t, k), t, times(i + 1))];
        end
    end

    % Additional boundary conditions
    if m >= 2
        eqn = [eqn, subs(diff(matrix_polynomial(1), t, 1), t, times(1)) == 0];
    end
    if m >= 3
        eqn = [eqn, subs(diff(matrix_polynomial(end), t, 1), t, times(end)) == 0];
    end
    if m >= 4
        eqn = [eqn, subs(diff(matrix_polynomial(1), t, 2), t, times(1)) == 0];
    end
    if m >= 5
        eqn = [eqn, subs(diff(matrix_polynomial(end), t, 2), t, times(end)) == 0];
    end

    % Solve for coefficients
    spline_coefficients = solve(eqn, a);
    p = double(struct2array(spline_coefficients));
    
    % Store coefficients
    for i = 1:m+1
        polynomial_cell_array{r}(:, i) = p((i-1)*n+1:i*n);
        
    end  
    %flip
polynomial_cell_array{r} = fliplr(polynomial_cell_array{r});

    % Plot splines and points
    for i = 1:height(polynomial_cell_array{r})
        Tm = linspace(times(i), times(i + 1), 500);
        value = polyval((polynomial_cell_array{r}(i, :)), Tm);
        plot(Tm, value);
        hold on;
    end

    for i = 1:n+1
        plot(times(i), points(i), 'o');
    end
end

end

%----------------------------------------------------
% example
% matrix = [0 2 3 ; 1 2 3]
% generate_splines(matrix,n)
