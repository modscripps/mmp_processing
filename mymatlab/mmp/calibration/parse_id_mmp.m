function idout=parse_id_mmp(var,id)
% parse_id_mmp
%   Usage: idout=parse_id_mmp('var',id)
%      var=mmpno or pump or altimeter
%      idout is a number
%   Function: read status bits from id word

if strcmp(var,'mmpno')==1
	idout=id ./ 16;
	idout=fix(idout);
elseif strcmp(var,'pump')==1
	idout=fix(id);
	idout=rem(idout,2);
elseif strcmp(var,'altimeter')==1
	idout=fix(id./2);
	idout=rem(idout,2);
else
	err_msg=['var = ', var, ' not valid variable'];
	error(err_msg)
end
