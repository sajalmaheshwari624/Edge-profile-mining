function [ hmf1 ] = apna_heatmap(fin_im,vis_im)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


hm = zeros(size(fin_im));

for i=1:64:size(fin_im,1)
    for j=1:64:size(fin_im,2)
        close all
         patch = fin_im(i:min(i+128,size(fin_im,1)),j:min(j+128,size(fin_im,2)));
         nz = find(patch ~= 0);
         if(numel(nz) == 0)
             valin = 0;
         else
             valin = mean(patch(nz));
         end
         hm(i:min(i+128,size(fin_im,1)),j:min(j+128,size(fin_im,2))) = 5*valin;
    end
end

hmf = hm.*vis_im;
hmf1 = medfilt2(hmf);


end

