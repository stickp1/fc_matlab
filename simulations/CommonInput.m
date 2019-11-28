%% COMMON INPUT TESTS ( + comparison with fieldtrip)

% Data generated with fieldtrip (created function gdf_OV_generate, check
% doc) for three different cases hghlighting common input problems that may
% arise:
%
% 1) is 3 observed nodes where 3->1 and 3->2 at lags 1 and 2
%    Connectivity between 1,2 will be identified unless algorithm
%    disregards instantaneous interactions

% 2) is 2 observed nodes (1, 2) where 3->1 at lag 1 and 3->2 at lag 2
%    Connectivity between 1,2 will be identified, but for PSI is not
%    significant - probably will skip this one, since there is no actual
%    difference from 3) and in 3 we can see all nodes
%
% 3) is case 2 but all nodes are observed
%    We can see that smaller lags -> higher connectivity
%    Other than that, everything is the same, since there is no dependence
%    of one pair's connectivity on another (this would only be relevant for
%    granger causality I believe) 


FS = 200;
SEG_LENGTH = 50; % segment length

%% CASE 1
% Coherence and Imaginary Part of Coherency (nonw«e magnitude squared)
figure;
subplot(1,2,1)
name = 'D:\UnityNeurofeedback\Tests\CommonInput\case1_MSCoh.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3 * SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
plot(freqs, sqrt(conn_12),'LineWidth',2)
hold on;
plot(freqs, sqrt(conn_13),'LineWidth',2)
hold on;
plot(freqs, sqrt(conn_23),'LineWidth',2)
%fclose all;

name = 'D:\UnityNeurofeedback\Tests\CommonInput\case1_ImC.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3 * SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
hold on;
plot(freqs, conn_12,'LineWidth',2)
title('MSCoh and ImC')
l1 = legend('1-2 MSCoh','1-3 MSCoh','2-3 MSCoh', '1-2 ImC','FontSize');
l1.FontSize = 15;
ax = gca;
ax.FontSize = 20;
xlabel('frequency (Hz)')

% Phase Slope Index
name = 'D:\UnityNeurofeedback\Tests\CommonInput\case1_PSI.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3 * SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
subplot(1,2,2)
plot(freqs, conn_12,'LineWidth',2)
hold on;
plot(freqs, conn_13,'LineWidth',2)
hold on;
plot(freqs, conn_23,'LineWidth',2)
title('Phase Slope Index')
l2 = legend('1-2','1-3','2-3');
l2.FontSize = 15;
ax = gca;
ax.FontSize = 20;
xlabel('frequency (Hz)')
fclose all;

%% CASE 2

name = 'D:\UnityNeurofeedback\Tests\CommonInput\case2_PSI.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3*SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
figure;
plot(freqs, conn_12,'LineWidth',2)
ylim([-1 0.1])
title('Phase Slope Index')
legend('1-2');
fclose all;

%% CASE 3
figure
name = 'D:\UnityNeurofeedback\Tests\CommonInput\case3_MSCoh.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3*SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
subplot(2,2,1)
plot(freqs, conn_12,'LineWidth',2)
hold on; plot(freqs, conn_13,'LineWidth',2)
hold on; plot(freqs, conn_23,'LineWidth',2)
title('MSCoh')
l2 = legend('1-2','1-3','2-3');
l2.FontSize = 15;
ax = gca;
ax.FontSize = 20;
xlabel('frequency (Hz)')

name = 'D:\UnityNeurofeedback\Tests\CommonInput\case3_ImC.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3*SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
subplot(2,2,2)
plot(freqs, conn_12,'LineWidth',2)
hold on; plot(freqs, conn_13,'LineWidth',2)
hold on; plot(freqs, conn_23,'LineWidth',2)
title('ImC')
l2 = legend('1-2','1-3','2-3');
l2.FontSize = 15;
ax = gca;
ax.FontSize = 20;
xlabel('frequency (Hz)')

name = 'D:\UnityNeurofeedback\Tests\CommonInput\case3_PSI.csv';
id = fopen(name,'rt');
fmt = repmat('%f', 1, 3*SEG_LENGTH + 5);
datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
channell = datacell{1};
channell = channell(:,3:2:end-3);
avg = mean(channell,1);
conn_12 = avg(1:25);
conn_13 = avg(26:50);
conn_23 = avg(51:75);
freqs = 0 : FS/SEG_LENGTH : FS/2 - FS/SEG_LENGTH;
subplot(2,2,4)
plot(freqs, conn_12,'LineWidth',2)
hold on;
plot(freqs, conn_13,'LineWidth',2)
hold on;
plot(freqs, conn_23,'LineWidth',2)
title('Phase Slope Index')
l2 = legend('1-2','1-3','2-3');
l2.FontSize = 15;
ax = gca;
ax.FontSize = 20;
xlabel('frequency (Hz)')



% Hilbert based algorithm - Weighted Phase Lag Index
subplot(2,2,3);
avg = zeros(1,25);
avg_no_conn = zeros(1,25);
for i=1:25
    name = strcat('D:\UnityNeurofeedback\Tests\CommonInput\wPLI\',num2str((i-1)*4),'.csv');
    id = fopen(name,'rt');
    fmt = repmat('%f', 1, 8);
    datacell = textscan(id, fmt, 'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
    channell = datacell{1};
    conn_12(i) = mean(channell(:,3));
    conn_13(i) = mean(channell(:,4));
    conn_23(i) = mean(channell(:,5));
    %subplot(1,2,i);
    freqs = 0 : 4 : FS/2 - 4;
end

plot(freqs,conn_12.^2,'LineWidth',2)
hold on;
plot(freqs,conn_13.^2,'LineWidth',2)
hold on;
plot(freqs,conn_23.^2,'LineWidth',2)
title('wPLI');
l2 = legend('1-2','1-3','2-3');
l2.FontSize = 15;
ax = gca;
ax.FontSize = 20;
ylim([0 1])
xlabel('frequency (Hz)')
%set(gca, 'XTickLabel', {'0', '10', '20','30', '40', '50', '60', '70', '80', '90', '100'},'FontSize',25)
fclose all;


fclose all;
