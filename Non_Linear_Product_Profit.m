% Book Engineering Optimization: Theory and Practice, Fourth Edition Singiresu S. Rao
% Copyright © 2009 by John Wiley & Sons, Inc.

% Example 1.5 - Quadratic Programming Problem, chapter 1, page 42
% Ma fonction est exactement la même que celle du livre. La structure est identique, juste écrite dans un ordre différent.

% Objective function (negative profit)
profit = @(x) -(...
    x(1)*(2.00 - 0.0005*x(1) - 0.00015*x(2)) + ...
    x(2)*(3.50 - 0.0002*x(1) - 0.0015*x(2)) - ...
    (x(1) + 0.5*x(2))*(0.375 - 0.00005*(x(1) + 0.5*x(2))) - ...
    (0.2*x(1) + 0.5*x(2))*(0.75 - 0.0001*(0.2*x(1) + 0.5*x(2))) ...
);

% Integer variables: both x(1)=xA and x(2)=xB
intcon = [1, 2];

% Constraints (Ax <= b)
A = [1   0.5;
     0.2 0.5];
b = [1000; 250];

% Lower and upper bounds
lb = [0, 0];          % Can't produce negative units
ub = [10000, 10000];  % Arbitrary large upper bounds

% Call GA
options = optimoptions('ga', 'Display', 'iter', 'UseParallel', false);
[x_opt, max_profit_neg] = ga(profit, 2, A, b, [], [], lb, ub, [], intcon, options);

% Display results
xA_opt = x_opt(1);
xB_opt = x_opt(2);
max_profit = -max_profit_neg;

fprintf('Optimal xA: %d units\n', xA_opt);
fprintf('Optimal xB: %d units\n', xB_opt);
fprintf('Maximum Profit: $%.2f\n', max_profit);
