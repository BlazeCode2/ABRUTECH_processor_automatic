clc,clear all,close all;
%% ==========================DEFINE SERIAL=================================

fpga = serial('COM17');
fpga.InputBufferSize = 10000000;
fpga.OutputBufferSize = 10000000;
fpga.BaudRate = 115200;

%% ========================LOAD INSTRUCTIONS===============================
option_1=questdlg('Load Instructions ?');
ins_list = {    'div4ds',...
                'DIVdownsample',...
                'downBy3',rr...
                'downBy5',...
                'bilinear_upsample',...
                'NN_upsample',...  
                'GaussianSmoothing',...
                'EdgeDetectVert',...
                'Custom_filter',...
                'PrimeFinder',...
                'Fibbonacci_Sequence',...
                'Pascal_triangle',...
                'factorial'};
            
ins_display_list = {'Downsample by 2 : Fast',...
                'Downsample by 2 : Initial',...
                'Downsample by 3',...
                'Downsample by 5',...
                'Upsample : Bilinear Interpolation',...
                'Upsample : Near Neighbour Interpolation',...
                'Gaussian Smoothing',...
                'Edge Detector',...
                'Custom Filter',...
                'Prime Finder',...
                'Fibonacci Sequence',...
                'Pascal Triangle',...
                'Factorial'};

if(strcmp(option_1,'Yes'))
    [indx,tf] = listdlg('ListString',ins_display_list,'SelectionMode','single','Name','Algorithms','ListSize',[320 180],'PromptString','Select an Algorithm');
    if (tf==1)
        binary_file=sprintf('D:\\downsampling_processor_fpga\\Project Final_Auto\\Compiler 3.0\\bin_%s.txt',char(ins_list(indx)));
        file=fopen(binary_file);
        [instructions ins_amount]=fscanf(file,'%i');
        ins_array=zeros(1,256);
        ins_array(1:ins_amount)=instructions;
        ins_array=uint8(ins_array);
        fclose(file);
        fprintf('Loading instructions to IRAM.\n');
        pause(1);


        fclose(instrfind);
        fopen(fpga);
        fpga.Timeout = 5;  
        fwrite(fpga,ins_array);
        fclose(instrfind)
        clc;
        fprintf('Instructions Loaded.\n');
        pause(0.5);
    end
end


%% ============================LOAD DATA===================================


if(indx<10)
    option_2=questdlg('Select the type of image to use.','','RGB','Grayscale','Cancel','Grayscale');

    if(isempty(option_2) | strcmp(option_2,'Cancel'))
        fprintf('\nProgram Terminated.\n');
        return ;
    end
    im_list = {    'iron-man-3',...
                    'Team',...
                    'Landscape',...
                    'Puppy',...
                    'Flower',...
                    'Group',...
                    'Waterfall',...
                    'iron-man-3-256'};

    im_display_list = {'Iron Man 512x512',...
                    'Team',...
                    'Landscape',...
                    'Labrador Puppy',...
                    'Flower',...
                    'Group',...
                    'Waterfall',...
                    'Iron Man 256x256'};
    [im_indx,tf] = listdlg('ListString',im_display_list,'SelectionMode','single','Name','Images','ListSize',[300 150],'PromptString','Select an Image');
    if (tf==1)
        image_file=sprintf('%s.png',char(im_list(im_indx)));
    else
        image_file=sprintf('iron-man-3.png');
    end
    im_in = imread(image_file);      %change image name here



    if(strcmp(option_2,'Grayscale')| indx==8)
        if(size(im_in,3) == 3)
            im_in = rgb2gray(im_in);       %convert to grayscale
        end
    end

    iter=size(im_in,3);                                %number of iterations to send

    imwrite(im_in,'D:\downsampling_processor_fpga\Project Final_Auto\Processor output\Im_in.png');
    clc;
    if(indx~=8)
        for i=1:iter
            clc;
            fprintf('Transmitting Image layer %i into DRAM.........\n',i);
            im_array = im_in(:,:,i); %select layer to send.
            im_array = im_array(:);
            im_array = uint8(im_array);

            fclose(instrfind);
            fopen(fpga);
            fpga.Timeout = 30;  
            fwrite(fpga,im_array);
%             fclose(instrfind)
            clc;
            fprintf('Image layer %i loaded. \n\nWaiting to be processed.\n',i)
            clc;
            if(indx==1 | indx==2)
                wait_time=10;
            elseif(indx==3 |indx==4)
                wait_time=8;
            else
                wait_time=30;
            end
            fprintf('Receiving processed Image layer %i.\n',i);
%             fclose(instrfind);
%             fopen(fpga);
            fpga.Timeout = wait_time;                  % Timeout period in seconds (10 for div by 4 else 30)
            
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
%         figure('NumberTitle', 'off', 'Name', 'Image in'),imshow(im_in),title(sprintf('Original Image.  (Size : 512 x 512)'));
%         figure('NumberTitle', 'off', 'Name', 'Image out'),imshow(im_out),title(sprintf('Processed Image.   (Size : %i x %i)',received_size,received_size));
  figure('NumberTitle', 'off', 'Name', 'Image in'),imshow(im_in),title(sprintf('Original Image.  (Size : 512 x 512)'),'FontSize',8);
        figure('NumberTitle', 'off', 'Name', 'Image out'),imshow(im_out),title([ins_display_list(indx),sprintf('   (Size : %i x %i)',received_size,received_size)],'FontSize',8);     
