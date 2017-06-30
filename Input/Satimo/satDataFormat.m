function [Data_FMT] = satDataFormat(Data_UnFMT)

% Retrieve nsi constant definitions
satConstant = satConstants();
corrflag=false;

% Create local alias for nsi constants
FF_nTH = satConstant.FF_nTH;
FF_dTH = satConstant.FF_dTH;
FF_nPHI = satConstant.FF_nPHI;
FF_dPHI = satConstant.FF_dPHI;

[UnFMTdim0 UnFMTdim1]=size(Data_UnFMT);

    Data_UnFMTshft=Data_UnFMT; % create an array same as the source, with the rows incremented by 1, first row zero padded
    Data_UnFMTshft(end,:)=zeros(1,4);
    Data_UnFMTshft=circshift(Data_UnFMTshft,1);
    
    data_split_MAT=Data_UnFMT-Data_UnFMTshft; %identifies points in array where freq/angle data CHANGES
    f_split_VEC=data_split_MAT(:,1);
    f_split_posVEC=find(f_split_VEC); %used to find non-zero elements within the argument vector/ array
    phi_split_VEC=data_split_MAT(:,2);
    phi_split_posVEC=find(phi_split_VEC); %used to find points where value of phi CHANGES in the array
    theta_split_VEC=data_split_MAT(:,3);
    [minvals,theta_split_posVAL]=min(theta_split_VEC);
    
    %here's where we re-org/ reshape the Satimo .CSV data files into
    %something useful:  a multi-dimensional array SAT_FF_MAT where the 3rd dimension
    %corresponds to frequency, the rows correspond to PHI values, and the
    %columns correspond to THETA values
    npts_ser_array=f_split_posVEC(2) -f_split_posVEC(1);    
    ncols_SAT_FF_MAT=theta_split_posVAL - 1;
    nrows_SAT_FF_MAT=npts_ser_array/ncols_SAT_FF_MAT;
    
    %pre-allocating arrays, to reduce execution time(?)
%     Data_FMT1=zeros(length(f_split_VEC)/length(f_split_posVEC),UnFMTdim1,length(f_split_posVEC));
%     SAT_FF_MAT=zeros(nrows_SAT_FF_MAT,ncols_SAT_FF_MAT,length(f_split_posVEC));
    
    for k=1:length(f_split_posVEC)
        Data_FMT1(:,:,k)=Data_UnFMT(1+npts_ser_array*(k-1):k*npts_ser_array,:);
        SAT_FF_MAT(:,:,k)=reshape(Data_FMT1(:,4,k), ncols_SAT_FF_MAT, nrows_SAT_FF_MAT).'; %transpose op point matrix in correct configuration


    end
    
    
    
    
    %This section handles the manner in which Satimo provides Azimuth information:  if the incremental
    %step angle in Azimuth is SAT_dPHI, than the last point documented in
    %the .TRX file is [pi - SAT_dPHI_rad], or [180 - SAT_dPHI_deg].. Satimo
    %does NOT measure data at the Phi=180 degree position...
%     if ne(rem(ncols_SAT_FF_MAT-1,nrows_SAT_FF_MAT-1),0)
%         SAT_FF_MAT(end+1,:,:)=SAT_FF_MAT(1,:,:);
%         nrows_SAT_FF_MAT=nrows_SAT_FF_MAT+1;
%         corrflag=true;
%     end
    
%here's some operations to create the phi and theta matrices compatible
% %with the MESHGRID operation
%     phi_SAT_MAT=reshape(Data_FMT1(:,2,1), ncols_SAT_FF_MAT, nrows_SAT_FF_MAT).'; %transpose op point matrix in correct configuration
%     phi_deg_SAT_MAT=phi_SAT_MAT * 180/pi;
%     theta_SAT_MAT=reshape(Data_FMT1(:,3,1), ncols_SAT_FF_MAT, nrows_SAT_FF_MAT).';
%     theta_deg_SAT_MAT=theta_SAT_MAT * 180/pi;
%     figure;surf(theta_deg_SAT_MAT, phi_deg_SAT_MAT, 20*log10(SAT_FF_MAT(:,:,1)));
%     figure;polar(linspace(0, 2*pi, 127),fftshift(20*log10(SAT_FF_MAT(1,:,1))- min(SAT_FF_MAT(1,:,1))));
%     figure;polar(linspace(0, 2*pi, 127),fftshift(20*log10(SAT_FF_MAT(1,:,1))));
    %these figures above only used to troubleshoot/ confirm the input of
    %data into MATLAB
    
    

    %now we try to manipulate the SAT_FF_MAT multi-D array into a format
    %which matches the data collected by the HOWLAND/ NSI chambers in GTU/
    %GTW
   
    %pre-allocating arrays, to reduce execution time(?)
INT_FF_MAT_LHsideP1=zeros(nrows_SAT_FF_MAT,ceil(ncols_SAT_FF_MAT/2),length(f_split_posVEC));
INT_FF_MAT_RHsideP1=zeros(nrows_SAT_FF_MAT,floor(ncols_SAT_FF_MAT/2),length(f_split_posVEC));
    
    
    
    for k=1:length(f_split_posVEC)
     
