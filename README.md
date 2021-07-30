# LHPaperErnstEtAl
Repository for all public code relating to this paper.

This is the repository for all code relating to this paper that I am allowed to share.

There are some files ("The Eddy Tracking Steps") which I am not allowed to share on account of them not being my code.
(Those particular snippets were more or less leased by the lab, not me.)
See the text of the paper for the different authors you may accost for their specific code that interfaces with mine.
Notably, Pegliasco et al. (2015), whose algorithm we use and improve upon.

The organization is as such: besides the readme, every piece of code here is a .m file or a .mat file. 

All major functions are in a folder labelled "FIGURES":

Paul_FLH = A Formation file that produces some critical piece of data from CMEMS altimetry / GLORYS12v1 or NOAA Blended Winds or AE_traj file.

Paul_LH = A Critical file that directly produces a figure in the paper.

All .mat files are in a folder labelled "MAT DATA."

All subfunctions are in a folder labelled "FUNCTIONS."

When all is said and done, you should be able to replicate all this work easily, assuming you can get the rights to the Eddy Tracking Steps.

Everything here done on MATLAB2021a. Check for version dependencies. 
