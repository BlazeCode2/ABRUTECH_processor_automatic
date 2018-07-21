clc,clear all,close all;
%% ==========================DEFINE SERIAL=================================

fpga = serial('COM17');
fpga.InputBufferSize = 10000000;
fpga.OutputBufferSize = 10000000;
fpga.BaudRate = 115200;

%% ========================LOAD INSTRUCTIONS===============================
option_1=questdlg('Load Instructions ?');

if(strcmp(option_1,'Yes'))
    file=fopen('D:\downsampling_processor_fpga\Project Final_Auto\Compiler 3.0\binary.txt');
    [instructions ins_amount]=fscanf(file,'%i');
    ins_array=zeros(1,256);
    ins_array(1:ins_amount)=instructions;
    ins_array=uint8(ins_array);
    fclose(file);
    fprintf('Press Enter to load instructions to IRAM.\n');
    pause;
    clc;
    
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 10;  
    fwrite(fpga,ins_array);
    fclose(instrfind)
    fprintf('Instructions Loaded.\n');
    
end


%% ============================LOAD DATA===================================



option_2=questdlg('Select the type of image to use.','','RGB','Grayscale','Cancel','Grayscale');

if(isempty(option_2) | strcmp(option_2,'Cancel'))
    fprintf('\nProgram Terminated.\n');
    return ;
end

im_in = imread('iron-man-3.png');      %change image name here



if(strcmp(option_2,'Grayscale'))
    if(size(im_in,3) == 3)
        im_in = rgb2gray(im_in);       %convert to grayscale
    end
end

iter=size(im_in,3);                                %number of iterations to send

imwrite(im_in,'D:\downsampling_processor_fpga\Project Final_Auto\Processor output\Im_in.png');
clc;
for i=1:iter
    fprintf('Press Enter to transmit Image layer %i.\n',i);
    pause;
    clc;
    fprintf('Transmitting Image layer %i.........\n',i);
    im_array = im_in(:,:,i); %select layer to send.
    im_array = im_array(:);
    im_array = uint8(im_array);
    
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 60;  
    fwrite(fpga,im_array);
    fclose(instrfind)
    clc;
    fprintf('Image layer %i sent. \n\nProgram paused, press enter to receive the processed Image.\n',i)
%     pause;
    clc
    
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 10;                  % Timeout period in seconds
    fprintf('Ready to receive Image layer %i. Press send button on the board.\n',i);
    % im_received = fread(fpga,262144);
    im_received = fread(fpga);
    fclose(instrfind);
    clc;
    fprintf('Received Image layer %i.\n',i);
    
    received_size = ceil(sqrt(numel(im_received)));
    im_out(:,:,i)=reshape(im_received,[received_size,received_size]);
    pause(1.5);
    clc;
 
end
fprintf('\nReceived full Image.\n',i);
im_out=uint8(im_out);
imshow(im_out);
imwrite(im_out,'D:\downsampling_processor_fpga\Project Final_Auto\Processor output\Im_out.png');


