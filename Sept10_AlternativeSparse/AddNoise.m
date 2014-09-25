function [noised] = AddNoise(ori)
    size_ori = size(ori);
    %Gaussian    
    noise_normal = normrnd(0,5,size_ori);
    noised = uint8(double(ori) + noise_normal);
    %impulse
    rate = 0.8;
    select_mat = rand(size_ori);
    noise = (round((rand(size_ori)))*2-1)*127.5+127.5;
    noised(select_mat>rate) =  noise(select_mat>rate);   
    

end