function [ lap ] = Node2LapSlct( graph_seed , slct )
%NODE2LAPS Summary of this function goes here
% calculate the sub-graph laplacian, the target subgraph is marked with
% slct
%   Detailed explanation goes here
block_size = size(graph_seed);
block_total = block_size(1)*block_size(2);

graph = zeros(block_total);

neis = [0,-1 ; 0,1 ; 1,0 ; -1,0];

var_block = max( var(graph_seed(:)), 0.01 );
        
for i_node = 1:block_total,
    [sub1,sub2] = ind2sub(block_size, i_node);
    for i_nei = 1:4
        sub_nei = [sub1,sub2] + neis(i_nei,:);
        if sub_nei(1)>0 && sub_nei(2)>0 && sub_nei(1)<= block_size(1) && sub_nei(2)<=block_size(2),
            ind_nei = sub2ind( block_size, sub_nei(1),sub_nei(2));
            graph( ind_nei , i_node ) = exp( -(graph_seed(i_node)-graph_seed(ind_nei))^2/var_block );
            graph( i_node , ind_nei ) = graph( ind_nei , i_node );
        end
    end
end
    
graph(~slct,:)=0; graph(:,~slct)=0;

lap = CalLap(graph);

end

