clear;clc;close all;
%% Q1
% define H and V that are correspondent to the polyhedron for H and v representation. Plot the polyhedron and
% explain the difference in the report.

% mpt_demo_sets1
% mpt_demo2

A = [0 1; -1 0; -1 -1; 1 1];
b = [0; 0; 1; 1];

P1 = Polyhedron('A',A,'b',b);
P1.computeVRep

H = P1.H
V = P1.V

P1.plot



%% Q2
% define Q and P, find the sum and the difference and plot the results.
% Sketch the plots in the report as well

A1 = [0 1; 1 0; 0 -1; -1 0];
b1 = [2;2;2;2];
A2 = [-1 -1; 1 1; 1 -1; -1 1];
b2 = [1;1;1;1];

P = Polyhedron('A',A1,'b',b1)
Q = Polyhedron('A',A2,'b',b2)

PpQ = plus(P,Q)
PmQ = minus(P,Q)

figure
subplot(2,2,1)
plot(P)
subplot(2,2,2)
plot(Q)
subplot(2,2,3)
plot(PpQ)
subplot(2,2,4)
plot(PmQ)

figure
plot(P,'alpha',0.2,Q,'alpha',0.2,PpQ,'alpha',0.2,PmQ,'alpha',0.2)


%% Q3
% write a code that shows S is invariant and explain your approach in the
% report

A = [0.8 0.4; -0.4 0.8];

Ain = [1 0; 0 1; -1 0; 0 -1; 1 1; 1 -1; -1 1; -1 -1];
bin = [1 1 1 1 1.5 1.5 1.5 1.5]';
P = Polyhedron('A',Ain,'b',bin);


figure
plot(P,'alpha',0.2);
hold on;
for i=1:100
    P_R = Polyhedron('A',Ain*inv(A)^i,'b',bin);
    plot(P_R,'alpha',0.2);
end
axis equal


% for i=1:1000
%     x = zeros(2,20);
%     x(:,1) = P.randomPoint;
%     for i=2:size(x,2)
%         x(:,i) = A*x(:,i-1);
%     end
%     plot(x(1,:),x(2,:))
% end



%% Q4
% Fill in the Reach_XX function and Plot S and its one step reachable set.
% Note that you are not supposed to change the inputs and outputs of the
% function.

A = [0.8 0.4; -0.4 0.8];
B = [0;1];

Ain = [1 0; 0 1; -1 0; 0 -1; 1 1; 1 -1; -1 1; -1 -1];
bin = [1 1 1 1 1.5 1.5 1.5 1.5]';
P = Polyhedron('A',Ain,'b',bin);

U = Polyhedron('lb',-1,'ub',1);

R = Reach_09(A,B,P,U);

plot(P,'alpha',0.5,R,'alpha',0.5)
axis equal


%% Q5
% Fill in the Pre_XX function and Plot S and its Pre set.
% Note that you are not supposed to change the inputs and outputs of the
% function.

A = [0.8 0.4; -0.4 0.8];
B = [0;1];

Ain = [1 0; 0 1; -1 0; 0 -1; 1 1; 1 -1; -1 1; -1 -1];
bin = [1 1 1 1 1.5 1.5 1.5 1.5]';
P = Polyhedron('A',Ain,'b',bin);

U = Polyhedron('lb',-1,'ub',1);

R = Pre_09(A,B,P,U);

plot(P,'alpha',0.5,R,'alpha',0.5)
axis equal


%% Q6
% part 1: Fill in the function ShorterstN_XX.m and use it to find the shortest N
% that is feasible. Note that you are not supposed to change the inputs and outputs of the
% function.

A = [0.9 0.4 ; -0.4 0.9];
B = [0;1];
Pf = zeros(2);
Q = eye(2);
R=1;
x0 = [2;0];

x_ub = [3;3];
u_ub = 0.1;


for N=1:100
    [Z,exitflag] = ShortestN_09(A,B,N,Q,R,Pf,x_ub,u_ub,x0);
    if exitflag==1
        break;
    end
end
N



% part 2: Fill in the function RHCXf_XX.m and use it to check the
% feasibility. Note that you are not supposed to change the inputs and outputs of the
% function.

model = LTISystem('A', A, 'B', B);
model.x.min = -x_ub;
model.x.max = x_ub;
model.u.min = -u_ub;
model.u.max = u_ub;
Xf2 = model.invariantSet;
% plot(Xf)

N=2;
[Z,exitflag] = RHCXf_09(A,B,N,Q,R,Pf,x_ub,u_ub,Xf2,x0)


% part 3: Plot the feasible sets for the initial condition in part 1 and 2
% and plot those sets. Answer to the rest of the question in the report. 


Xf1 = Polyhedron( 'Ae', eye(2), 'be', [0;0]);
U = Polyhedron( 'lb', -u_ub, 'ub', u_ub);

XN1 = model.reachableSet('X',Xf1,'U',U,'N',26,'direction','backward')
XN2 = model.reachableSet('X',Xf2,'U',U,'N',2,'direction','backward')

plot(XN1,'color','black','alpha',0.5,XN2,'color','red','alpha',0.5)
axis equal





% model = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5]);
% model.x.min = [-5; -5];
% model.x.max = [5; 5];
% model.u.min = -1;
% model.u.max = 1;
% Q = [1 0; 0 1];
% model.x.penalty = QuadFunction(Q);
% R = 1;
% model.u.penalty = QuadFunction(R);
% N = 5;
% mpc = MPCController(model, N)
% 
% % x0 = [4; 0];
% % u = mpc.evaluate(x0)
% % [u, feasible, openloop] = mpc.evaluate(x0)
% 
% 
% 
% InvSet = model.invariantSet()
% InvSet.plot()





