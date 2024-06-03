function [Demodulated_data] = QAM_DEMOD(Received_Data,M)

Nbps=log2(M);   %% number of bits per symbol

%% function parameters
% Kmod , Threshold & output
switch Nbps
    case 1
        % set inphase component
        I=real(Received_Data);
        % apply threshold
        I(I>0)=1;
        I(I<0)=0;
        % assign to Rx
        Demodulated_data=I;
    case 2
        % set inphase and quadrature components
        I=real(Received_Data);
        Q=imag(Received_Data);
        % apply threshold for both components
        I(I>0)=1;
        I(I<0)=0;
        
        Q(Q>0)=1;
        Q(Q<0)=0;
        % assign to Rx
        Rx=[I Q];
        % demodulated data
        Demodulated_data=reshape(Rx',length(Received_Data)*Nbps,1);
        
    case 4
        % set inphase and quadrature components
        I=real(Received_Data);
        Q=imag(Received_Data);
        % apply threshold for both components
        I(I>2        )=2;
        I(I<2 & I>0 )=3;
        I(I<0 & I>-2)=1;
        I(I<-2       )=0;
        
        Q(Q>2        )=2;
        Q(Q<2 & Q>0 )=3;
        Q(Q<0 & Q>-2)=1;
        Q(Q<-2       )=0;
        % assign to Rx
        Rx=[decimalToBinaryVector(I,Nbps/2),decimalToBinaryVector(Q,Nbps/2)];
        % demodulated data
        Demodulated_data=reshape(Rx',length(Received_Data)*Nbps,1);
    case 6
        % set inphase and quadrature components
        I=real(Received_Data);
        Q=imag(Received_Data);
        % apply threshold for both components
        I(I>6          )=4;
        I(I<6  & I>4  )=5;
        I(I<4  & I>2  )=7;
        I(I<2  & I>0  )=6;
        I(I<0  & I>-2 )=2;
        I(I<-2 & I>-4 )=3;
        I(I<-4 & I>-6 )=1;
        I(I<-6         )=0;
        
        Q(Q>6          )=4;
        Q(Q<6  & Q>4  )=5;
        Q(Q<4  & Q>2  )=7;
        Q(Q<2  & Q>0  )=6;
        Q(Q<0  & Q>-2 )=2;
        Q(Q<-2 & Q>-4 )=3;
        Q(Q<-4 & Q>-6 )=1;
        Q(Q<-6         )=0;
        % assign to Rx
        Rx=[decimalToBinaryVector(I,Nbps/2),decimalToBinaryVector(Q,Nbps/2)];
        % demodulated data
        Demodulated_data=reshape(Rx',length(Received_Data)*Nbps,1);
end
end