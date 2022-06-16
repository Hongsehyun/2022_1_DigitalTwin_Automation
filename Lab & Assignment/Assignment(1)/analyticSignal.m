% construct analytic signal
function z = analyticSignal(x)

% x is a real-valued record of length N, where N is even %returns the analytic signal z[n]
x = x(:);     %serialize
N = length(x); 

% FFT of x
X = fft(x);

% Create P[m]=Z[m]  from m=1 to N
P = [ X(1) ; 2*X(2:N/2) ; X(N/2+1) ; zeros(N/2-1,1) ];

% Create z(t)=Zr+j(Zi) from ifft(P)
z = ifft(P,N);

% Envelope extraction
% inst_amplitude = abs(z);

end