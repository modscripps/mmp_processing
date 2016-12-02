function Pn=legendre(n,x);
% legendre
%   Usage: Pn=legendre(n,x);
%      n is an integer geq 0 giving the order
%      x is a number vector of values where the polynomial is to be evaluated
%      Pn is a number or vector of nth order Legrendre polynomials evaluated
%         at x
%   Function: Evaluate the Legendre polynomial of arbitrary order
%      using the recursion relation for orders 2 and greater

% check that n is an integer geq 0
if size(n)>1 | rem(n,1)~=0 | imag(n)~=0 | n<0
	error('n must be an integer geq 0')
end

% set up a matrix for the intermediate polynomials to order n
len_x=length(x);
P=zeros(n+1,len_x);

P(1,:)=ones(1,len_x); % zeroth order, P_0

if n>=1
	P(2,:)=x; % first order
end

for order=2:n
	index=order+1;
	P(index,:)=((2*order-1)*x.*P(index-1,:) - (order-1)*P(index-2,:))/order;
end
Pn=P(n+1,:);
