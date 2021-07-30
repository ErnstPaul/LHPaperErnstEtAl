%% ancestry.m (version 1.0)
%Author: Paul Ernst
%Date Created: 5/20/2021
%Date of Last Update: 5/20/2021
%What was last update?
%Created.
%--------------------------------------
%Purpose: Trace the complete ancestry of a given eddy.
%Inputs: Two lists: one that contains at least partial data of the original
%eddy (List1), and one that contains the full data of all eddies with
%traceable ids (List2). These can be the same if you like. Also, Start: the
%original List1 index of the eddy we care about.
%Outputs: A matrix of the full lifetime of the eddy we're looking at, as
%well as a matrix of the ids that exist in its entire ancestry (merged
%from/into, split from/into).
%--------------------------------------
%Note: requires functions [litiup litidown idup iddown] for recursion.
function [fulllife, idlist] = ancestry(List1, List2, start) 
%Grab initial lifetime of eddy
life_a = List1(:,16);
life_1 = life_a{start,1};
% Compute total lifetime of eddy family: from beginning of
% split to end of merge
id = List1(:,1);
id1 = id{start,1};
ccl = 0;
ccd = 0;
%recurse up
[fulllifeup] = litiup(id1,List2);
[idlistl] = idup(id1,List2,ccl,[]);
%recurse down
[fulllifedown] = litidown(id1,List2);
[idlistd] = iddown(id1,List2, ccd,[]);
%take lifetime in full and return
fulllife  = fulllifeup + fulllifedown - life_1;
idlist = [idlistd idlistl];
idlist = unique(idlist);
