% Example 1.6 , chapter 1, page 43
% scaffold_optimized.m
% Optimized 3-variable LP based on static analysis

clc;
clear;

% --- Given Parameters ---
% Beam weights
w1 = 100;   % N
w2 = 50;    % N
w3 = 30;    % N

% Max rope capacities
W1 = 1000;  % Ropes A and B
W2 = 800;   % Ropes C and D
W3 = 500;   % Ropes E and F

% --- Linear Program Setup ---
% Design variables: x = [x1; x2; x3]
% Objective: Maximize x1 + x2 + x3
f = [-1; -1; -1];  % (minimize -x1 - x2 - x3)

% Inequality constraints: A * x <= b
% Each row corresponds to one rope limit

A = [
    2/3, 2/3, 1/3;     % TA ≤ W1 - offset_A
    1/3, 1/3, 2/3;     % TB ≤ W1 - offset_B
    0,   1/2, 1/8;     % TC ≤ W2 - offset_C
    0,   1/2, 1/8;     % TD ≤ W2 - offset_D
    0,   0,   1/4;     % TE ≤ W3 - offset_E
    0,   0,   3/4;     % TF ≤ W3 - offset_F
];

% Constant terms (move known weights to RHS)
b = [
    W1 - (1/2)*w1 - (2/3)*w2 - (4/9)*w3;   % TA
    W1 - (1/2)*w1 - (1/3)*w2 - (5/9)*w3;   % TB
    W2 - (1/2)*w2 - (1/4)*w3;              % TC
    W2 - (1/2)*w2 - (1/4)*w3;              % TD
    W3 - (1/2)*w3;                         % TE
    W3 - (1/2)*w3;                         % TF
];

% Lower bounds
lb = [0; 0; 0];  % x1, x2, x3 ≥ 0

% --- Solve with linprog ---

options = optimoptions('linprog', 'Display', 'off');
[x_opt, fval, exitflag, output] = linprog(f, A, b, [], [], lb, [], options);

% --- Display Results ---

if exitflag == 1
    fprintf('✅ Optimal solution found.\n');
    fprintf('Maximum total load (x1 + x2 + x3): %.2f N\n\n', -fval);
    fprintf('Individual loads:\n');
    fprintf('x1 = %.2f N\n', x_opt(1));
    fprintf('x2 = %.2f N\n', x_opt(2));
    fprintf('x3 = %.2f N\n', x_opt(3));
else
    fprintf('❌ Optimization failed: %s\n', output.message);
end

% ANALYSE DU COMPORTEMENT DE LA SOLUTION OPTIMALE
% ------------------------------------------------
% Dans la formulation actuelle, On maximise : x1 + x2 + x3. 
% Aucune contrainte supplémentaire n’impose de répartition ou 
% de symétrie dans les charges appliquées sur les trois poutres. 
% Le solveur privilégie naturellement le chargement de x1 et x3, 
% car le système est "plus favorable" à ces charges dans les limites imposées 
% par les capacités maximales des cordes.
% Cela permet au modèle d’éviter d’utiliser la poutre 2 (x2 ≈ 0),
% qui introduit des tensions intermédiaires (TC, TD) et consomme
% inutilement de la marge sur les cordes C, D et E.
