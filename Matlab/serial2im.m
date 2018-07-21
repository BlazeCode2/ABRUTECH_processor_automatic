fpga = serial('COM17');
fpga.InputBufferSize = 10000000;
fpga.OutputBufferSize = 10000000;
fpga.BaudRate = 115200;

fclose(instrfind);
fopen(fpga);

fpga.Timeout = 40;                  % One minute timeout period
fprintf('\nReady to receive..Press the button\n');
% im_received = fread(fpga,262144);
 im_received = fread(fpga);
fclose(instrfind);
n=sqrt(numel(im_received));
% im_array = zeros(65536,1);
 im_out = reshape(im_received', [n,n]);
 imshow(uint8(im_out));
 
