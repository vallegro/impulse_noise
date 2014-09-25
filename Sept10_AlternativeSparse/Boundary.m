function [ block_res ] = Boundary( block_b_nb )
%BOUNDARY Summary of this function goes here
% use the blocks by NoBoundary as boundaries and calculate the boundary
% response, then do transform based denoising 
% block_res in the main part is 10x10 and trimed to 8x8 in the final step
%   Detailed explanation goes here



block_b_nb_d = double(block_b_nb);  % block with boundary, produced by NoBoundary, turned into double

block_b_size = size(block_b_nb);
block_size = block_b_size - 2;

%---compute the boundary response and the--->> 
b1 = block_b_nb_d; b1(2:end-1,:) = 0;
b2 = block_b_nb_d; b2(:,2:end-1) = 0;
b3 = block_b_nb_d; b3(2:end-1,:) = 0; b3(:,2:end-1) = 0;

response_b = Boundary2D(b1,b2,b3);

block_residual = block_b_nb_d - response_b;  
block_residual = block_residual( 2:end-1 , 2:end-1 );   % the signal going to be denoised
%<<--------------------------------------------


block_res = block_b_nb_d;                               % block_res and graph_seed are of size 10x10
block_res(2:end-1, 2:end-1) = response_b(2:end-1, 2:end-1); 
%replace the signal in the center with the boundary response, and the graph will build based on this  
graph_seed = zeros(block_b_size);

iter_count=0;
while sum(sum(abs(graph_seed - block_res))) > 10,
    iter_count = iter_count + 1;
    if iter_count>10;
        break;
    end
        
    graph_seed = block_res;
    %disp(graph_seed);
    lap = Node2LapB(graph_seed);
    
    lamda = 3;
    h = 1;
    
    old_min = Inf;    %the converge target of the inner loop
    slct = ones(block_size(1)*block_size(2),1);
    
    H = lamda*(lap^h) + diag(slct);
    f = -block_residual(:).*slct;                       %the optimize signal target
    options = optimoptions(@quadprog,'Display','off');
    x = quadprog(H,f,[],[],[],[],[],[],[],options);
    
    err_raw = abs( x - block_residual(:));
    beta = (err_raw'*err_raw + lamda*x'*lap*x)/(block_size(1)*block_size(2)*0.25);
    
    while true,
        %>>optimizing---------------------------
        H = lamda*(lap^h) + diag(slct);
        f = -block_residual(:).*slct;
        options = optimoptions(@quadprog,'Display','off');
        x = quadprog(H,f,[],[],[],[],[],[],[],options);
        
        %calculate the joint indicator----------
        err_raw = abs( x - block_residual(:));
        err = err_raw.*slct;
        new_min = err'*err + lamda*x'*lap*x - beta* sum(slct);
        %fprintf('%.2f %.2f %.2f\n', err'*err , lamda*x'*lap*x , -beta* sum(slct))
        if new_min < old_min,
            old_min = new_min;
            block_res(2:end-1, 2:end-1) = ...
                reshape(x,block_size(1),block_size(2)) + response_b(2:end-1, 2:end-1);
            
            %slct_mat = reshape(slct , 8 , 8);
            %disp(slct_mat)
            
            slct = slct & err~=max(err);
        else
            break;
        end
    end
end

block_res = block_res(2:end-1,2:end-1);


end

