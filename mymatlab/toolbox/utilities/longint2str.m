function n=longint2str(int)
% n=longint2str(int) Returns integer string for int=1 to 9999999

drop=abs(int);

if int <= 9999 
	n=num2str(int);
else
	x=fix(int/1000);
	y=rem(int,1000);
	if y < 100 & y >= 10 
		n=[num2str(x) num2str(0) num2str(y)];
	elseif abs(y) < 10 & abs(y) >= 0
		n=[num2str(x) num2str(0) num2str(0) num2str(y)];
	else
		n=[num2str(x)  num2str(y)];
	end
end
