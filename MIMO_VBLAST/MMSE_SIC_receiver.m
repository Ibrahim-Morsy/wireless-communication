function [Y_MMSE_SIC_perTimeSlot] = MMSE_SIC_receiver(Y_perTimeSlot,channelPerTimeSlot,Q_MMSE,Mt,alpha,M)

Y_MMSE_SIC_perTimeSlot=zeros(  Mt ,1);

X_hat=Q_MMSE*Y_perTimeSlot;

[strongest idx]=max(X_hat);
bits=QAM_DEMOD(strongest , M);
modu=QAM_MOD(bits,M);
Y_hat=Y_perTimeSlot-channelPerTimeSlot(:,idx)*modu;

Y_MMSE_SIC_perTimeSlot(idx)=modu;

channelPerTimeSlot(:,idx)=[];

Q_MMSE_hat=(channelPerTimeSlot'*channelPerTimeSlot+(alpha))\channelPerTimeSlot';

X_hat2=Q_MMSE_hat*Y_hat;


Y_MMSE_SIC_perTimeSlot(Y_MMSE_SIC_perTimeSlot==0)=X_hat2;


end

