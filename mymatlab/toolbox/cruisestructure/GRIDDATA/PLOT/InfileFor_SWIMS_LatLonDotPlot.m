% InfileFor_SWIMS_LatLonDotPlot

% Required fields
infile.cruise = 'ml04';
infile.group = 4;
infile.vars = {'t1', 't2'};
infile.fetch.var = 'p_ctd';
infile.fetch.lb = .05;
infile.fetch.ub = .15;
infile.operation = 'avg'; % May be 'avg', 'max', 'min'

% Optional fields
infile.plot_lim = [12.1 12.3];
infile.contours.draw = 'y';
infile.contours.levels = [12.1:.025:12.3]; % Level vector for contour command
infile.contours.n_levels = 10; % Number of contour levels to use.  This is
%    overridden by the levels field if it exists.