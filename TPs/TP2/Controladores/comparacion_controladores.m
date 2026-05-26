clear; clc; close all;


fig1 = figure;


load('.\Propocional\impulso_v1.mat');
plot(t, posicion); hold on;

load('.\PI\impulso_PI_v1.mat');
plot(t, posicion); hold on;

load('.\PD\impulso_PD_v1.mat');
plot(t, posicion); legend('Proporcional', 'PI', 'PD');