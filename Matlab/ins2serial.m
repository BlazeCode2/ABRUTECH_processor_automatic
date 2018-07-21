% clc,clear all,close all;
% im_in = imread('iron-man-3.png');
% 
% if(size(im_in,3) == 3)
%     im_in = rgb2gray(im_in);
% end
% % im_in=ones(512,512)*50;
% im_in=uint8(100.*double(im_in)./255);

ins_array=[0:255];
% im_array = im_in(:);
ins_array = uint8(ins_array);
% 
% im_array(1:10)=[1:10];
% im_array(262135:262144)=[11:20];
% im_array(65530:65540)=[30:40];

fpga = serial('COM17');
fpga.InputBufferSize = 10000000;
fpga.OutputBufferSize = 10000000;
fpga.BaudRate = 115200;

fclose(instrfind);
fopen(fpga);
fpga.Timeout = 60;  
fwrite(fpga,ins_array);
fclose(instrfind);