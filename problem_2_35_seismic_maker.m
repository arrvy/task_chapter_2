Fs = 15;
N = 6700;
t = (0:N-1)/Fs;
x =  0.6*sin(2*pi*0.1*t)+0.4*sin(2*pi*0.3*t)+ 0.15*randn(size(t));

save('synthetic_seismic.dat','x','-ascii');

%fid = fopen('synthetic_seismic.dat','w');
%fprintf(fid,'%f\n',x);
%fclose(fid);