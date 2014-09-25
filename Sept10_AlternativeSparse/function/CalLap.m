function [ lap ] = CalLap( graph )
%CAL_LAP Summary of this function goes here
%   Detailed explanation goes here
    D = diag(sum(graph));
    lap = D - graph;
    
%    lap = D^(-1/2)*lap*D^(-1/2);
end

