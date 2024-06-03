function [Y_ZF_SIC_perTimeSlot] =ZF_SIC_receiver(Y_perTimeSlot,channelPerTimeSlot,Q_ZF,Mt,M)

Y_ZF_SIC_perTimeSlot=zeros(Mt,1);

for i = 1:Mt
X_hat=Q_ZF*Y_perTimeSlot;

[strongest idx]=max(X_hat);

bits=QAM_DEMOD(strongest , M);
modu=QAM_MOD(bits,M);

Y_hat=Y_perTimeSlot-channelPerTimeSlot(:,idx)*modu;

%% filter channel and QZF
channelPerTimeSlot(:,idx)=0;
Q_ZF(idx,:)=0;

%% update current Q_ZF and Y_perTimeSlot
Y_perTimeSlot=Y_hat;

%% output
Y_ZF_SIC_perTimeSlot(idx)=modu;
end

end

