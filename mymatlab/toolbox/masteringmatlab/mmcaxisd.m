%MMCAXISD Demonstrate colormap splitting.
% MMCAXISD creates three figure windows and demonstrates the effects
% of manipulating the color axis using the CAXIS function.

echo on 
%======================================================================
% Create two subplots showing how to use the caxis function to use
% only a portion of the same color map for each subplot.
%======================================================================

fig1=figure;
set(fig1,'numbertitle','off','name','Example 1: effect of splitting the caxis.');
colormap(rainbow);
subplot(2,1,1); mesh(peaks(20)+8); 
 title('Caxis = [-16 16]'); caxis([-16 16]); view(0,0); colorbar; hold on;
subplot(2,1,2); mesh(peaks(20)-8); 
 title('Caxis = [-16 16]'); caxis([-16 16]); view(0,0); colorbar; hold on;

% Press a key for the second caxis example...
pause

%======================================================================
% Create two subplots showing how to use the caxis function to 
% restrict the colors to a selected subset of the data.
%======================================================================

fig2=figure;
set(fig2,'numbertitle','off','name','Example 2: effect of restricting the caxis.');
colormap(rainbow);
subplot(1,2,1); mesh(peaks(20)+8); hold on; mesh(peaks(20)-8);
 title('Caxis = [-16 16]'); caxis([-16 16]); view(0,0); colorbar; hold on;
subplot(1,2,2); mesh(peaks(20)+8);  hold on; mesh(peaks(20)-8);
 title('Caxis = [-16 0]'); caxis([-16 0]); view(0,0); colorbar; hold on;

% Press a key for the third caxis example...
pause

%======================================================================
% Create two subplots showing how to use the caxis function to 
% extend the colors to a range greater than the data.  This has
% the effect of using only the middle of the color scale for the data.
%======================================================================

fig3=figure;
set(fig3,'numbertitle','off','name','Example 3: effect of extending the caxis.');
colormap(rainbow);
subplot(1,2,1); mesh(peaks(20)+8); hold on; mesh(peaks(20)-8);
 title('Caxis = [-16 16]'); caxis([-16 16]); view(0,0); colorbar; hold on;
subplot(1,2,2); mesh(peaks(20)+8);  hold on; mesh(peaks(20)-8);
 title('Caxis = [-25 25]'); caxis([-25 25]); view(0,0); colorbar; hold on;

% Press a key to close the example figures...
pause

%======================================================================
% Clean up and exit.
%======================================================================

delete(fig1);
delete(fig2);
delete(fig3);
echo off
