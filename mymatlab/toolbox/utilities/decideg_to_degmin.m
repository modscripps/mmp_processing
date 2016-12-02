function [degree, minute, sec, hemi] = decideg_to_degmin(deci_deg,lat_or_lon)
% [degree, minute, sec, hemi] = decideg_to_degmin(deci_deg,lat_or_lon)

MIN_DEG = 60;
SEC_DEG = 3600;

% determine if input degrees are within bounds
absdeg = abs(deci_deg);
if absdeg>90 & absdeg<=180 strcmp(deci_deg,'lat')
	disp('latitude magnitude between 90 and 180');
	degree=NaN; minute=NaN; sec=NaN; hemi=[];
elseif absdeg>180
	disp('decimal degrees > 180')
	degree=NaN; minute=NaN; sec=NaN; hemi=[];

else	
	% determine hemisphere
	if strcmp(lat_or_lon, 'lat')
		if deci_deg < 0
			hemi='S';
		else
			hemi='N';
		end
	elseif strcmp(lat_or_lon, 'lon')
		if deci_deg < 0
			hemi='E';
		else
			hemi='W';
		end
	end

	degree = fix(absdeg);

	remdeg = absdeg - degree;
	minute = fix(MIN_DEG*remdeg);

	sec = (remdeg - minute/MIN_DEG) * SEC_DEG;

end
