% Cargar archivos de audio
% -> x1 = bater�a
% -> x2 = bajo
% -> x3 = armon�a
fs = 44100; 
[x1, fs] = audioread('beat.wav');
[x2, fs] = audioread('bass.wav');
[x3, fs] = audioread('harmony.wav');

% Canales L y F de cada se�al
L_x1 = x1(:, 1);
R_x1 = x1(:, 2);

L_x2 = x2(:, 1);
R_x2 = x2(:, 2);

L_x3 = x3(:, 1);
R_x3 = x3(:, 2);

% Multiplicar valor de frecuencia de muestreo
sound(x1, fs);
sound(x1, 0.5*fs);
sound(x1, 0.75*fs);
sound(x1, 1.5*fs);
sound(x1, 2*fs);

%% Mixer 2 se�ales
% Sumamos ambas se�ales y las normalizamos en un rango de -1 a 1
% Determinamos si ambas se�alas sonar�n a la misma intensidad o si una
% se�al se escuchar� m�s que otra
a = 2; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo

% a*x1 + b*x2 -> cada se�al ser� multiplicada por un factor al momento de
% sumarlas

x_mix = normalize((a*x1 + b*x2), 'range', [-1 1]); 
L_xmix = x_mix(:, 1);
R_xmix = x_mix(:, 2);

% Escuchamos cada una por separado
sound(x1, fs);
sound(x2, fs);

% Escuchamos el mix
sound(x_mix, fs);

% Gr�fica audio Beat
figure(1);
sgtitle('Beat');
subplot(2,1,1);
plot(L_x1, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Beat');
xlabel('Time');

subplot(2,1,2);
plot(R_x1, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Beat');
xlabel('Time');

% Gr�fica audio Bass
figure(2);
sgtitle('Bass');
subplot(2,1,1);
plot(L_x2, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_x2, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Bass');
xlabel('Time');

% Gr�fica Mixer
figure(3);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Mixer');
xlabel('Time');

%% Mixer 3 se�ales
% Tama�os de las se�ales
N1 = length(x1);
N2 = length(x2);
N = length(x3);

% Arrays para almacenar la extensi�n peri�dica de x1[n] y x2[n]
y1 = zeros(N,2);
y2 = zeros(N,2);

% Periodizamos las se�ales
for n = 0:(N-1)
    y1(n+1, :) = x1(mod(n+1,N));
    y2(n+1, :) = x2(mod(n+1,N));
end

% Canales L y F de cada se�al
L_y1 = y1(:, 1);
R_y1 = y1(:, 2);

L_y2 = y2(:, 1);
R_y2 = y2(:, 2);

a = 1; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo
c = 2; % Factor de intensidad para armon�a

% a*x1 + b*x2 -> cada se�al ser� multiplicada por un factor al momento de
% sumarlas

x_mix = normalize((a*y1 + b*y2 + c*x3), 'range', [-1 1]); 
L_xmix = x_mix(:, 1);
R_xmix = x_mix(:, 2);

% Escuchamos cada una por separado
sound(y1, fs);
sound(y2, fs);
sound(x3, fs);

% Escuchamos el mix
sound(x_mix, fs);

% Gr�fica audio Beat
figure(4);
sgtitle('Beat');
subplot(2,1,1);
plot(L_y1, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Beat');
xlabel('Time');

subplot(2,1,2);
plot(R_y1, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Beat');
xlabel('Time');

% Gr�fica audio Bass
figure(5);
sgtitle('Bass');
subplot(2,1,1);
plot(L_y2, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_y2, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Bass');
xlabel('Time');

% Gr�fica audio armon�a
figure(6);
sgtitle('Armon�a');
subplot(2,1,1);
plot(L_x3, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_x3, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Bass');
xlabel('Time');

% Gr�fica Mixer
figure(7);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Mixer');
xlabel('Time');

%% Fade in
% Se genera una se�al rampa que cambie desde 0 hasta 1, con la misma 
% longitud que la pista de armon�a.
t = (0 : 1/(N-1) : 1);
rampa = [t(:), t(:)];

% Implementar el fade-in como la multiplicaci�n de la se�al rampa con la
% pista de armon�a.
y3 = x3.*rampa;
sound(y3, fs);

L_y3 = y3(:, 1);
R_y3 = y3(:, 2);

a = 1; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo
c = 1; % Factor de intensidad para armon�a

% a*x1 + b*x2 -> cada se�al ser� multiplicada por un factor al momento de
% sumarlas

en_fade_in = true; % Seleccionar si se desea o no el efecto de fade-in.

% Implementar el mixer digital que combine la pista de armon�a con las
% extensiones peri�dicas de las pistas de bater�a y bajo.
if(en_fade_in)
    x_mix = normalize((a*y1 + b*y2 + c*y3), 'range', [-1 1]); 
else
    x_mix = normalize((a*y1 + b*y2 + c*x3), 'range', [-1 1]);
end

L_xmix = x_mix(:, 1);
R_xmix = x_mix(:, 2);

% Probar si los resultados son los esperados
sound(x_mix, fs);

% Gr�fica Fade in
figure(6);
sgtitle('Fade In');
subplot(2,1,1);
plot(L_y3, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Armonia');
xlabel('Time');

subplot(2,1,2);
plot(R_y3, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Armonia');
xlabel('Time');

figure(7);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gr�fica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gr�fica
title('Right Channel Mixer');
xlabel('Time');