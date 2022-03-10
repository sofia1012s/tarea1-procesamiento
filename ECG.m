% Cargar Señales
load('ecg_data.mat')

%% Comparando señales
figure(1);
subplot(2,1,1);
plot(ecg);
title('Señal sin ruido');
subplot(2,1,2);
plot(ecg_noisy);
title('Señal con ruido');

%% Sacando FFT ambas señales para comparar
N_ecg = length(ecg);
N_ecg_noisy = length(ecg_noisy);
fft_ecg = fft(ecg, N_ecg);
fft_ecg_noisy = fft(ecg_noisy, N_ecg_noisy);
k = 0:N_ecg-1;

% Frecuencias armónicas
dw = 2*pi/N_ecg; 
w = k*dw; 
f = (w / (2*pi));

% Magnitudes
magnitud_ecg = abs(fft_ecg);
magnitud_ecg_noisy = abs(fft_ecg_noisy);

% Graficando
figure(2);

% Señal original
subplot(2,1,1);
stem(f, magnitud_ecg);
title('Magnitud fft señal original')
grid minor;
ylabel('$\left|X[k]\right|$', 'FontSize', 14, 'interpreter', 'latex');
xlabel('Frecuencia Hz');

% Señal con ruido
subplot(2,1,2);
stem(f, magnitud_ecg_noisy);
title('Magnitud fft señal con ruido')
grid minor;
ylabel('$\left|X[k]\right|$', 'FontSize', 14, 'interpreter', 'latex');
xlabel('Frecuencia Hz');
 
% Con ayuda de las gráficas del espectro en frecuencia y magnitud, se
% observa que, al comparar el espectro de la señal sin ruido con la señal
% con ruido, se observan pequeños picos en las frecuencias de 0.2 y 0.8 Hz
% de magnitudes aproximadas entre 8*10^4 y 10*10^4. Por lo que, se colocará
% un umbral para eliminar estos puntos encontrados entre esas magnitudes
% (asumiendo que se trata del ruido de la señal) para obtener la señal
% limpia. 

% Se utiliza un operador lógico 
umbral = (magnitud_ecg_noisy <(8*10^4)) | (magnitud_ecg_noisy > (10*10^4));

% Se convierte este operador lógico a números para multiplicarlo con la
% señal con ruido. Todos los puntos multiplicados por 0 (cuando no se
% cumpla lo planteado en la operación lógica) se eliminarán en la DFT. 
B = double(umbral);
sin_ruido = B.*fft_ecg_noisy;

% Aplicamos la inversa de la DFT para regresar a la señal obtenida
inversa = ifft(sin_ruido);

% Graficamos para comprobar el procedimiento
figure(3);
subplot(2,1,1);
plot(ecg_noisy);
title('Señal con ruido');
subplot(2,1,2);
plot(inversa);
title('Señal sin ruido');

% Graficamos señal obtenida con la señal sin ruido proporcionada
figure(4);
subplot(2,1,1);
plot(ecg);
title('Señal sin ruido original');
subplot(2,1,2);
plot(inversa);
title('Señal sin ruido por medio de DFT');

% Observamos que ambas gráficas son muy similares, por lo que el ruido se
% ha quitado exitosamente