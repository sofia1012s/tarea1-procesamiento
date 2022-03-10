% Cargar archivos de audio
% -> x1 = batería
% -> x2 = bajo
% -> x3 = armonía
fs = 44100; 
[x1, fs] = audioread('beat.wav');
[x2, fs] = audioread('bass.wav');
[x3, fs] = audioread('harmony.wav');

% Canales L y F de cada señal
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

%% Mixer 2 señales
% Sumamos ambas señales y las normalizamos en un rango de -1 a 1
% Determinamos si ambas señalas sonarán a la misma intensidad o si una
% señal se escuchará más que otra
a = 2; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo

% a*x1 + b*x2 -> cada señal será multiplicada por un factor al momento de
% sumarlas

x_mix = normalize((a*x1 + b*x2), 'range', [-1 1]); 
L_xmix = x_mix(:, 1);
R_xmix = x_mix(:, 2);

% Escuchamos cada una por separado
sound(x1, fs);
sound(x2, fs);

% Escuchamos el mix
sound(x_mix, fs);

% Gráfica audio Beat
figure(1);
sgtitle('Beat');
subplot(2,1,1);
plot(L_x1, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Beat');
xlabel('Time');

subplot(2,1,2);
plot(R_x1, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Beat');
xlabel('Time');

% Gráfica audio Bass
figure(2);
sgtitle('Bass');
subplot(2,1,1);
plot(L_x2, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_x2, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Bass');
xlabel('Time');

% Gráfica Mixer
figure(3);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Mixer');
xlabel('Time');

%% Mixer 3 señales
% Tamaños de las señales
N1 = length(x1);
N2 = length(x2);
N = length(x3);

% Arrays para almacenar la extensión periódica de x1[n] y x2[n]
y1 = zeros(N,2);
y2 = zeros(N,2);

% Periodizamos las señales
for n = 0:(N-1)
    y1(n+1, :) = x1(mod(n+1,N));
    y2(n+1, :) = x2(mod(n+1,N));
end

% Canales L y F de cada señal
L_y1 = y1(:, 1);
R_y1 = y1(:, 2);

L_y2 = y2(:, 1);
R_y2 = y2(:, 2);

a = 1; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo
c = 2; % Factor de intensidad para armonía

% a*x1 + b*x2 -> cada señal será multiplicada por un factor al momento de
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

% Gráfica audio Beat
figure(4);
sgtitle('Beat');
subplot(2,1,1);
plot(L_y1, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Beat');
xlabel('Time');

subplot(2,1,2);
plot(R_y1, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Beat');
xlabel('Time');

% Gráfica audio Bass
figure(5);
sgtitle('Bass');
subplot(2,1,1);
plot(L_y2, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_y2, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Bass');
xlabel('Time');

% Gráfica audio armonía
figure(6);
sgtitle('Armonía');
subplot(2,1,1);
plot(L_x3, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Bass');
xlabel('Time');

subplot(2,1,2);
plot(R_x3, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Bass');
xlabel('Time');

% Gráfica Mixer
figure(7);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Mixer');
xlabel('Time');

%% Fade in
% Se genera una señal rampa que cambie desde 0 hasta 1, con la misma 
% longitud que la pista de armonía.
t = (0 : 1/(N-1) : 1);
rampa = [t(:), t(:)];

% Implementar el fade-in como la multiplicación de la señal rampa con la
% pista de armonía.
y3 = x3.*rampa;
sound(y3, fs);

L_y3 = y3(:, 1);
R_y3 = y3(:, 2);

a = 1; % Factor de intensidad para beat
b = 1; % Factor de intensidad para bajo
c = 1; % Factor de intensidad para armonía

% a*x1 + b*x2 -> cada señal será multiplicada por un factor al momento de
% sumarlas

en_fade_in = true; % Seleccionar si se desea o no el efecto de fade-in.

% Implementar el mixer digital que combine la pista de armonía con las
% extensiones periódicas de las pistas de batería y bajo.
if(en_fade_in)
    x_mix = normalize((a*y1 + b*y2 + c*y3), 'range', [-1 1]); 
else
    x_mix = normalize((a*y1 + b*y2 + c*x3), 'range', [-1 1]);
end

L_xmix = x_mix(:, 1);
R_xmix = x_mix(:, 2);

% Probar si los resultados son los esperados
sound(x_mix, fs);

% Gráfica Fade in
figure(6);
sgtitle('Fade In');
subplot(2,1,1);
plot(L_y3, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Armonia');
xlabel('Time');

subplot(2,1,2);
plot(R_y3, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Armonia');
xlabel('Time');

figure(7);
sgtitle('Mixer');
subplot(2,1,1);
plot(L_xmix, 'black'); % Grafico las 3 funciones en esta sub gráfica
title('Left Channel Mixer');
xlabel('Time');

subplot(2,1,2);
plot(R_xmix, 'red'); % Grafico las 3 funciones en esta sub gráfica
title('Right Channel Mixer');
xlabel('Time');