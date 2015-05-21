% RWT Test

sampling_freq = 256;
pi            = asin(1)*2;

%NB:
%
% 0 - 4
% 4 - 8
% 8 - 16
% 16 - 32
% 32 - 64

ns=256;

f(1,:) = sin(2*pi*(2/256)*(1:ns));   %delta
f(2,:) = sin(2*pi*(6/256)*(1:ns));   %theta
f(3,:) = sin(2*pi*(12/256)*(1:ns));  %alpha
f(4,:) = sin(2*pi*(24/256)*(1:ns));  %beta
f(5,:) = sin(2*pi*(48/256)*(1:ns));  %gamma

y = sum(f);

subplot(2,2,1);
plot((0:ns-1),f(1,:)-4, 'r');
hold on
plot((0:ns-1),f(2,:)-2, 'r');
plot((0:ns-1),f(3,:), 'r');
plot((0:ns-1),f(4,:)+2, 'r');
plot((0:ns-1),f(5,:)+4, 'r');
hold off

subplot(2,2,2)
plot((0:ns-1),y, 'g');

h = daubcqf(8,'min');
[coeffs,L] = mdwt(y,h,5);

dwt_noise = [zeros(1,128) coeffs(129:256)];
dwt_gamma = [zeros(1,64)  coeffs(65:128) zeros(1,128)];
dwt_beta  = [zeros(1,32)  coeffs(33:64)  zeros(1,192)];
dwt_alpha = [zeros(1,16)  coeffs(17:32)  zeros(1,224)];
dwt_theta = [zeros(1,8)   coeffs(9:16)   zeros(1,240)];
dwt_delta = [coeffs(1:8)  zeros(1,248)];

[out_gamma, L] = midwt(dwt_gamma, h, 5);
[out_beta,  L] = midwt(dwt_beta, h, 5); 
[out_alpha, L] = midwt(dwt_alpha, h, 5); 
[out_theta, L] = midwt(dwt_theta, h, 5); 
[out_delta, L] = midwt(dwt_delta, h, 5);

subplot(2,2,3);
plot((0:ns-1),out_delta-4, 'r');
hold on
plot((0:ns-1),out_theta-2, 'r');
plot((0:ns-1),out_alpha, 'r');
plot((0:ns-1),out_beta+2, 'r');
plot((0:ns-1),out_gamma+4, 'r');
hold off

y_new = [out_delta + out_theta + out_alpha + out_beta + out_gamma];

subplot(2,2,4);
plot((0:ns-1),y_new,'g');

