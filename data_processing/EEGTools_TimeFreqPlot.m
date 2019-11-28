function result = EEGTools_TimeFreqPlot(PlotMatrix, fmin, fmax,FreqSmpCount, DesiredYLabels)

PlotMatrix           = log(abs(PlotMatrix)+.01);

imagesc(squeeze(PlotMatrix(:,:)));

yfactor         = (fmax/fmin)^(1/(FreqSmpCount-1)); % factor between logarithmic frequency ticks

hold on % plot frequency grid lines
    yLabelPos = log(DesiredYLabels./fmin)./log(yfactor)+1;
    result = plot([1 length(PlotMatrix(:,2))],[yLabelPos',yLabelPos'],'k')
    set(gca,'YTick',yLabelPos)
    set(gca,'YTickLabel',num2str(DesiredYLabels'),'FontSize',16)
hold off

xlabel('Time (s)','FontSize',18)
ylabel('Frequency (Hz)','FontSize',18)