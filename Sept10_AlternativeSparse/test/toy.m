img =   diag(ones(6,1)*128,2) + ...
        diag(ones(6,1)*128,-2) + ...
        diag(ones(7,1)*128,1) + ...
        diag(ones(7,1)*128,-1) + ...
        diag(ones(8,1)*128);
%img(4,4) = 255;
%img(5,5) = 0;

neis = [-1,0 ; 1,0 ; 0,1 ; 0,-1];    
graph = zeros(8);

for i = 1:8,
    for j = 1:8,
        ind_node = sub2ind([8,8] , i , j );
        for i_nei = 1:4,
            sub_nei = [i,j] + neis( i_nei , 1:2);
            if sub_nei(1)>0 && sub_nei(1)<9 && sub_nei(2)>0 && sub_nei(2)<9
                ind_nei = sub2ind([8,8] , sub_nei(1) , sub_nei(2));
                graph(ind_node , ind_nei ) = 1;
                graph(ind_nei , ind_node ) = 1;
            end
        end
    end
end

lap = CalLap(graph);


lamda = 10;
h=10;
slct = diag(ones(64,1));

H = lamda*(lap^h) + slct;
f = -double(img(:));
x = quadprog(H,f);

imga = uint8(reshape(x,[8,8]));