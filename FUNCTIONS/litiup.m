%% litiup.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Traces Lifetime "up" an eddy's ancestry.
%Inputs: See ancestry.m. Not a function to be used on its own.
%Outputs: Total upstream lifetime.
function [lifeup] = litiup(id, List)
        %takes id of upstream eddy, recurses up to grab all lifetimes
        %grab merged number
        merged=List(:,18);
        merged1=merged{id,1};
        %grab lifetime of current eddy
        lifeup1=List(:,16);
        lifeup=lifeup1{id,1};
        %if it merged, recurse
        if (merged1 > 0)
            lifeup = lifeup + litiup(merged1,List);
        end
        %otherwise, just return current lifetime
end