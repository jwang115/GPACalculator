clc; clear;


% Constants
a=3;                            % 3 hours per credit
cred=[4; 3; 4; 4; 4];           % credit
%e=[0.9; 0.6; 1; 1; 0.2];        % unitless for course
e=[1; 1; 1; 1; 1];        % unitless for course
r=[0.3; 1; 0.3; 0.3; 1.5];      % rates

% Constants for classes (in hours)
c_MATH=a*cred(1)*e(1);
c_BEE=a*cred(2)*e(2);
c_CS4620=a*cred(3)*e(3);
c_CS4775=a*cred(4)*e(4);
c_MUSIC2101=a*cred(5)*e(5);
t=c_MATH+c_BEE+c_CS4620+c_CS4775+c_MUSIC2101;

% GPA of class (sets a cap to be 4.0 and no less than 1)
MATH3610_co=1.0+r(1)*c_MATH;
BEE3310_co=1.0+r(2)*c_BEE;
CS4620_co=1.0+r(3)*c_CS4620;
CS4775_co=1.0+r(4)*c_CS4775;
MUSIC2101_co=1.0+r(5)*c_MUSIC2101;

MATH3610_co=boundchecker(MATH3610_co);
BEE3310_co=boundchecker(BEE3310_co);
CS4620_co=boundchecker(CS4620_co);
CS4775_co=boundchecker(CS4775_co);
MUSIC2101_co=boundchecker(MUSIC2101_co);

MATH3610=MATH3610_co*cred(1);
BEE3310=BEE3310_co*cred(2);
CS4620=CS4620_co*cred(3);
CS4775=CS4775_co*cred(4);
MUSIC2101=MUSIC2101_co*cred(5);

% General GPA and Major GPA and Max Time
gpa=(MATH3610+CS4620+CS4775+MUSIC2101)/(cred(1)+cred(3)+cred(4)+cred(5));
maj=BEE3310;
t_max=77;
gen_cred=cred(1)+cred(3)+cred(4)+cred(5);
maj_cred=cred(2);

% Class coefficients for Constraints and Objective Function
MATH_con=MATH3610/gen_cred;
BEE_con=BEE3310/maj_cred;
CS1_con=CS4620/gen_cred;
CS2_con=CS4775/gen_cred;
MUS_con=MUSIC2101/gen_cred;

% Constraints and Objective Function
f = [1; 1; 1; 1; 1];
A = -[MATH_con 0 CS1_con CS2_con MUS_con; 0 BEE_con 0 0 0; -c_MATH -c_BEE -c_CS4620 -c_CS4775 -c_MUSIC2101];
b = -[3.0; 3.5; -77];
lb=[0;0;0;0;0];
ub=[t_max;t_max;t_max;t_max;t_max];
ANSWER=linprog(f,A,b,[],[],lb,ub);

fprintf("For MATH3610, spend %d hours\n", ANSWER(1)+c_MATH);
fprintf("For BEE3310, spend %d hours\n", ANSWER(2)+c_BEE);
fprintf("For CS4620, spend %d hours\n", ANSWER(3)+c_CS4620);
fprintf("For CS4775, spend %d hours\n", ANSWER(4)+c_CS4775);
fprintf("For MUSIC2101, spend %d hours\n", ANSWER(5)+c_MUSIC2101);


% Helper functions
function checked = boundchecker(class)
if class>4.0 
    checked=4.0;
elseif class<1 
    checked=1.0;
end
end
