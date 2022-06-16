function psdx=getPSD(x,L,Fs)

Y = fft(x,L);
P2 = abs(Y);                         % Not normalized by L as fft
psdx = (1/(Fs*L))*(P2(1:L/2+1).^2);  % Power normalized by L and Fs
psdx(2:end-1) = 2*psdx(2:end-1);
f = 0 : Fs/L : Fs/2;

figure
plot(f,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

end