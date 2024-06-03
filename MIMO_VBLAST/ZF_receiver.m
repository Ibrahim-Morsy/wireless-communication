function [Y_ZF_perTimeSlot,Q_ZF] = ZF_receiver(Y_perTimeSlot,channelPerTimeSlot,Frames_per_one_Antenna)


H=channelPerTimeSlot;

Q_ZF=pinv(H);
Y_ZF_perTimeSlot=Q_ZF*Y_perTimeSlot;

end

