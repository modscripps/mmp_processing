function [fs]=fftshift(f)
% swap fft for conventional spectrum plot
[row,column]=size(f);
if (is_vector(f))
   L=length(f);
   Ld1=fix(L/2);
   Ld2=fix(L/2)+rem(L,2);
   fs(1:Ld1)=f(Ld2+1:L);
   fs(Ld1+1:L)=f(1:Ld2);
   fs = fs(:);
else
   L=row;
   Ld1=fix(L/2);
   Ld2=fix(L/2)+rem(L,2);
   fs(1:Ld1,:)=f(Ld2+1:L,:);
   fs(Ld1+1:L,:)=f(1:Ld2,:);
end
