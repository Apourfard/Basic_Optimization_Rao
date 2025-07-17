% Book Engineering Optimization: Theory and Practice, Fourth Edition Singiresu S. Rao
% Copyright © 2009 by John Wiley & Sons, Inc.

% Example 1.1 Design a uniform column of tubular section
% Chapter 1, page 27

clc; clear;

% Given data
P = 2500; % kgf
sigma_y = 500; % kgf/cm^2
E = 0.85e6; % kgf/cm^2
L = 250; % cm

% Objective function (book form)
objfun = @(x) 9.82*x(1)*x(2) + 2*x(1);

% Nonlinear constraints based on book
function [c, ceq] = nonlincon(x)
    d = x(1);
    t = x(2);
    P = 2500;
    sigma_y = 500;
    E = 0.85e6;
    L = 250;
    c = zeros(2,1);
    
    % Constraint g1: induced stress <= yield stress
    c(1) = (P/(pi*d*t)) - sigma_y;
    
    % Constraint g2: induced stress <= buckling stress
    buckling_stress = (pi^2 * E * (d^2 + t^2)) / (8 * L^2);
    c(2) = (P/(pi*d*t)) - buckling_stress;
    
    ceq = [];
end

% Bounds
lb = [2, 0.2];
ub = [14, 0.8];

% Initial guess (mid values)
x0 = [5, 0.4];

% Use fmincon to solve
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
[x_opt, fval] = fmincon(objfun, x0, [], [], [], [], lb, ub, @nonlincon, options);

% Display results
fprintf('Optimal mean diameter d = %.4f cm\n', x_opt(1));
fprintf('Optimal thickness t = %.4f cm\n', x_opt(2));
fprintf('Minimum cost = %.4f\n', fval);
