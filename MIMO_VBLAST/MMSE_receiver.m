function [Y_MMSE_perTimeSlot,Q_MMSE] = MMSE_receiver(Y_perTimeSlot,channelPerTimeSlot,Mt,alpha)

H=channelPerTimeSlot;
I=eye(Mt);

Q_MMSE=(H'*H+(alpha)*I)\H';


Y_MMSE_perTimeSlot=Q_MMSE*Y_perTimeSlot;


end

