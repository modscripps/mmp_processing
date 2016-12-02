function list = read_droplist(inputlist)
% read_droplist
%   Usage: list = read_droplist(inputlist)
%      droplist is an ascii file with two columns, e.g.
%		inputlist
%		14290	0
%		14293	0
%		14295	14298
%      If the second column is 0 or less, only the drop in the 
%      1st column is used. If the second column > 0, the list is
%      expanded to include all intervening drops.  The output,
%      list, is a column vector containing all drop, one to a row.
%   Function: to expand a drop list that is easy to write to
%      one that is easy to use for processing.

list=[]; %This vector becomes the output list

for i=1:length(inputlist(:,1));
	list=[list;inputlist(i,1)]; % add first column in row to list
 	if inputlist(i,1) >= 1 % if 2nd col. in row > 0, add it to list
		newdrops=inputlist(i,1)+1:inputlist(i,2);
		list=[list;newdrops'];
	end
end


