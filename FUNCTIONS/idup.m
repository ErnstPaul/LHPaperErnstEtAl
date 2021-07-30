%% idup.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Traces ID "up" an eddy's ancestry.
%Inputs: See ancestry.m. Not a function to be used on its own.
%Outputs: Matrix of upstream IDs.
function [ids] = idup(id, List, count, ids)
        %takes id of upstream eddy, recurses up to grab all ids
        %grab merged number
        merged=List(:,18);
        merged1=merged{id,1};
        %grab id of current eddy
        count = count + 1;
        ids(count) = id;
        %if it merged, recurse
        if (merged1 > 0)
            ids = idup(merged1,List,count,ids);
        end
        %otherwise, just return current id
end