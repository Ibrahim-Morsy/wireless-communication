function [Y_ML_perTimeSlot] = ML_receiver(Y_perTimeSlot,channelPerTimeSlot,Frames_per_one_Antenna)

X = [[1+1i 1+1i]; [1+1i 1-1i]; [1+1i -1+1i]; [1+1i -1-1i];
    [1-1i 1+1i]; [1-1i 1-1i]; [1-1i -1+1i]; [1-1i -1-1i];
    [-1+1i 1+1i]; [-1+1i 1-1i]; [-1+1i -1+1i]; [-1+1i -1-1i];
    [-1-1i 1+1i]; [-1-1i 1-1i]; [-1-1i -1+1i]; [-1-1i -1-1i] ].';


HX=channelPerTimeSlot*X;
out_=zeros(1,16);
OUTPUT=Y_perTimeSlot-HX;
for i =1:16
out_(i)=norm(OUTPUT(:,i));
end
[~,index]=min(out_);
Y_ML_perTimeSlot=X(:,index);

end

