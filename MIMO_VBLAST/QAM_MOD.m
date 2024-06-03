function [Modulated_data] = QAM_MOD(bits,M)

Nbps=log2(M);
% reshape bits
reshapedBits=reshape(bits,Nbps,[])';
switch Nbps
    %% BPSK
    case 1
    Modulated_data=reshapedBits*2-1;
    %% QPSK
    case 2
    Tx_real=reshapedBits(:,1)*2-1 ;
    Tx_imag=reshapedBits(:,2)*2-1 ;
    Modulated_data=(Tx_real+1i*Tx_imag);
    %% 16QAM
    case 4
    mapping = [-3; -1; 3; 1];

    Tx_real=mapping(binaryVectorToDecimal(reshapedBits(:,1:2))+1);
    Tx_imag=mapping(binaryVectorToDecimal(reshapedBits(:,3:4))+1 );
    Modulated_data=(Tx_real+1i*Tx_imag);
    %% 64QAM
    case 6
    mapping = [-7;-5;-1; -3; 7; 5;1;3];
    Tx_real=mapping(binaryVectorToDecimal(reshapedBits(:,1:3))+1);
    Tx_imag=mapping(binaryVectorToDecimal(reshapedBits(:,4:6))+1 );
    Modulated_data=(Tx_real+1i*Tx_imag);
end






end

