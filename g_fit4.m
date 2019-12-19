%tic
close all
clear
clc
file = dir('/home/sajal/Honours_project_2/DataFiles/images/*.jpg');
di = '/home/sajal/Honours_project_2/DataFiles/images/' ;
 di1 = '/home/sajal/final_dataset/images/';

%  file = dir('/home/sajal/Honours_project_2/apni_images/*.jpg');
%  di = '/home/sajal/Honours_project_2/apni_images/' ;
fmt = '.jpg';
arr1 = [];
%result_array = zeros(175,2);
image_counter = 130;
%while(image_counter <175)
close all
%image_counter = image_counter + 1
% str = strcat(di,num2str(image_counter),fmt);
% im = imread(str);
im = imread('/home/sajal/Honours_project_2/DataFiles/images/131.jpg');
[ result fin_im len_im vis_im sim_im im_gray mag_mat val_total] = gaussian_fit_original(im);
% arrcut = gaussian_fit_original(im);
% arr1 = [arr1;arrcut];
%result
%result_array(image_counter,:) = result;
%end
hmf1 = apna_heatmap(fin_im,vis_im);
subplot(1,2,1),image(vis_im);
subplot(1,2,2),image(im);
%end
%toc