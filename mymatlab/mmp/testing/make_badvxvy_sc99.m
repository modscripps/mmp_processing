% make_badvxvy_sc99.m - use results from find_a1a2v1v2_spikes_bytime.m to
%	generate problem files for eps1,eps2 (vx,vy), specifying bad portions
%	by bracketing the middle of the pressure windows (pr_eps)

set_mmp_paths

% load file designating contaminated/suspect data; find drop,pr_eps pairs
clear sav_BADs
%load FindSpikes1018 FindSpikes1024
load FindSpikes1026
dd=[1;diff(sav_BADs(:,1))]; dp=[1;diff(sav_BADs(:,2))];
ix=find(dd>0|abs(dp)>0.0001); % change in either drop or pr_eps
drop_pr = sav_BADs(ix,1:2);

cruise = 'sc99';
ldrop = -1; newbad=0;
for ir=1:size(drop_pr,1)
   drop=drop_pr(ir,1); pr_eps=drop_pr(ir,2);
   % check for new drop
   if drop~=ldrop
      % save revised problem files for previous drop
      if drop>0 & newbad>0
         save(fnvx,'badvx'); save(fnvy,'badvy');
      end
      newbad=0; ldrop=drop;
      mmpid=read_mmpid(drop);
      % skip near-surface pressures already ignored by get_epsilon2_mmp.m
      switch mmpid
      case 'mmp3'
         prMINgd=0.030;
      otherwise
         prMINgd=0.027;
      end
      % append to existing files
      badvx=[]; badvy=[];
      fnvx=[procdata '\' cruise '\problems\vx\badvx' int2str(drop) '.mat'];
      fnvy=[procdata '\' cruise '\problems\vy\badvy' int2str(drop) '.mat'];
      if exist(fnvx)==2 load(fnvx); end
      if exist(fnvy)==2 load(fnvy); end
   end % of new drop setup
   % append to problem files
   if pr_eps>prMINgd
      badvx = [badvx; pr_eps-0.0001 pr_eps+0.0001];
      badvy = [badvy; pr_eps-0.0001 pr_eps+0.0001];
      newbad = newbad+1;
   end
   
end % of loop
% save revised problem files for final drop in list
if drop>0 & newbad>0
   save(fnvx,'badvx'); save(fnvy,'badvy');
end





