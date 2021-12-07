function run_example_ode()
% Example for the fast interpolation method with an ODE integration.
%
%    The response of a low-pass filter is considered.
%    The input signal is computed with the interpolation method.
%
%    Thomas Guillod.
%    2021 - BSD License.

%% input signal

% input voltage
t_vec = linspace(0, 1, 500);
u_vec = 1.0+0.5.*sin(2.*pi.*10.*t_vec);

% low-pass time constant and initial value
tau = 0.1;
y_init = 0;

% ode integration tolerance
options = odeset('RelTol',1e-6, 'MaxStep', 1e-2);

%% solve the ODE

% get the ode
fct = @(t, y) get_ode(t, y, tau, t_vec, u_vec);

% call the solver
[t_vec, y_vec] = ode45(fct, t_vec, y_init, options);

%% plot

% init
figure()
hold('on')
grid('on')

% plot output signal
plot(t_vec, y_vec, 'r')

% plot input signal
plot(t_vec, u_vec, 'b')

end

function dydt = get_ode(t, y, tau, t_vec, u_vec)

% persistent variable tracking the index of the last query point
persistent idx;

% initialize to an unknow index
if isempty(idx)
    idx = NaN;
end

% get the input signal
[u, idx] = interp_fast(t_vec, u_vec, t, idx);

% get the ODE
dydt = (u-y)./tau;

end
