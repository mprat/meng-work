function [Gx,Gy] = gradient2( I )
% Compute numerical gradients along x and y directions.
%
% For 2D arrays identical to Matlab's gradient() with a spacing value of
% h=1 but ~10-20x faster (due to mexed implementation). Like gradient(),
% computes centered derivatives in interior of image and uncentered
% derivatives along boundaries. For 3D arrays computes x and y gradient
% separately for each channel and concatenates the results.
%
% This code requires SSE2 to compile and run (most modern Intel and AMD
% processors support SSE2). Please see: http://en.wikipedia.org/wiki/SSE2.
%
% USAGE
%  [Gx,Gy] = gradient2( I )
%
% INPUTS
%  I      - [hxwxk] input k channel single image
%
% OUTPUTS
%  Gx     - [hxwxk] x-gradient (horizontal)
%  Gy     - [hxwxk] y-gradient (vertical)
%
% EXAMPLE
%  I=single(imread('peppers.png'))/255;
%  tic, [Gx1,Gy1]=gradient(I,1); toc
%  tic, [Gx2,Gy2]=gradient2(I); toc
%  isequal(Gx1,Gx2), isequal(Gy1,Gy2)
%
% See also gradient, gradientMag
%
% Piotr's Image&Video Toolbox      Version 3.00
% Copyright 2012 Piotr Dollar & Ron Appel.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Simplified BSD License [see external/bsd.txt]

[Gx,Gy]=dollar_toolbox.channels.private.gradientMex('gradient2',I);
