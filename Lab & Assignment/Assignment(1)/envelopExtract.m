function amplitude = envelopExtract(x)
% input    : time domain signal
% output   : envelop
% creates analytic signal z(t) from x(t)
% returns amplitude of analytic signal z(t)

z = hilbert(x);  
amplitude = abs(z);   % Envelope형성을 위한 크기(진폭) 추출

end
