function print_save(store_location,prn,option)
%
% PRINT_SAVE: save and print the current figure.
%
%       Usage: print_save(store_location, prn,option);
%
%       Prints the current figure.  If PRN==0 or is ommited
%       then the file is only saved in STORE_LOCATION as an eps file.  If
%       PRN==1 the file is still saved and also printed to the local
%       printer with an added text field in the bottom left corner
%       indicating where the original was stored.  Useful for printing and
%       saving ongoing work.  Store location should be an absolute path for
%       most robust storage. i.e. print_store('/home/jklymak/test.eps',1);
%
%
if (nargin<1)|(nargin>3)
  error('Usage: print_save(store_location,prn,option)');
elseif nargin==1
  prn=0; option='';
elseif nargin==2
  option='';
end;

eval(['print -deps ',store_location,';']);

if prn ==1
    % add another axis;
  a1 = gca;
  a2 = axes('position',[0.05 0.01 0.01 0.01]);
  axis('off');
  tmp=clock;
  text_str=['Stored in: ',store_location ', ' date ', ' ...
    int2str(tmp(4)) ':'  int2str(tmp(5))];
  text(0.05,0.5,[text_str],'Fontsize',10);
  axes(a1);
  print
  %store_location = '/tmp/matlab_print_job.eps';
  %eval(['print -deps ',store_location,';']);
  %eval(['!lp ',option,' ',store_location]);
  delete(a2)
end;
