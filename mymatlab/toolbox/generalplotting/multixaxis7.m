function H = multixaxis7(in);

% Input: 'in' must be a structure with at least two fields: in.data.x
%   and in.data.y. Up to 8 data.x entries are allowed.
%  Optional fields
%   line(i).<field> where field is any line property
%   xlabel: string to 
%   line: any of the standard parameters that can be set for a line


% Check mandatory inputs and conditions
if ~isfield(in, 'data')
    error('No data field is included.')
elseif length(in.data) > 8
    error('Only 8 data.x entries are allowed') 
elseif length(in.data(1).x)~= length(in.data(1).y)
    error('length(in.data(1).x)~= length(in.data(1).y)')
end


color = [[1 0 0]; ... % red
        [0 0 1]; ... % blue
        [0 1 0]; ... % green
        [1 0 1]; ... % maroon
        [0 1 1]; ... % cyan
        [0.667 1 0]; ... % yellow-green
        [1 0.647 0]; ... % orange
        [0.5 0 1]; ... % purple
        [0.49 1.0 0.83]];   ... % aquamarine
 
    
% Set defaults
if ~isfield(in, 'position') in.position=[.15 .25 .6 .5]; end
line_color = {'k', 'r', 'b', 'g'};
    
% Plot the data
for i = 1:length(in.data)
    % If in.data(i).y is not included, use in.data(1).y if lengths match.
    % Otherwise, plot data(i).x against matching data(i).y.  Set the
    % default color, and change it later if another color is specified.
    if isempty(getfield(in.data(i),'y'))
        if length(in.data(i).x) == length(in.data(1).y)
            H.line(i) = plot(in.data(i).x, in.data(1).y, 'color', color(i,:));
        else
            error(['There is no in.data(' int2str(i) ...
                    ').y, and length(in.data(' int2str(i) ').x) ~= length(in.data(1).y)'])
        end
    else
        if length(in.data(i).x)==length(in.data(i).y)
            H.line(i) = plot(in.data(i).x, in.data(i).y, 'color',color(i,:));
        else
            error(['length(in.data(' int2str(i) ').x)==length(in.data(' ...
                    int2str(i) ').y)'])    
        end
    end
    hold on
    
    % Set line parameters specified by fields of in.line(i)
    if isfield(in, 'line')
        if i<= length(in.line) % Insure that in.line includes ith line
            fields = fieldnames(in.line(i));
            % Step through the fields
            for j = length(fields)
                % Be certain that the field isn't empty for this line
                if ~isempty(getfield(in.line(i), char(fields(j))))
                    set(H.line(i), char(fields(j)), getfield(in.line(i), char(fields(j))))
                end
            end
        end
    end
                
end