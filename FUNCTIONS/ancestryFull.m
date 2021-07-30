%% ancestryFull.m (version 1.0)
%Author: Paul Ernst
%Date Created: 6/17/2021
%Date of Last Update: 6/17/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Trace the complete ancestry of a given eddy.
%Inputs: One list of the eddy you're tracking; the ID of the eddy you're
%tracking.
%Outputs: A matrix of the full list of IDs in that eddy's family.
%--------------------------------------
%Note: requires functions [litiup litidown idup iddown] for recursion.
function [idlist] = ancestryFull(List, idEntry) 
id = List(:,1);
id1 = id{idEntry,1};
ccl = 0;
ccd = 0;
%recurse up
[idlistl] = idup(id1,List,ccl,[]);
%recurse down
[idlistd] = iddown(id1,List, ccd,[]);
%take lifetime in full and return
idlist = [idlistd idlistl];
idlist = unique(idlist);
