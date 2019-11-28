%% COMMON REFERENCE TESTS ( + comparison with fieldtrip)

% Data generated with fieldtrip (created function gdf_OV_generate, check
% doc) with and without connectivity to see how activity in reference
% electrode is mistakenly taken as connectivity. If algorithms discard
% instantaneous interactions (real part of Cross-Spectrum) this effect
% disappears.


FS = 1000;
FS_DEC = 200;                       % after decimation x5
SEG_LENGTH = 100;                   % segment length
SEG_LENGTH_H = 50;                  % 2*number of frequencies for Hilbert algorithm
NAMES = {'MSCoh','ImC','PSI'};
FILES1 = {'\common_ref.csv','\common_ref_none.csv'};
FILES2 = {'conn\','no_conn\'};

%% 8 plots, 2 for each algorithm (with & without connectivity), algorithms : MSCoh, MSImC, PSI, wPLI

% Note: in order for noise to be comparable, ImC was squared, change if you
% will. Might have been a good idea to use the squared measure for the
% experiments.

% Welch method based algorithms - MSCoh, ImC, wPLI

figure;
for i=1:3
    subplot(2,2,i)
    for j=1:2
        name = strcat('D:\UnityNeurofeedback\Tests\CommonReference\',NAMES{i},FILES1{j});
        id = fopen(name,'rt');
        fmt = repmat('%f', 1, SEG_LENGTH + 5);
        datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
        channell = datacell{1};
        channell = channell(:,3:2:end-3);
        avg = mean(channell,1);
        switch i
            case 2
                avg = avg;
            case 3
                avg = abs(avg);
        end
        freqs = 0 : FS_DEC/SEG_LENGTH : FS_DEC/2 - FS_DEC/SEG_LENGTH;
        
   % PLOT CONNECTIVITY AND NO CONNECTIVITY FOR MSCoh, ImC, PSI
        
        hold on;plot(freqs, avg,'LineWidth',2);
    end
    legend('Coupling', 'No Coupling');
    title(NAMES{i}, 'FontSize',30);
    ylim([0 1])
    ylabel(NAMES{i},'FontSize',25)
    xlabel('frequency (Hz)','FontSize',25)
    %set(gca, 'XTickLabel', {'0', '10', '20','30', '40', '50', '60', '70', '80', '90', '100'},'FontSize',25)
    fclose all;
    
end

% Hilbert based algorithm - Weighted Phase Lag Index

subplot(2,2,4);
avg = zeros(2,25);
avg_no_conn = zeros(1,25);
for i=1:25
    for j=1:2
    name = strcat('D:\UnityNeurofeedback\Tests\CommonReference\wPLI\',FILES2{j},num2str((i-1)*4),'.csv');
    id = fopen(name,'rt');
    fmt = repmat('%f', 1, 6);
    datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
    channell = datacell{1};
    channell = channell(:,3);
    avg(j,i) = mean(channell,1);
    %subplot(1,2,i);
    freqs = 0 : FS_DEC/SEG_LENGTH_H : FS_DEC/2 - FS_DEC/SEG_LENGTH_H;
    end
end

% PLOT CONNECTIVITY AND NO CONNECTIVITY FOR wPLI

plot(freqs,avg(1,:).^2,'LineWidth',2)
hold on;
plot(freqs,avg(2,:).^2,'LineWidth',2);
legend('Coupling', 'No Coupling');
title('wPLI', 'FontSize',30);
ylim([0 1])
ylabel('wPLI','FontSize',25)
xlabel('frequency (Hz)','FontSize',25)
%set(gca, 'XTickLabel', {'0', '10', '20','30', '40', '50', '60', '70', '80', '90', '100'},'FontSize',25)
fclose all;
