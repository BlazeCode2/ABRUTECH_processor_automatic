function SSD = error_analyse_sanke(im_in,im_out,factor);
im_in=double(im_in);
im_out=double(im_out);
ML_down_sampled=im_in;

for k=1:log2(factor) %factor x2,x4,x8
    for j=1:2:511
        for i=1:2:511
            ML_down_sampled((i+1)/2,(j+1)/2,:)=round((ML_down_sampled(i,j,:)+ML_down_sampled(i+1,j+1,:)+ML_down_sampled(i+1,j,:)+ML_down_sampled(i,j+1,:))./4);
        end
    end
end
[l w h]=size(im_out);
cropped=ML_down_sampled(1:l,1:w,:);
figure,imshow(uint8(cropped));
difference=abs(cropped-im_out);
max(difference);
difference_sqred=difference.^2;
SSD=sum(difference_sqred(:));
fprintf("\nSSD = %f\n",SSD);
% figure,heatmap(sum(difference,3)),title('Heat map');

end