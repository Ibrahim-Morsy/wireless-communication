%-----------------------------------------------------------------------------%
clc;
clear;
close all;
%-----------------------------------------------------------------------------%
tic

%% Parameters
N_Bits = 1e6;
Bits_per_Symbol = 2;
Symbol_Num_per_frame = 2;
Bits_Num_per_frame = Bits_per_Symbol * Symbol_Num_per_frame;
dmin=2;
Mt = 2;         % Transmitting Antennas
Mr = 6;         % Receiving Antennas
M = 4;          %Modulation Order
n = log2(M); % Number of bits per symbol
% number of frames in a MIMO system
System_Frames= n * N_Bits / Bits_Num_per_frame;
% Number of frames per each transmitted Antenna
Frames_per_one_Antenna = System_Frames / Mt;
% SNR IN dB (Free SNR )
SNR_dB =-15:2:15;
% Power Of Signal (Normalized)
Eb = (M-1)*(dmin^2)/(6*log2(M));
% Initialization
BER_Uncoded = zeros(1, length(SNR_dB));
BER_Precoded = zeros(1, length(SNR_dB));
BER_MMSE = zeros(1, length(SNR_dB));
BER_ZF = zeros(1, length(SNR_dB));
BER_ML = zeros(1, length(SNR_dB));
BER_MMSE_SIC = zeros(1, length(SNR_dB));
BER_ZF_SIC = zeros(1, length(SNR_dB));
Y_Precoded_FINAL = zeros(Mt, Frames_per_one_Antenna);
Complex_Symbols = [];
Channel = [];
K = 0; % 0--> for Rayleigh channel, else For LOS component -> Rician Fading Channel
i=1;
%-----------------------------------------------------------------------------%
for snr = SNR_dB
    snr
    % Snr Parameters
    SNR_Linear = 10^(snr/10);
    No = Eb / SNR_Linear;
    % Bits Generation
    Bits = randi([0 1],  N_Bits,1);
    % QPSK_Symbols Generation
    Complex_Symbols = QAM_MOD(Bits,M);
    % Symbol in each antenna
    Mt_symbols = Complex_Symbols(1:end);
    Mt_symbols = reshape(Mt_symbols, Mt, Frames_per_one_Antenna);
    
%-----------------------------------------------------------------------------%

%%==========================================%%
%%================     Transmitter    ===============%%
%%==========================================%%
%% Uncoded

%MIMO channel % rayleigh channel
 Channel= (randn(Mr,Mt,Frames_per_one_Antenna)+1i*randn(Mr,Mt,Frames_per_one_Antenna))/sqrt(2); 

Y=zeros(Mr,Frames_per_one_Antenna);
for L = 1:Frames_per_one_Antenna
Y(:,L)=Channel(:,:,L)*Mt_symbols(:,L);
end

% Noise Generation
Noise = sqrt(No/2)*(randn(size(Y) )+1i*randn(size(Y) ));

% transmitted data
Y=Y+Noise;

%% Precoded 
 
[Y_Precoded_final] = Precoded(Channel,Mt_symbols,No,Frames_per_one_Antenna,Mt,Mr);

%%==========================================%%
%%================       Receiver       ===============%%
%%==========================================%%

%% Precoded ::CSI is known
receivedBits_Precoded=QAM_DEMOD(Y_Precoded_final,M);


%% Uncoded ::CSI is unknown
Y_ML=zeros(Mt,Frames_per_one_Antenna);
Y_ZF=zeros(Mt,Frames_per_one_Antenna);
Y_ZF_SIC=zeros(Mt,Frames_per_one_Antenna);
Y_MMSE=zeros(Mt,Frames_per_one_Antenna);
Y_MMSE_SIC=zeros(Mt,Frames_per_one_Antenna);
for K=1:Frames_per_one_Antenna
channelPerTimeSlot=Channel(:,:,K);
Y_perTimeSlot=Y(:,K);
% Maximum Likelihood (ML)
Y_ML_perTimeSlot = ML_receiver(Y_perTimeSlot,channelPerTimeSlot,Frames_per_one_Antenna);
Y_ML(:,K)=Y_ML_perTimeSlot;

