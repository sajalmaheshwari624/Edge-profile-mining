function [ result fin_im len_im vis_im sim_im im_gray mag_mat val_total] = gaussian_fit_original( im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%% ******VERSION 1***** %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(size(im,3)==3)
    im_gray = rgb2gray(im);
else
    im_gray = im;
end
im1 = im2bw(im_gray);
im1 = medfilt2(im1);
label = bwlabel(im1);
pagelabel = mode(label(:));
rowlabel = mode(label,2);
r = find(rowlabel==pagelabel);
im_gray = im_gray(r(1):r(end),:);
scale = size(im_gray,1)/1024;
im_gray = imresize(im_gray,[1024,size(im_gray,2)/scale]);
im_gray1 = im_gray;

[grx gry] = gradient(double(im_gray));
fin_im = zeros(size(grx));
len_im = zeros(size(grx));
vis_im = zeros(size(grx));
sim_im = zeros(size(grx));
mag_mat = sqrt(double(grx).*double(grx) + double(gry).*double(gry));
precision = 0.05;
text = 0;
dev = [];
ratio = [];
count = 0;
THRESH = 5.8;
ind = find(mag_mat > THRESH);
counter_1 = 0;
f = 0;
tic
val_total = [];
for iter=1:numel(ind)
    [i j] = ind2sub(size(grx),ind(iter));
%     ill_patch = lpf(max(i-1,1):min(i+1,size(lpf,1)),max(j-1,1):min(j+1,size(lpf,2)));
%     ill_val = mean(ill_patch(:));
    if(vis_im(i,j) == 0)
        vis_im(i,j) = 1;
        flag = 0;
        mag = mag_mat(i,j);
        val = [];
        val = mag_mat(i,j);
        curx = j+0.5;
        cury = i+0.5;
        curpixY = j;
        curpixX = i;
        G_x = double(grx(i,j));
        G_y = double(gry(i,j));
        point = [curpixX,curpixY];
        ray = point;
        if(text == 0)
            if(G_x ~= 0)
                G_x = G_x/mag;
                G_y = G_y/mag;
            else
                G_y = G_y/mag;
            end
        else
            if(G_x ~= 0)
                G_x = -G_x/mag;
                G_y = -G_y/mag;
            else
                G_y = -G_y/mag;
            end
        end
        while(1)
            counter_1 = counter_1+1;
            curx = curx + G_x*precision;
            cury = cury + G_y*precision;
            if(floor(curx) ~= curpixX || floor(cury) ~= curpixY)
                curpixY = floor(curx);
                curpixX = floor(cury);
                if(curpixX < 1 || curpixX >= size(grx,1) || curpixY < 1 || curpixY >= size(grx,2))
                    break;
                end
                val = [val;mag_mat(curpixX,curpixY)];
                point = [curpixX,curpixY];
                ray = [ray;point];
                mag = mag_mat(curpixX,curpixY);
                if(mag < THRESH)
                    index = sub2ind(size(fin_im),ray(:,1),ray(:,2));
                    last_point = ray(end,:);
                    first_point = ray(1,:);
                    num_ray = sqrt((last_point(1)-first_point(1))^2+(last_point(2)-first_point(2))^2);
                    len_im(index) = num_ray;
             %       if(num_ray >= 2.4 && num_ray <= 13)
                        val = imresize(val,[10 1]);
                        vis_im(index) = 1;
                        mea = mean(val);
                        med = median(val);
                        s = std(val);
                        ref = normpdf(1:numel(val),5,6);
                        sim = corr(val,ref');
                        sim_im(index) = (sim);
                      %  fin_im(index) = std(val);
                      cons = 11;
                         if(sim > 0.81)
                             f = 1;
                        %     val = imresize(val,[10 1]);
                             count = count + 1;
                              if(f == 1)
                                val_total = [val_total val];
                                f = 0;
                              end
                          %  dev = [dev;std(val)];
                            fin_im(index) = std(val);
                            %index = sub2ind(size(fin_im),ray(:,1),ray(:,2));
                            
                         end
              %      end
                    break;
                end
            end
        end
    end
end
toc
%counter_1
%tic
if(count ~= 0)
    resnz = find(fin_im ~= 0);
    result = mean(fin_im(resnz));
    %result = mean(dev);
else
     result = 0;
end
%toc

end
