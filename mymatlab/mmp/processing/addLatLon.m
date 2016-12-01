function MMPout = addLatLon(MMP,met_path,data_path)
% addLatLon.m
% Given an MMP structure and a path to the met data, this adds the
% ins_seapath_position
% information to the MMP structure and saves the structure.


    disp('No lat/lons, interpolating now')
    disp('Loading MET data')
    load(met_path)
    gps = data.ins_seapath_position;
    dates = MMP.yday+datenum(2015,1,1);
    MMP.lat = interp1(gps.dnum, gps.lat, dates);
    MMP.lon = interp1(gps.dnum, gps.lon, dates);
    % Find indices of cnav rainge
    scin = 1;
    ecin = 1;

    for i = 1:length(gps.dnum)
        if gps.dnum(i) > dates(1)
            scin = i;
            break;
        end
    end
    for i = scin:length(gps.dnum)
        if gps.dnum(i) > dates(end)
            ecin = i;
            break;
        end
    end
    save(data_path,'MMP')
    MMPout = MMP;
end