%         INT_FF_MAT_LHsideP1(:,:,k)=SAT_FF_MAT(:,(theta_split_posVAL/2):end,k);
%         INT_FF_MAT_RHsideP1(:,:,k)=SAT_FF_MAT(:,1:(theta_split_posVAL/2-1),k);
        INT_FF_MAT_LHsideP1(:,:,k)=SAT_FF_MAT(:,(theta_split_posVAL/2):end,k);
        INT_FF_MAT_RHsideP1(:,:,k)=SAT_FF_MAT(:,1:(theta_split_posVAL/2-1),k);

    end
    
    
    
INT_FF_MAT_RHsideP1(:,theta_split_posVAL/2,:)=INT_FF_MAT_LHsideP1(:,1,:);
%this line ensures that the values match at the THETA=0 point
    
  
%add a row of zeros to each matrix, to make it square and avoid indexing
%error.  The zeros don't show up in the final NH_FF_MAT_FMT1 matrix
INT_FF_MAT_LHsideP1(end+1,:,k)=zeros(1,length(INT_FF_MAT_LHsideP1(1,:,k)));
INT_FF_MAT_RHsideP1(end+1,:,k)=zeros(1,length(INT_FF_MAT_RHsideP1(1,:,k)));

    %pre-allocating arrays, to reduce execution time(?)
INT_FF_MAT_LHsideP2=zeros(ceil(ncols_SAT_FF_MAT/2),ceil(ncols_SAT_FF_MAT/2),length(f_split_posVEC));
INT_FF_MAT_RHsideP2=zeros(ceil(ncols_SAT_FF_MAT/2),ceil(ncols_SAT_FF_MAT/2),length(f_split_posVEC));
%     
NH_FF_MAT_FMT1=zeros(ceil(ncols_SAT_FF_MAT/2),2*ceil(ncols_SAT_FF_MAT/2) -1,length(f_split_posVEC));
%     
    
    
    for k=1:length(f_split_posVEC)
        
        INT_FF_MAT_LHsideP2(:,:,k)=INT_FF_MAT_LHsideP1(:,:,k).';
        INT_FF_MAT_RHsideP2(:,:,k)=(fliplr(INT_FF_MAT_RHsideP1(:,:,k))).';
        
        %this line ensures that the values match at the Phi=0 and Phi =360
        %degree points
        INT_FF_MAT_RHsideP2(:,theta_split_posVAL/2,:)=INT_FF_MAT_LHsideP2(:,1,:);
        
        
        NH_FF_MAT_FMT1(:,:,k)=[INT_FF_MAT_LHsideP2(:,1:(end-1),k) INT_FF_MAT_RHsideP2(:,:,k)];
            
    end
    
%     if (not(corrflag))
%         NH_FF_MAT_FMT1(:,theta_split_posVAL+1,:)=NH_FF_MAT_FMT1(:,1,:); % SK added 22Ap2011 to address wrap problem
%     end

% %     [phi_NH_MAT_FMT1,theta_NH_MAT_FMT1]=meshgrid(linspace(0,2*pi,theta_split_posVAL+1).',linspace(0,pi,theta_split_posVAL/2));
    [phi_NH_MAT_FMT1,theta_NH_MAT_FMT1]=meshgrid(linspace(0,2*pi,theta_split_posVAL-1).',linspace(0,pi,theta_split_posVAL/2));
    
    phi_deg_NH_MAT_FMT1=phi_NH_MAT_FMT1 * 180/pi;
    theta_deg_NH_MAT_FMT1=theta_NH_MAT_FMT1 * 180/pi;
%     figure;surf(phi_deg_NH_MAT_FMT1,theta_deg_NH_MAT_FMT1,NH_FF_MAT_FMT1(:,:,1));
%     figure;polar(linspace(0, 2*pi, 128),10.^(NH_FF_MAT_FMT1(32,:,1)./10));

%here's where we re-interpolate data onto a user defined spatial sampling
%array (in degrees)
    [phi_deg_NH_MAT_FMT2,theta_deg_NH_MAT_FMT2]=meshgrid(linspace(0,360,FF_nPHI).',linspace(0,180,FF_nTH));
   
    %pre-allocating arrays, to reduce execution time(?)
%     Data_FMT=zeros(FF_nTH, FF_nPHI, length(f_split_posVEC));
    
    
           
if not(eq(size(NH_FF_MAT_FMT1,1),FF_nTH) & eq(size(NH_FF_MAT_FMT1,2),FF_nPHI));

        for k=1:length(f_split_posVEC)
              
             Data_FMT(:,:,k)=interp2(phi_deg_NH_MAT_FMT1,theta_deg_NH_MAT_FMT1, ...
               NH_FF_MAT_FMT1(:,:,k),phi_deg_NH_MAT_FMT2,theta_deg_NH_MAT_FMT2);
    
        end
    
else
    
        Data_FMT=NH_FF_MAT_FMT1;
    
end

end


    