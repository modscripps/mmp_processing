function write_FinalCruiseLog(cruise)
% Usage: write_FinalCruiseLog(cruise)
% mgregg, mar03 during bs03 cruise
% rev.  11oct03 mgregg  Changed line 129 in getting yday from subunits.
%           Fixed an apparent error and changed sub(end).tag to
%           sub(end).tag(2)

% Load cruise folders
eval([cruise '_folders'])

%if strcmp(cruise,'ml04')==1
%    cruise_logs=fullfile('~malford/Projects/MixedLayerRestrat/Cruise', 'logs');
%elseif strcmp(cruise,'aeg04')==1
%    cruise_logs=fullfile('~malford/Projects/Aegean/OceanusCruise', 'logs');
%end

cruise_data = fullfile('~malford/Data', cruise);
cruise_logs = fullfile(cruise_data, 'logs');

%To avoid a conflict with the raw cruise log, this one is "f" until the
% final is saved at the end of this script.

% Load the raw cruise log
eval(['load ' char(39) cruise_logs filesep cruise '_RawCruiseLog' char(39)])
f = cr;

% New log entries
f.log.script_rawlog = cr.log.script;
f.log.datestr_rawlog = cr.log.datestr;
f.log.script = ['C:\' cruise '\matlab\logs\write_bs03_FinalCruiseLog2'];
f.log.datestr = datestr(clock);

%%%%%%%%%%%%%%%%%%% FIRST PASS, GET YDAY FOR AMP & MMP DROPS %%%%%%%%%%%%%%%%%
% Use amplog and mmplog to get yday of drops in groups and
% subgoups and add those yday to the cruise log.  If the group contains
% subgroups, also add yday of start and stop of group as group().yday.

% Construct cell array get_yday if 'amp' and/or 'mmp' data are in raw
% cruise log
for i=1:length(cr.data_names)
    if strcmp(char(cr.data_names(i)), 'amp')
        get_yday = {'amp'};
    end
end

for i=1:length(cr.data_names)
    if strcmp(char(cr.data_names(i)), 'mmp')
        if exist('get_yday')
            get_yday = [get_yday, {'mmp'}];
        else
            get_yday = {'mmp'};
        end
    end
end

if exist('get_yday')
    for i = 1:length(get_yday)

        % Set variable 'sys' to the data name in 'get_yday', i.e. 'amp' or 'mmp'
        sys = deblank(char(get_yday{i}));

        % Set variable 'logfile' equal to 'amplog' or 'mmplog'
        if strcmp(sys, 'amp')
            eval(['load ' char(39) amp_procdata filesep 'amplog.mat' char(39)])
            logfile = amplog;
        elseif strcmp(sys, 'mmp')
            %eval(['load ' char(39) mmp_procdata '\mmplog.mat' char(39)])
            %logfile = mmplog;
        end

        % Find i_dat such that cr.data(i_dat).name matches 'sys'
        for i_dat = 1:length(f.data)
            if strcmp(cr.data(i_dat).name, sys) break; end
        end

        % Step through the groups in cr.data(i_dat)
        for i_gr = 1:length(cr.data(i_dat).group)

            % If the unit is 'drop', get yday for drops
            if strcmp(cr.data(i_dat).group(i_gr).unit, 'drop')

                % Step through the drops in the group getting yday for
                % each and the first and last drop
                y_day = [];
                for m = 1:length(cr.data(i_dat).group(i_gr).tag)
                    i_drop = find(logfile(:,1) == cr.data(i_dat).group(i_gr).tag(m));
                    y_day = [y_day logfile(i_drop,3)];
                end

                % Add yday vector to the group structure
                if ~isempty(y_day) f.data(i_dat).group(i_gr).yday = y_day; end

                % If the subunit is 'drop', get yday for each subgroup
            elseif strcmp(cr.data(i_dat).group(i_gr).subunit, 'drop')

                n_subgroups = length(cr.data(i_dat).group(i_gr).sub);
                for m = 1:n_subgroups % loop over subgroups

                    % Step through the drops in subgroup 'm' getting each yday
                    y_day = [];
                    n_drops = length(cr.data(i_dat).group(i_gr).sub(m).tag);
                    for n = 1:n_drops
                        i_drop = find(logfile(:,1) == cr.data(i_dat).group(i_gr).sub(m).tag(n));
                        y_day = [y_day logfile(i_drop,3)];
                    end

                    % Add yday vector to the subgroup structure
                    if ~isempty(y_day) f.data(i_dat).group(i_gr).sub(m).yday = y_day; end

                end % end subgroup loop

                % Put the yday vector for the group in the structure
                f.data(i_dat).group(i_gr).yday = [f.data(i_dat).group(i_gr).sub(1).yday(1) ...
                    f.data(i_dat).group(i_gr).sub(n_subgroups).yday(end)];
            end % end if branch within the group
        end  % end group loop
    end
end

%%%%%%%%%%%%%% SECOND PASS, INSERT YDAY FIELDS IN GROUPS LACKING THEM %%%%%%%%
%   Insert a yday field with earliest and latest times in group subfields.
%   Begin by checking whether group has a 'yday' subfield.  If it does, set a flag
%   to stop further looking.  Even if 'group.yday' has more than two
%   values, the first and last are the group times.  If not, look
%   sequentially for 1) group.unit = 'yday', 2) group.subunit = 'yday', and
%   3) group.sub.yday.  Put first and last in group.yday.
for i_dat = 1:length(f.data)
    % Test that data(i_dat) had field 'group'
    if isfield(f.data(i_dat), 'group')

        for i_gr = 1:length(f.data(i_dat).group) % Loop for each group
            need_yday = 'y';

            % Determine whether this group has a 'yday' field.  If not, set
            % flag that one is needed.
            if isfield(f.data(i_dat).group(i_gr), 'yday')    % Go to next group if yday is filled
                if ~isempty(f.data(i_dat).group(i_gr).yday)
                    need_yday = 'n';
                end
            end

            % If this group has a 'unit' field and if the unit is 'yday',
            % put the first and last values in a group 'yday' field
            if isfield(f.data(i_dat).group(i_gr), 'unit') & strcmp(need_yday, 'y') % See if units has yday info
                if strcmp(f.data(i_dat).group(i_gr).unit, 'yday') & ~isempty(f.data(i_dat).group(i_gr).tag)
                    % if units contains ydays, use them for group yday
                    f.data(i_dat).group(i_gr).yday = ...
                        [f.data(i_dat).group(i_gr).tag(1) f.data(i_dat).group(i_gr).tag(end)];
                    need_yday = 'n';
                end
            end

            % If this group has a 'subunit' field and if the value is
            % 'yday', take earliest and latest times for group yday
            if isfield(f.data(i_dat).group(i_gr), 'subunit') & strcmp(need_yday, 'y')
                if strcmp(f.data(i_dat).group(i_gr).subunit, 'yday')
                    if ~isempty(f.data(i_dat).group(i_gr).sub(1).tag)
                        yday_gr = f.data(i_dat).group(i_gr).sub(1).tag(1);
                    end
                    if ~isempty(f.data(i_dat).group(i_gr).sub(end).tag(2)) % ...
                        %& (length(f.data(i_dat).group(i_gr).sub) > 1)
                        yday_gr = [yday_gr f.data(i_dat).group(i_gr).sub(end).tag(end)];
                    end
                    f.data(i_dat).group(i_gr).yday = yday_gr;
                    need_yday = 'n';
                end
            end

            % If this group has a 'sub' field see if it has a 'yday' field.  If it does, use the earliest
            % and latest times for group yday
            if isfield(f.data(i_dat).group(i_gr), 'sub') & strcmp(need_yday, 'y')
                if ~isempty(f.data(i_dat).group(i_gr).sub)
                    if isfield(f.data(i_dat).group(i_gr).sub, 'yday')
                        if ~isempty(f.data(i_dat).group(i_gr).sub(1).yday)
                            yday_gr = f.data(i_dat).group(i_gr).sub(1).yday(1);
                        end
                        if ~isempty(f.data(i_dat).group(i_gr).sub(end).yday) ...
                                & (length(f.data(i_dat).group(i_gr).sub) > 1)
                            yday_gr = [yday_gr f.data(i_dat).group(i_gr).sub(end).yday(end)];
                        end
                        f.data(i_dat).group(i_gr).yday = yday_gr;
                        need_yday = 'n';
                    end
                end
            end
        end
    end
end

% Replace the 'cr' structure with the 'f' structure and save
cr = f;
outfile = fullfile(cruise_logs, [cruise '_FinalCruiseLog']);
eval(['save ' char(39) outfile char(39) ' cr'])

