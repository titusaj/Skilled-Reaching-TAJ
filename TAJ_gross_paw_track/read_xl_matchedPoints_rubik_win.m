function matchedPoints = read_xl_matchedPoints_rubik_win( ratID, varargin )
%
% function to read in matching box points from excel files
%
% INPUTS:
%   ratID - string in the format "Rxxxx" where xxxx is the rat number
%   
% OUTPUTS:
%   matchedPoints - 
%


% kinematics_rootDir = '/Users/dleventh/Box Sync/Leventhal Lab/Skilled Reaching Project/Matlab Kinematics/PlotGrossTrajectory';
xl_directory = 'C:\Box Sync\Box Sync\Leventhal Lab\Skilled Reaching Project\SR_box_matched_points';
xlName = 'R112';

for iarg = 1 : 2 : nargin - 1
    switch lower(varargin{iarg})
        case 'xldir',
            xl_directory = varargin{iarg + 1};
        case 'xlname',
            xlName = varargin{iarg + 1};
    end
end

cd(xl_directory);
% xlName = [ratID '_matched_points.xlsx'];
% if ~exist(xlName,'file')
%     matchedPoints = [];
%     return
% end

[status,sheets] = xlsfinfo(xlName);
if isempty(status)
    matchedPoints = [];
    return
end

numSheets = length(sheets);


for iSheet = 1 : numSheets
    if ~strcmp(sheets{iSheet}(1:5), ratID); continue; end
    
    fprintf('%s, %s\n', ratID,sheets{iSheet})
    [xldata,xlstrings,~] = xlsread(xlName, sheets{iSheet});
    sessionDate = sheets{iSheet}(7:14);
    sessionName = [ratID '_' sessionDate];

    for ii = 2 : size(xlstrings,1)    % skip the "DIRECT VIEW" header

        if ~isempty(xlstrings{ii,1})
            if ii > size(xldata,1)+1
                matchedPoints.(sessionName).direct.(xlstrings{ii,1}) = nan(1,2);
                matchedPoints.(sessionName).leftMirror.(xlstrings{ii,1}) = nan(1,2);
                matchedPoints.(sessionName).rightMirror.(xlstrings{ii,1}) = nan(1,2);
            else
                matchedPoints.(sessionName).direct.(xlstrings{ii,1}) = ...
                    xldata(ii-1,1:2);
                matchedPoints.(sessionName).leftMirror.(xlstrings{ii,1}) = ...
                    xldata(ii-1,5:6);
                matchedPoints.(sessionName).rightMirror.(xlstrings{ii,1}) = ...
                    xldata(ii-1,9:10);
            end
            
        end

    end    % for ii...

end
    
    
