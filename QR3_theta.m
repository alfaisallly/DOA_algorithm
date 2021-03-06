% function Ang = QR3_theta(n) 
Ang = [90];    % Angles of source

f = 8.68e8;     % Frequency
c = 299792458;  % Propagation velocity
wl = c/f;       % Wavelength
d = wl/2;       % Distance between antennas
M = 4;          % Number of elements
L = 1;          % Number of sources

sim('ULA_4ant_sim1', 0.1);      % Simulate 4x1 ULA signal

for t=1:180 
    theta(t) = t*(pi)/180;  % scanning angle in radians
    A(:,:,t) = zeros(M,L);
    
    for i=1:M
%     ULA(i) = i;
        for k=1:L
        u(k, i, t) = exp((-2*i*pi*d*cos(theta(t)))/wl);
        end             % Array response vectors
    end
    
    a(:,:,t) = circshift(u(:,:,t), 1,L);
    a(1:L,1, t) = 1;
    A(:,:,t) = a(:,:,t).';      % Array response matrix     
    
end

Ryy = cov(Sim);         % Estimate Covariance
[Q, R] = qr(Ryy);       % QR factorisation

Qs = Q(:,1:2);          % Signal sub-space
Qn = Q(:,3:4);          % Noise sub-space

QnH = Qn';              % Conjugate transpose of Qn

for t=1:180
    
    % DOA(t) = norm(QnH*A(:,:,t));
    DOA1(t) = 1/norm(QnH*A(:,:,t));     % peak of this function is DOA estimate.
%     AA = A(:,:,t);
%     TP2 = Qn*(A(:,:,t)');
end
 
fig = figure;
hax = axes;
hold on
plot(DOA1)
title('Direction of Arrival') 
xlabel('Angle (Degrees)')
ylabel('DOA amplitude')

SP = round(Ang, 0);
line([SP SP], get(hax,'YLim'),'Color',[1 0 0])