% Zero-Forcing (ZF)
[Y_ZF_perTimeSlot,Q_ZF] = ZF_receiver(Y_perTimeSlot,channelPerTimeSlot,Frames_per_one_Antenna);
Y_ZF(:,K)=Y_ZF_perTimeSlot;

% Minimum-Mean square error (MMSE)
alpha=Mt/(SNR_Linear*log2(M));   % parameter for MMSE function
[Y_MMSE_perTimeSlot,Q_MMSE]=MMSE_receiver(Y_perTimeSlot,channelPerTimeSlot,Mt,alpha);
Y_MMSE(:,K)=Y_MMSE_perTimeSlot;

% Minimum-Mean square error successive interference cancellation (MMSE-SIC)
Y_MMSE_SIC_perTimeSlot=MMSE_SIC_receiver(Y_perTimeSlot,channelPerTimeSlot,Q_MMSE,Mt,alpha,M);
Y_MMSE_SIC(:,K)=Y_MMSE_SIC_perTimeSlot;

end

%% Serial to parallel

%ML
Y_ML_Final=reshape(Y_ML,[],1);

%ZF
Y_ZF_Final=reshape(Y_ZF,[],1);

%MMSE
Y_MMSE_Final=reshape(Y_MMSE,[],1);

%MMSE-SIC
Y_MMSE_SIC_Final=reshape(Y_MMSE_SIC,[],1);


%% Demapping

%ML
receivedBits_ML=QAM_DEMOD(Y_ML_Final,M);
%ZF
receivedBits_ZF=QAM_DEMOD(Y_ZF_Final,M);
%MMSE
receivedBits_MMSE=QAM_DEMOD(Y_MMSE_Final,M);
%MMSE-SIC
receivedBits_MMSE_SIC=QAM_DEMOD(Y_MMSE_SIC_Final,M);


%% BER calc

%precoded 
Number_of_errors_Precoded=sum(Bits~=receivedBits_Precoded );
BER_Precoded(i)=Number_of_errors_Precoded/N_Bits;

%ML
Number_of_errors_ML=sum(Bits~=receivedBits_ML );
BER_ML(i)=Number_of_errors_ML/N_Bits;

%ZF
Number_of_errors_ZF=sum(Bits~=receivedBits_ZF );
BER_ZF(i)=Number_of_errors_ZF/N_Bits;

%MMSE
Number_of_errors_MMSE=sum(Bits~=receivedBits_MMSE );
BER_MMSE(i)=Number_of_errors_MMSE/N_Bits;

%MMSE-SIC
Number_of_errors_MMSE_SIC=sum(Bits~=receivedBits_MMSE_SIC );
BER_MMSE_SIC(i)=Number_of_errors_MMSE_SIC/N_Bits;

i=i+1;
end

figure;
semilogy(SNR_dB,BER_Precoded,'k-x', 'LineWidth', 1, 'DisplayName', 'precoded'); 
hold on
semilogy(SNR_dB,BER_ZF,'b-o', 'LineWidth', 1, 'DisplayName', 'Zero-forcing');
hold on
semilogy(SNR_dB,BER_MMSE,'g-o', 'LineWidth', 1, 'DisplayName','Minimum-Mean square error');
hold on
semilogy(SNR_dB,BER_MMSE_SIC,'c-o', 'LineWidth', 1, 'DisplayName','Minimum-Mean square error SIC');
hold on
semilogy(SNR_dB,BER_ML,'r-o', 'LineWidth', 1, 'DisplayName', 'Maximum-Liklihood');
legend('precoded', 'ZF','MMSE','MMSE-SIC','ML');
grid on;
title('MIMO Spatial Multiplexing for 2×6 Transmit & receive antennas ');
xlabel('EbNo (dB)','FontSize',2);
ylabel('Bit Error Rate (BER)','FontSize',2);
toc