imwrite(im_out,'D:\downsampling_processor_fpga\Project Final_Auto\Processor output\Im_out.png');

    else
    for i=1:2
        clc;
        fprintf('Phase %i.\n Transmitting Image into DRAM.........\n',i);
        im_array = im_in(:);
        im_array = uint8(im_array);

        fclose(instrfind);
        fopen(fpga);
        fpga.Timeout = 30;  
        fwrite(fpga,im_array);
%         fclose(instrfind)
        clc;
        fprintf('Phase %i.\n\nImage loaded. \n\nWaiting to be processed.\n',i)
        clc;

%         fclose(instrfind);
%         fopen(fpga);
        fpga.Timeout = 30;                  % Timeout period in seconds (10 for div by 4 else 30)
        fprintf('Phase %i.\n\nReceiving processed Image.\n',i);
        im_received = fread(fpga);
        fclose(instrfind);
        clc;
        fprintf('Phase %i.\n\nReceived Image.\n',i);

        received_size = ceil(sqrt(numel(im_received)));
        im_out(:,:,i)=reshape(im_received,[received_size,received_size]);
        pause(1.5);
        clc;
    end
    fprintf('\nReceived full Image.\n',i);
    im_out=im_out.^2;
    im_out=sqrt(sum(im_out,3));
    im_out=uint8(im_out);
    figure('NumberTitle', 'off', 'Name', 'Image in'),imshow(im_in),title('Original Image','FontSize',8);
    figure('NumberTitle', 'off', 'Name', 'Image out'),imshow(im_out),title('Edge detection','FontSize',8);
    imwrite(im_out,'D:\downsampling_processor_fpga\Project Final_Auto\Processor output\Im_out.png');
    end

%Prime Finder    
    
elseif(indx==10)
    fprintf('Writing dummy data.....\n');
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 30;  
%     fwrite(fpga,randi(255,512*512,1));
fwrite(fpga,zeros(512*512,1));
%     fclose(instrfind)
    clc;
    fprintf('Receiving processed Data.....\n');
%     fclose(instrfind);
%     fopen(fpga);
    fpga.Timeout = 5;                  % Timeout period in seconds (10 for div by 4 else 30)
    im_received = fread(fpga);
    fclose(instrfind);
    clc;
    fprintf('Received Data.\n\n'); 
    pause(1);
    Memory_Index=[0:numel(im_received)-1]';
    Data = im_received(:);
    T=table(Memory_Index,Data);
     figure('NumberTitle', 'off', 'Name', 'Prime Numbers')
    uitable('Data',T{:,:},'ColumnName',{' Memory Location ',' Data '},...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

%Pascal Triangle

elseif(indx==12)
    fprintf('Resetting DRAM.....\n');
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 30;  
    fwrite(fpga,zeros(512*512,1));
%     fclose(instrfind)
    clc;
    fprintf('Receiving Pascal Triangle Coefficients.....\n');
%     fclose(instrfind);
%     fopen(fpga);
    fpga.Timeout = 4;                  % Timeout period in seconds (10 for div by 4 else 30)
    im_received = fread(fpga);
    fclose(instrfind);
    clc;
    fprintf('Received Data.\n\n'); 
    pause(1);
    pascal=['Pascal Triangle \n\n'];
    im_out=reshape(im_received,23,11);
    im_out=im_out';
    for i=1:11
        for j=1:23
           if(im_out(i,j)==0)
               pascal=[pascal,' '];
           else
               pascal=[pascal,int2str(im_out(i,j))];
           end
        end
        pascal=[pascal,'\n'];
    end 
    fprintf(pascal);
    
 %Fibonacci   
    
elseif(indx==11)
    fprintf('Writing dummy data.....\n');
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 30;  
    fwrite(fpga,randi(255,512*512,1));
%     fclose(instrfind)
    clc;
    fprintf('Receiving Fibonacci Sequence.....\n');
%     fclose(instrfind);
%     fopen(fpga);
    fpga.Timeout = 4;                  % Timeout period in seconds (10 for div by 4 else 30)
    im_received = fread(fpga);
    fclose(instrfind);
    clc;
    fprintf('Received Data.\n\n'); 
    pause(1);
    Memory_Index=[0:numel(im_received)-1]';
    Data = im_received(:);
    T=table(Memory_Index,Data);
    figure('NumberTitle', 'off', 'Name', 'Fibonacci Series')
    uitable('Data',T{:,:},'ColumnName',{' Memory Location ',' Data '},...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

%Factorial

elseif(indx==13)
    fprintf('Writing dummy data.....\n');
    fclose(instrfind);
    fopen(fpga);
    fpga.Timeout = 30;  
    fwrite(fpga,randi(255,512*512,1));
%     fclose(instrfind)
    clc;
    fprintf('Receiving Factorial Sequence.....\n');
%     fclose(instrfind);
%     fopen(fpga);
    fpga.Timeout = 4;                  % Timeout period in seconds (10 for div by 4 else 30)
    im_received = fread(fpga);
    fclose(instrfind);
    clc;
    fprintf('Received Data.\n\n'); 
    pause(1);
    Memory_Index=[0:numel(im_received)-1]';
    Data = im_received(:);
    T=table(Memory_Index,Data);
    figure('NumberTitle', 'off', 'Name', 'Factorial Series')
    uitable('Data',T{:,:},'ColumnName',{' Memory Location ',' Data '},...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);

end


