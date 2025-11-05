#include <stdio.h>

// DC motor parametreleri
#define R 1.0
#define L 0.5
#define Kt 0.01
#define Kb 0.01
#define J 0.01
#define B 0.001

// DC motor diferansiyel denklemleri
void motor_derivatives(double x[2], double u, double dx[2], double TL)
{
    double i = x[0];
    double w = x[1];
    dx[0] = (-R * i - Kb * w + u) / L;  // di/dt
    dx[1] = (-B * w + Kt * i - TL) / J; // dw/dt
}

// RK4 adımı
void rk4_step(double x[2], double u, double dt, double TL)
{
    double k1[2], k2[2], k3[2], k4[2], xtemp[2];
    int j;

    motor_derivatives(x, u, k1, TL);

    for (j = 0; j < 2; j++)
        xtemp[j] = x[j] + 0.5 * dt * k1[j];
    motor_derivatives(xtemp, u, k2, TL);

    for (j = 0; j < 2; j++)
        xtemp[j] = x[j] + 0.5 * dt * k2[j];
    motor_derivatives(xtemp, u, k3, TL);

    for (j = 0; j < 2; j++)
        xtemp[j] = x[j] + dt * k3[j];
    motor_derivatives(xtemp, u, k4, TL);

    for (j = 0; j < 2; j++)
        x[j] += (dt / 6.0) * (k1[j] + 2 * k2[j] + 2 * k3[j] + k4[j]);
}