%% iddown.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Traces ID "down" an eddy's ancestry.
%Inputs: See ancestry.m. Not a function to be used on its own.
%Outputs: Matrix of downstream IDs.
function [ids] = iddown(id, List, count, ids)
        %takes id of downstream eddy, recurses down to grab all ids
        %grab merged number
        merged=List(:,20);
        merged1=merged{id,1};
        %grab id of current eddy
        count = count + 1;
        ids(count) = id;
        %if it merged, recurse
        if (merged1 > 0)
            ids = iddown(merged1,List,count,ids);
        end
        %otherwise, just return current id
end