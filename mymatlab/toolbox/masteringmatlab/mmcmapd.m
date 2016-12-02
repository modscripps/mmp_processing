%MMCMAPD Demonstrate colormap merging.
% MMCMAPD creates a figure window and demonstrates the effects
% of merging two color maps to obtain special color effects.

echo on 
figure;  % create figure window
colormap([rainbow(32); copper(32)]); % set colormap for figure
mesh(peaks+8); 
view(0,0);
hold on; 
mesh(peaks-8);
colorbar;
title('Merging two color maps.');
hold off

