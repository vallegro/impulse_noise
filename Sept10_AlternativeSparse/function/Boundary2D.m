function [ Ub ] = Boundary2D( b1,b2,b3 )
%BOUNDARY2D Summary of this function goes here
%   Detailed explanation goes here


p = 0.92;
alpha = p/(1+p^2);
vec = alpha*ones(9,1);
q = eye(10) - diag(vec,1) - diag(vec,-1);

B = alpha*b1*q + alpha*q*b2 - alpha^2*b3;
Ub = q^-1*B*q^-1;

%disp('Ub');
%disp(Ub);

end

