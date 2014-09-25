function [ lap_b ] = Node2LapB( graph_seed )
%NODE2LAPB Summary of this function goes here
% compute the laplacian matrix from a image block with boundary
% SLCT IS USED TO EXCLUDE THE IMPULSE NOISE 
% Detailed explanation goes here

block_b_size = size(graph_seed);
block_b_total = block_b_size(1) * block_b_size(2);

graph_b = zeros(block_b_total);

neis = [-1,0 ; 1,0 ; 0,1 ; 0,-1];

var_block = max(var(graph_seed(:)),0.01);

for i_node = 1:block_b_total,
    [sub1 , sub2] = ind2sub(block_b_size,i_node );
    for i_nei = 1:4,
        sub_nei = [ sub1 , sub2 ] + neis( i_nei , : );
        if sub_nei(1)>0 && sub_nei(2)>0 && sub_nei(1)<=block_b_size(1) && sub_nei(2)<=block_b_size(2)
            ind_nei = sub2ind( block_b_size , sub_nei(1) , sub_nei(2) );
            graph_b( i_node, ind_nei) = exp( -( graph_seed(i_node)-graph_seed(ind_nei))^2/var_block );
            graph_b( ind_nei, i_node) = graph_b( i_node, ind_nei);                       
        end 
    end
end

lap = CalLap(graph_b);

boundary = ones(block_b_size);
boundary(2:end-1 , 2:end-1) = 0;

boundary_ind = find(boundary ~= 0);
lap_b = lap;
lap_b(boundary_ind,:) = [];
lap_b(:,boundary_ind) = [];

end

