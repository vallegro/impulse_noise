clear all;
b = 2:9;
b1 = zeros(10);
b2 = zeros(10);
b3 = zeros(10);

b1(1,2:9) = b;
b1(end,2:9) = b+9;
b2(2:9,1) = b;
b2(2:9,end) = b+9;
b3(1,1) = 1;
b3(1,end) = 10;
b3(end,1) = 10;
b3(end,end) = 19;


p = 0.95;
alpha = p/(1+p^2);
vec = alpha*ones(9,1);
q = eye(10) - diag(vec,1) - diag(vec,-1);

B = alpha*b1*q + alpha*q*b2 - alpha^2*b3;
Ub = q^-1*B*q^-1;