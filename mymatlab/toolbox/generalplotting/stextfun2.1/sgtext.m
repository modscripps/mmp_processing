%
%    sgtext(sometext,rotation);
%
%     ex. sgtext('testing',90);

  function sgtext(sometext,rotation);
  
  if ~exist('rotation')
     rotation = 0;
  end
  [x,y]=ginput(1);
  stext(x,y,sometext,'rotation',rotation);
