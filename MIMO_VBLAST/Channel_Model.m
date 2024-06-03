
function channel = Channel_Model (K ,Mr,Mt )
%Reyleigh Channel
if K == 0 
    channel= (randn(Mr,Mt)+1i*randn(Mr,Mt))/sqrt(2);
    
else 
% Rician channel
    channel= (sqrt(K/K+1)+sqrt(1/(K+1)*2)).*(randn(Mr,Mt)+1i*randn(Mr,Mt));


end 