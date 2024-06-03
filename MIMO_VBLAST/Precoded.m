function [Y_Precoded_final_1] = Precoded(Full_channel,Mt_symbols,No,Frames_per_one_Antenna,Mt,Mr)
Y_Precoded_final=zeros(Mt,Frames_per_one_Antenna);
for L = 1:Frames_per_one_Antenna
        Channel = Full_channel(:,:,L);
        [U, S, V] = svd(Channel);
        % Precoded symbols
        precoded_symbols = V * Mt_symbols(:, L);
        % Calculating U Hermitian
        U_H = U';
        % Channel Multiplication
        Transmitted_Data = Channel * precoded_symbols;
        % Noise Generation
        Noise = sqrt(No/2)*(randn(Mr,1)+1i*randn(Mr,1));
        % adding noise to transmitted Data
        Y_Precoded = Transmitted_Data+Noise;

       %% Precoded Receiver
        % Removing the effect of precoding
            Y_hat=U_H*Y_Precoded;
            % calculate S inverse
            S_inverse=pinv(S);
            % Final data before demodulation
            Y_1=S_inverse*Y_hat;
            Y_Precoded_final(:,L)=Y_1;
    end

%%reshape data before modulation
Y_Precoded_final_1=reshape(Y_Precoded_final,[],1);

end

