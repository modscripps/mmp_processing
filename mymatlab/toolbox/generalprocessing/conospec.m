
function [conup,conlo] = conospec(dof,reflev,prob),
%---------------------------------------------------------------------------
%   CONOSPEC              05-16-89                  Ren-Chieh Lien
%
%   construct confidence interval of spectrum given degree
%   of freedom
%
%   [conup, conlo] = conospec(dof,reflev,[prob (0.95)])
%
%
%    conup and conlo are upper and lower bound of confidence interval
%    dof is the degree of freedom, reflev the reference levels of the
%    spectrum where the confidence interval will be plotted
%
%---------------------------------------------------------------------------
%Mike,
%  Here is the .m file call for the confidence interval.
%Reflev is the reference level for the onfidence interval, ex. reflev =
%1; or reflev = your spectral density. Default prob is 0.95. Since the
%new version of matlab, I am not sure prob other than 0.95 will work. 
%So, be cautious.  Ren-Chieh


       dof = dof(:)';
       toolarge = find(dof >= 2998);
       dof(toolarge) = 2998*ones(1,length(toolarge));
       if ~exist('prob');
          prob = 0.95;
          lb = (1-prob)/2;
          ub = lb+prob;
          [cup,clo]=chisqr(dof);
       else
          lb = (1-prob)/2;
          ub = lb+prob;
          cup = chisquared_table(ub,dof);
          clo = chisquared_table(lb,dof);
       end
       if length(reflev)> 1;
           conup = (reflev(:).*dof(:))./cup(:);
           conlo = (reflev(:).*dof(:))./clo(:);
       else
           conup = reflev*dof./cup;
           conlo = reflev*dof./clo;
       end
