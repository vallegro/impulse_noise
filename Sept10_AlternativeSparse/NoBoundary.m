function [ block_res ] = NoBoundary( block_b )
%NO_BOUNDARY Summary of this function goes here
% part of the chessboard denoising procedure
% do demoising without bioundary conditions

%   Detailed explanation goes here
    block_b_d = double(block_b(2:end-1,2:end-1));
    block_size = size(block_b_d);
    disp(block_b_d);
    
    graph_seed = zeros(block_size);                  %graph_seed and block_res are the converge targets of the main loop 
    block_res = ones(block_size)*255;
    iter_count = 0;

    
    while sum(sum(abs(graph_seed - block_res))) > 0.1,   %main loop
        iter_count = iter_count + 1;
        fprintf('--------%d------------\n',iter_count);
        if iter_count>10;
            break;
        end
        
        graph_seed = block_res;
        disp(graph_seed);
        %>>----------------------------------------
        %construct the graph since the graph only depends on the seed and is not going to be altered in the inner loop 
        lap = Node2Lap(graph_seed);
        %<<-----------------------------------------
        
        lamda = 0.7;
        h = 1;        
        
        old_min = Inf;    %the converge target of the inner loop
        slct = ones(block_size(1)*block_size(2),1);  
        
        H = lamda*(lap^h) + diag(slct);
        f = -block_b_d(:).*slct;
        options = optimoptions(@quadprog,'Display','off');
        x = quadprog(H,f,[],[],[],[],[],[],[],options);
        
        err_square_vec = ( x - block_b_d(:)).^2;
        beta = (sum(err_square_vec) + lamda*x'*lap^h*x )/(block_size(1)*block_size(2))*0.5;
        gamma = 3;
        block_res = reshape(x,8,8);
        %disp(beta);
        
        pick_i = 1;
        while true,
            fprintf('$$%d$$\n',pick_i);
            pick_i = pick_i+1;
            %>>optimizing---------------------------
            H = lamda*(lap^h) + diag(slct);
            f = -block_b_d(:).*slct;
            options = optimoptions(@quadprog,'Display','off');
            x = quadprog(H,f,[],[],[],[],[],[],[],options);
            x_res = reshape(x,block_size(1),block_size(2));  
            disp(x_res);
            
            %calculate the joint indicator----------
            err_square_vec = ( x - block_b_d(:)).^2;
            err_square_vec = err_square_vec.*double(slct);
            noise_impulse =  block_b_d(:).*(~slct);            
            
            lap_vec = (x'*lap).*x';
            slct_vec = err_square_vec + abs(lap_vec');
            
            err_square_mat = reshape(err_square_vec,8,8);
            disp(err_square_mat);
            
            %calculate the noise graph
            noise_graph = graph_seed; 
            noise_lap = Node2LapSlct(noise_graph,~slct);
            edge_num = sum(sum(tril(noise_lap,-1)~=0));
            
            noise_lapsmooth_vec = (noise_impulse'*noise_lap).*noise_impulse';
            
            
            new_min = sum(err_square_vec) + lamda*x'*lap*x + beta* sum(~slct) +gamma*(300*edge_num - sum(noise_lapsmooth_vec)); %revise the prior here
            
            %fprintf('%.2f %.2f %.2f %.2f %.2f\n', sum(err_square_vec) , lamda*x'*lap*x , beta* sum(~slct), 400*edge_num ,sum(noise_lapsmooth_vec))
            if new_min < old_min,
                slct_mat = reshape(slct , 8 , 8);
                disp(slct_mat)
                
                old_min = new_min;
                block_res = reshape(x,block_size(1),block_size(2));  
                slct = slct & slct_vec~=max(slct_vec);
            else
                
                break;
            end
        end
    end   
end