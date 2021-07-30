%% litidown.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Traces Lifetime "down" an eddy's ancestry.
%Inputs: See ancestry.m. Not a function to be used on its own.
%Outputs: Total downstream lifetime.
function [lifedown] = litidown(id, List)
        %takes id of downstream eddy, recurses down to grab all lifetimes
        %grab merged number
        merged=List(:,20);
        merged1=merged{id,1};
        %grab lifetime of current eddy
        lifedown1=List(:,16);
        lifedown=lifedown1{id,1};
        %if it merged, recurse
        if (merged1 > 0)
            lifedown = lifedown + litidown(merged1,List);
        end
        %otherwise, just return current lifetime
end