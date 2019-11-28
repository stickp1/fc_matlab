%% Alpha individual means across sessions

alphas = [2,4,7,8];
figure
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_IAB.mat'));
    load(strcat('Subject_',num2str(alphas(subject)),'_baseline.mat'))
    if subject == 1
        ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha33; ALPHA_plot(3,:,:)];
        ALPHA_cal = [ALPHA_cal; ALPHA_plot(4,end,5) 0 ALPHA_plot(4,end,5) 0];
    end
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(max(max(means)),max(mean([ALPHA_cal(:,1) ALPHA_cal(:,3)],2))); 
    minVal = min(min(min(means)),min(mean([ALPHA_cal(:,1) ALPHA_cal(:,3)],2)));
    for session=1:4
        subplot(8,4,(subject-1)*4 + session)
        plot(means(session,:),'b--.','LineWidth',1,'MarkerSize',20,'Color','k')
        tix=get(gca,'xtick')';
        set(gca,'xticklabel',num2str(tix,'%.1f'))
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        set(gca,'xtick',[])
        switch session
            case 1
                ylabel(['A ' num2str(subject)])
                hold on; plot(-1:6, mean([ALPHA_cal(1,1) ALPHA_cal(1,3)])*ones(1,8),'b','Linewidth',1)
            case 4
                hold on; plot(-1:6, mean([ALPHA_cal(2,1) ALPHA_cal(2,3)])*ones(1,8),'r','LineWidth',1)
        end
        xlim([0.9,5.1])
        ylim([minVal-0.1 maxVal+0.1])
    end
end

% FC individual means across sessions

fcs = [3,5,6,9];
%figure
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'.mat'));
    load(strcat('Subject_',num2str(fcs(subject)),'_baseline.mat'))
    if subject == 2
        WND_plot = WND_total;
    end
    means = squeeze(mean(WND_plot,2));
    maxVal = max(max(max(means)),max(mean([WND(:,1) WND(:,3)],2))); 
    minVal = min(min(min(means)),min(mean([WND(:,1) WND(:,3)],2)));
    for session=1:4
        subplot(8,4,16 + (subject-1)*4 + session)
        plot(means(session,:),'b--.','LineWidth',1,'MarkerSize',20,'Color','k')
        switch session
            case 1
                ylabel(['FC ' num2str(subject)])
                hold on; plot(-1:6, mean([WND(1,1) WND(1,3)])*ones(1,8),'b','Linewidth',1)
            case 4
                hold on; plot(-1:6, mean([WND(2,1) WND(2,3)])*ones(1,8),'r','LineWidth',1)
        end
        xlim([0.9,5.1])
        ylim([minVal-0.1 maxVal+0.1])
        yticks(round(minVal)-0.5:1:round(maxVal)+0.5)
    end
end
%% switch it up

alphas = [2,4,7,8];
figure
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_fc.mat'));
    load(strcat('Subject_',num2str(alphas(subject)),'_baseline.mat'))
    if subject == 1
        WND_plot = WND_total;
    end
    means = squeeze(mean(WND_plot,2));
    maxVal = max(max(max(means))); 
    minVal = min(min(min(means)));
    for session=1:4
        subplot(8,4,(subject-1)*4 + session)
        plot(means(session,:),'b--.','LineWidth',1,'MarkerSize',20,'Color','k')
        tix=get(gca,'xtick')';
        set(gca,'xticklabel',num2str(tix,'%.1f'))
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        set(gca,'xtick',[])
        switch session
            case 1
                ylabel(['A ' num2str(subject)])
        end
        xlim([0.9,5.1])
        ylim([minVal-0.1 maxVal+0.1])
    end
end


fcs = [3,5,6,9];
%figure
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'_alpha.mat'));
    load(strcat('Subject_',num2str(fcs(subject)),'_baseline.mat'))
    if subject == 2
        ALPHA_plot = [alpha11; ALPHA_plot(1,:,:); alpha33; ALPHA_plot(2,:,:)];
    end
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(max(max(means))); 
    minVal = min(min(min(means)));
    for session=1:4
        subplot(8,4,16 + (subject-1)*4 + session)
        plot(means(session,:),'b--.','LineWidth',1,'MarkerSize',20,'Color','k')
        switch session
            case 1
                ylabel(['FC ' num2str(subject)])
        end
        xlim([0.9,5.1])
        ylim([minVal-0.1 maxVal+0.1])
        yticks(round(minVal)-0.5:1:round(maxVal)+0.5)
    end
end

%% 1 way anova (comparison of sets within each session)

[MULT_A_1,MULT_FC_1] = anova1_2();
P_SW = briefstats();
%% Boxplots with significant differences
% alpha
figure
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_IAB.mat'));
    if subject == 1
        ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha33; ALPHA_plot(3,:,:)];
    end
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(max(max(ALPHA_plot(:)))); 
    minVal = min(min(min(ALPHA_plot(:))));
    for session=1:4
        rows = find(MULT_A_1(:,end,subject,session)<0.05);
        stars={};
        for significant=1:length(rows)
            sets = MULT_A_1(rows(significant),1:2,subject,session);
            stars{significant} = sets; 
        end
        sub = subplot(4,4,(subject-1)*4 + session);
        pos = get(sub,'Position');
        boxplot(squeeze(ALPHA_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        sigstar(stars,[])    
        hold on; plot([1 2 3 4 5],means(session,:),'*')
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        if session==1
            ylabel(['A ' num2str(subject)])
        end
        xlim([0.5,5.5])
        ylim([minVal-0.1 maxVal+0.3])
        set(sub,'Position',pos)
    end
end
% connectivity
fcs = [3,5,6,9];
figure
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'_IAB.mat'));
    if subject == 2
       WND_plot = WND_total;
    end
    means = squeeze(mean(WND_plot,2));
    maxVal = max(max(max(WND_plot(:)))); 
    minVal = min(min(min(WND_plot(:))));
    for session=1:4
        rows = find(MULT_FC_1(:,end,subject,session)<0.05);
        stars={};
        for significant=1:length(rows)
            sets = MULT_FC_1(rows(significant),1:2,subject,session);
            stars{significant} = sets; 
        end
        sub = subplot(4,4,(subject-1)*4 + session);
        pos = get(sub,'Position');
        boxplot(squeeze(WND_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        axis tight
        sigstar(stars,[])    
        hold on; plot([1 2 3 4 5],means(session,:),'*')
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        if session==1
            ylabel(['FC ' num2str(subject)])
        end
        xlim([0.5,5.5])
        ylim([minVal-0.1 maxVal+0.5])
        set(sub,'Position',pos)
    end
end
%% Same but with significances from Wilcoxon Signed Rank
alphas = [2,4,7,8];
% alpha
figure
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_IAB.mat'));
    if subject == 1
        ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha33; ALPHA_plot(3,:,:)];
    end
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(max(max(ALPHA_plot(:)))); 
    minVal = min(min(min(ALPHA_plot(:))));
    for session=1:4
        rows = find(P_SW((subject-1)*4 + session,2:end,1)<0.05);
        stars={};
        for significant=1:length(rows)
            sets = [1 rows(significant)+1];
            stars{significant} = sets; 
        end
        sub = subplot(4,4,(subject-1)*4 + session);
        pos = get(sub,'Position');
        boxplot(squeeze(ALPHA_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        sigstar(stars,[])    
        hold on; plot([1 2 3 4 5],means(session,:),'*')
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        if session==1
            ylabel(['A ' num2str(subject)])
        end
        xlim([0.5,5.5])
        ylim([minVal-0.1 maxVal+0.3])
        set(sub,'Position',pos)
    end
end
% connectivity
fcs = [3,5,6,9];
figure
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'_IAB.mat'));
    if subject == 2
       WND_plot = WND_total;
    end
    means = squeeze(mean(WND_plot,2));
    maxVal = max(max(max(WND_plot(:)))); 
    minVal = min(min(min(WND_plot(:))));
    for session=1:4
        rows = find(P_SW((subject-1)*4 + session,2:end,2)<0.05);
        stars={};
        for significant=1:length(rows)
            sets = [1 rows(significant)+1];
            stars{significant} = sets; 
        end
        sub = subplot(4,4,(subject-1)*4 + session);
        pos = get(sub,'Position');
        boxplot(squeeze(WND_plot(session,:,:)), 'Labels',{'Set 1','Set 2','Set 3','Set 4','Set 5'})
        axis tight
        sigstar(stars,[])    
        hold on; plot([1 2 3 4 5],means(session,:),'*')
        if subject == 1
            title(['Session ' num2str(session)]) 
        end
        if session==1
            ylabel(['FC ' num2str(subject)])
        end
        xlim([0.5,5.5])
        ylim([minVal-0.1 maxVal+0.5])
        set(sub,'Position',pos)
    end
end

%% means across sessions
clear
maxVal = 0;
minVal = 100;
alphas = [2,4,7,8];
fcs = [3,5,6,9];
colors = [0 0.4470 0.7410;
          0.8500 0.3250 0.0980;
          0.9290 0.6940 0.1250
          0.4660 0.6740 0.1880];
figure
subplot(1,2,1)
title('Alpha')
l={};
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_IAB.mat'));
    if subject == 1
        ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha33; ALPHA_plot(3,:,:)];
    end
    ALPHA_plot = reshape(ALPHA_plot,[4,30]);
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(maxVal,max(means)); 
    minVal = min(minVal,min(means));    
    plot(means,'b--.','LineWidth',2,'MarkerSize',20,'Color',colors(subject,:))
    title('Alpha')
    l = [l {['Subject A' num2str(subject)]}];
    %set(gca,'xtick',[])
    xticklabels({'S1','S2','S3','S4'})
    xlim([0.9,4.1])
    ylim([minVal-0.1 maxVal+0.2])
    ylabel('RAUA')
    hold on;
end
legend(l)
set(gca,'fontsize', 15)
subplot(1,2,2)
maxVal = 0;
minVal = 0;

l={};
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'_IAB.mat'));
    if subject == 2
        WND_plot = WND_total;
    end
    WND_plot = reshape(WND_plot,[4,30]);
    means = squeeze(mean(WND_plot,2));
    maxVal = max(maxVal,max(means)); 
    minVal = min(minVal,min(means));    
    plot(means,'b--.','LineWidth',2,'MarkerSize',20,'Color',colors(subject,:))
    title('Connectivity')
    l = [l {['Subject FC' num2str(subject)]}];
    %set(gca,'xtick',[])
    xticklabels({'S1','S2','S3','S4'})
    xlim([0.9,4.1])
    ylim([minVal-0.1 maxVal+1.5])
    ylabel('WND')
    hold on;
end
legend(l)
set(gca,'fontsize', 15)
%% means accross sets
clear
maxVal = 0;
minVal = 100;
alphas = [2,4,7,8];
fcs = [3,5,6,9];
colors = [0 0.4470 0.7410;
          0.8500 0.3250 0.0980;
          0.9290 0.6940 0.1250
          0.4660 0.6740 0.1880];
figure
subplot(1,2,1)
l={};
for subject=1:4
    load(strcat('Subject_',num2str(alphas(subject)),'_IAB.mat'));
    if subject == 1
        ALPHA_plot = [ALPHA_plot(1:2,:,:); alpha33; ALPHA_plot(3,:,:)];
    end
    temp = [];
    for set=1:5
        a_set = ALPHA_plot(:,:,1);
        temp = [temp; a_set(:)];
    end
    ALPHA_plot = temp;
    means = squeeze(mean(ALPHA_plot,2));
    maxVal = max(maxVal,max(means)); 
    minVal = min(minVal,min(means));    
    plot(means,'b--.','LineWidth',2,'MarkerSize',20,'Color',colors(subject,:))
    title('Alpha')
    l = [l {['Subject A' num2str(subject)]}];
    ylabel('RAUA')
    xlim([0.9,5.1])
    ylim([minVal+0.2 maxVal+0.2])
    hold on;
end
legend(l)
%set(gca,'fontsize', 15)
xticklabels({'set1','set2','set3','set4','set5'})
subplot(1,2,2)
l={}
maxVal = 0;
minVal = 0;
for subject=1:4
    load(strcat('Subject_',num2str(fcs(subject)),'_IAB.mat'));
    if subject == 2
        WND_plot = WND_total;
    end
    temp = [];
    for set=1:5
        a_set = WND_plot(:,:,1);
        temp = [temp; a_set(:)];
    end
    WND_plot = temp;
    means = squeeze(mean(WND_plot,2));
    maxVal = max(maxVal,max(means)); 
    minVal = min(minVal,min(means));    
    plot(means,'b--.','LineWidth',2,'MarkerSize',20,'Color',colors(subject,:))
    title('Connectivity')
    l = [l {['Subject FC' num2str(subject)]}];
    ylabel('WND')
    xlim([0.9,5.1])
    ylim([minVal+0.5 maxVal+1.4])
    hold on;
end
legend(l)
%set(gca,'fontsize', 15)
xticklabels({'set1','set2','set3','set4','set5'})

%% Boxplots of all subjects together
% fc
clear 
load Subject_2_IAB.mat; A_1_r = ALPHA_plot; a3 = alpha33;
load Subject_4_IAB.mat; A_2   = ALPHA_plot;
load Subject_7_IAB.mat; A_3   = ALPHA_plot;
load Subject_8_IAB.mat; A_4   = ALPHA_plot;

load Subject_3_IAB.mat; FC_1 = WND_plot;
load Subject_5_IAB.mat; FC_2 = WND_total;
load Subject_6_IAB.mat; FC_3 = WND_plot;
load Subject_9_IAB.mat; FC_4 = WND_plot;

A_1 = [A_1_r(1,:,:); A_1_r(2,:,:); a3; A_1_r(3,:,:)];
ALPHA_total = [ A_1   A_2   A_3   A_4   ];
FC_total    = [ FC_1  FC_2  FC_3  FC_4  ];
figure;


minVal = min(min(min(FC_total)));
maxVal = max(max(max(FC_total)));
means = squeeze(mean(FC_total,2));
positions = [1 2 3 4 5 7 8 9 10 11 13 14 15 16 17 19 20 21 22 23];
boxplot([squeeze(FC_total(1,:,:)) squeeze(FC_total(2,:,:)) squeeze(FC_total(3,:,:)) squeeze(FC_total(4,:,:))],'Positions',positions)
title('Functional Connectivity')
ylabel('WND')
%plot(1:20,[means(1,:) means(2,:) means(3,:) means(4,:) ],'*')
%legend('mean')
ylim([minVal-0.1 maxVal-2])
set(gca,'TickLength',[0 0])
xticklabels({'','','Session 1','','','','','Session 2','','','','','Session 3','','','','','Session 4','','','','','Session 5','',''})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'fontsize',15)
%%

figure;
minVal = min(min(min(ALPHA_total)));
maxVal = max(max(max(ALPHA_total)));
means = squeeze(mean(ALPHA_total,2));

boxplot([squeeze(ALPHA_total(1,:,:)) squeeze(ALPHA_total(2,:,:)) squeeze(ALPHA_total(3,:,:)) squeeze(ALPHA_total(4,:,:))],'Positions',positions)
title('Alpha')
ylabel('RAUA')
%plot(1:20,[means(1,:) means(2,:) means(3,:) means(4,:) ],'*')
%legend('mean')
ylim([minVal+0.4 maxVal+0.1])
set(gca,'TickLength',[0 0])
xticklabels({'','','Session 1','','','','','Session 2','','','','','Session 3','','','','','Session 4','','','','','Session 5','',''})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a)
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
set(gca,'fontsize',15)
%%

%alpha
figure;
minVal = min(min(min(ALPHA_total)));
maxVal = max(max(max(ALPHA_total)));
means = squeeze(mean(ALPHA_total,2));
boxplot([squeeze(ALPHA_total(1,:,:)) squeeze(ALPHA_total(2,:,:)) squeeze(ALPHA_total(3,:,:)) squeeze(ALPHA_total(4,:,:))],'Positions',positions)
hold on
%plot(1:20,[means(1,:) means(2,:) means(3,:) means(4,:) ],'*')
%legend('mean')
ylim([minVal maxVal])
set(gca,'TickLength',[0 0])
xticklabels({'','','Session 1','','','','','Session 2','','','','','Session 3','','','','','Session 4','','','','','Session 5','',''})
hold on

%% Specificity of training
%% Other frequency bands
%% Intras
figure;

% INTRA1
subplot(3,2,1)
minVal = -0.4;%min(min(INTRA1(3,:)));
maxVal = 0.4;%max(max(INTRA1(1,:)));
%title('INTRA1')
%subplot(1,2,1)
boxplot([INTRA1(3,:); INTRA1(1,:); INTRA1(4,:)]','Labels',{char(952),'UA',char(946)}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.02 maxVal+0.01])
ylabel('Intra1')
title('Alpha')
%minVal = min(min(INTRA1(7,:)));
%maxVal = max(max(INTRA1(6,:)));
subplot(3,2,2)
boxplot([INTRA1(7,:,:); INTRA1(6,:); INTRA1(8,:,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.1 maxVal+0.1])
title('Functional Connectivity')


% INTRA2
subplot(3,2,3)
%minVal = min(min(INTRA2(3,:)));
%maxVal = max(max(INTRA2(1,:)));
%title('INTRA2')
%subplot(1,2,1)
boxplot([ INTRA2(3,:); INTRA2(1,:); INTRA2(4,:)]','Labels',{char(952),'UA',char(946)}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.01])
ylabel('Intra2')
%title('INTRA2 - Alpha group')
%minVal = min(min(INTRA2(7,:)));
%maxVal = max(max(INTRA2(6,:)));
subplot(3,2,4)
boxplot([INTRA2(7,:); INTRA2(6,:); INTRA2(8,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
%title('INTRA2 - Connectivity group')


% INTRAS
subplot(3,2,5)
%minVal = min(min(INTRAS(3,:)));
%maxVal = max(max(INTRAS(1,:)));
%title('INTRAS')
%subplot(3,2,1)
boxplot([INTRAS(3,:); INTRAS(1,:); INTRAS(4,:)]','Labels',{char(952),'UA',char(946)}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
ylabel('IntraS')
%title('INTRAS - Alpha group')
%minVal = min(min(INTRAS(7,:)));
%maxVal = max(max(INTRAS(6,:)));
subplot(3,2,6)
boxplot([INTRAS(7,:); INTRAS(6,:); INTRAS(8,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
%set(gca,'xticklabel',num2str(get(gca,'xtick')','%.1f'))
%set(gca,'fontsize',15)
%title('INTRAS - Connectivity group')

%% significances
H = [];
P = [];
ALLINTRA = [];
ALLINTRA(:,:,1)=INTRA1;
ALLINTRA(:,:,2)=INTRA2;
ALLINTRA(:,:,3)=INTRAS;
for i=1:3
    for j=1:8
        [P(i,j),H(i,j)] = signrank(ALLINTRA(j,:,i),0,'tail','right');
    end
end

%% Inters
figure;

% INTER1
subplot(3,2,1)
minVal = min(min(INTER1(3,:)));
maxVal = max(max(INTER1(3,:)));
%title('INTRA1')
%subplot(1,2,1)
boxplot([INTER1(3,:); INTER1(1,:); INTER1(4,:)]','Labels',{char(952),'UA',char(946)}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.02 maxVal+0.01])
ylabel('Inter1')
title('Alpha')
minVal = min(min(INTER1(7,:)));
maxVal = max(max(INTER1(6,:)));
subplot(3,2,2)
boxplot([INTER1(7,:,:); INTER1(6,:); INTER1(8,:,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.1 maxVal+0.1])
title('Functional Connectivity')


% INTER2
subplot(3,2,3)
minVal = min(min(INTER2(4,:)));
maxVal = max(max(INTER2(3,:)));
%title('INTRA2')
%subplot(1,2,1)
boxplot([ INTER2(3,:); INTER2(1,:); INTER2(4,:)]','Labels',{char(952),'UA',char(946)})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.05])
ylabel('Inter2')
%title('INTRA2 - Alpha group')
minVal = min(min(INTER2(8,:)));
maxVal = max(max(INTER2(6,:)));
subplot(3,2,4)
boxplot([INTER2(7,:); INTER2(6,:); INTER2(8,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.03])
%title('INTRA2 - Connectivity group')


% INTERS
subplot(3,2,5)
minVal = min(min(INTERS(3,:)));
maxVal = max(max(INTERS(3,:)));
%title('INTRAS')
%subplot(3,2,1)
boxplot([INTERS(3,:); INTERS(1,:); INTERS(4,:)]','Labels',{char(952),'UA',char(946)})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
ylabel('InterS')
%title('INTRAS - Alpha group')
minVal = min(min(INTERS(7,:)));
maxVal = max(max(INTERS(6,:)));
subplot(3,2,6)
boxplot([INTERS(7,:); INTERS(6,:); INTERS(8,:)]','Labels',{['WND(',char(952),')'],'WND(UA)',['WND(',char(946),')']})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.03])
%set(gca,'xticklabel',num2str(get(gca,'xtick')','%.1f'))
%set(gca,'fontsize',15)
%title('INTRAS - Connectivity group')

%% significances
H = [];
P = [];
ALLINTER = [];
ALLINTER(:,:,1)=INTER1;
ALLINTER(:,:,2)=INTER1;
ALLINTER(:,:,3)=INTER1;
for i=1:3
    for j=1:8
        [P(i,j),H(i,j)] = signrank(ALLINTER(j,:,i));
    end
end
%% Oposite measure
%% Intras
figure;
% INTRA1
subplot(3,2,1)
minVal = min(min(INTRA1(1,:)));
maxVal = max(max(INTRA1(2,:)));
%title('INTRA1')
%subplot(1,2,1)
boxplot([INTRA1(1,:); INTRA1(2,:)]','Labels',{'UA','WND(UA)'}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.02 maxVal+0.01])
ylabel('Intra1')
title('Alpha')
minVal = min(min(INTRA1(7,:)));
maxVal = max(max(INTRA1(6,:)));
subplot(3,2,2)
boxplot([INTRA1(5,:); INTRA1(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.1 maxVal+0.1])
title('Functional Connectivity')


% INTRA2
subplot(3,2,3)
minVal = min(min(INTRA2(1,:)));
maxVal = max(max(INTRA2(2,:)));
%title('INTRA2')
%subplot(1,2,1)
boxplot([INTRA2(1,:); INTRA2(2,:)]','Labels',{'UA','WND(UA)'}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.01])
ylabel('Intra2')
%title('INTRA2 - Alpha group')
minVal = min(min(INTRA2(5,:)));
maxVal = max(max(INTRA2(6,:)));
subplot(3,2,4)
boxplot([INTRA2(5,:); INTRA2(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
%title('INTRA2 - Connectivity group')


% INTRAS
subplot(3,2,5)
minVal = min(min(INTRAS(3,:)));
maxVal = max(max(INTRAS(2,:)));
%title('INTRAS')
%subplot(3,2,1)
boxplot([INTRAS(1,:); INTRAS(2,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
ylabel('IntraS')
%title('INTRAS - Alpha group')
minVal = min(min(INTRAS(5,:)));
maxVal = max(max(INTRAS(6,:)));
subplot(3,2,6)
boxplot([INTRAS(5,:); INTRAS(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
%set(gca,'xticklabel',num2str(get(gca,'xtick')','%.1f'))
%set(gca,'fontsize',15)
%title('INTRAS - Connectivity group')

%% Inters

%% Intras
figure;
% INTER1
subplot(3,2,1)
minVal = min(min(INTER1(2,:)));
maxVal = max(max(INTER1(2,:)));
%title('INTRA1')
%subplot(1,2,1)
boxplot([INTER1(1,:); INTER1(2,:)]','Labels',{'UA','WND(UA)'}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.02 maxVal+0.01])
ylabel('Inter1')
title('Alpha')
minVal = min(min(INTER1(5,:)));
maxVal = max(max(INTER1(6,:)));
subplot(3,2,2)
boxplot([INTER1(5,:); INTER1(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.1 maxVal+0.1])
title('Functional Connectivity')


% INTER2
subplot(3,2,3)
minVal = min(min(INTER2(1,:)));
maxVal = max(max(INTER2(2,:)));
%title('INTRA2')
%subplot(1,2,1)
boxplot([INTER2(1,:); INTER2(2,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.03 maxVal+0.01])
ylabel('Inter2')
%title('INTRA2 - Alpha group')
minVal = min(min(INTER2(5,:)));
maxVal = max(max(INTER2(6,:)));
subplot(3,2,4)
boxplot([INTER2(5,:); INTER2(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.04 maxVal+0.02])
%title('INTRA2 - Connectivity group')


% INTERS
subplot(3,2,5)
minVal = min(min(INTERS(2,:)));
maxVal = max(max(INTERS(2,:)));
%title('INTRAS')
%subplot(3,2,1)
boxplot([INTERS(1,:); INTERS(2,:)]','Labels',{'UA','WND(UA)'}) 
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
ylabel('InterS')
%title('INTRAS - Alpha group')
minVal = min(min(INTERS(6,:)));
maxVal = max(max(INTERS(6,:)));
subplot(3,2,6)
boxplot([INTERS(5,:); INTERS(6,:)]','Labels',{'UA','WND(UA)'})
hold on; plot(-10:10,zeros(1,21),'--','Color','b')
ylim([minVal-0.01 maxVal+0.01])
%set(gca,'xticklabel',num2str(get(gca,'xtick')','%.1f'))
%set(gca,'fontsize',15)
%title('INTRAS - Connectivity group')

%% Working memory
%% all

acc_pre_a  = [1 0.95 0.6 0.85; 1 0.925 0.8 0.9]; 
acc_pre_fc = [0.9 0.95 0.7 0.85; 0.7 0.95 0.4 0.775; 0.7 0.975 0.3 0.95];
rti_pre_a  = [876 827 675 842; 508 501 582 619];
rti_pre_fc = [838 762 1105 997; 649 691 700 668; 660 374 616 574];
acc_pos_a  = [1 0.975 0.3 0.925; 1 1 0.8 0.95];
acc_pos_fc = [1 0.95 0.8 0.85; 0.9 1 0.7 0.9; 0.8 0.975 0.2 0.925];
rti_pos_a  = [850.5 1149 800 922; 455 0 178.63 674]; 
rti_pos_fc = [926 759 936 954; 682 0 795 1045; 494 496 1102 803];

acc_pre = [acc_pre_a; acc_pre_fc];
rti_pre = [rti_pre_a; rti_pre_fc];
acc_pos = [acc_pos_a; acc_pos_fc];
rti_pos = [rti_pos_a; rti_pos_fc];

figure;
subplot(1,2,1)
positions = [1 2 4 5 7 8 10 11];
boxplot([acc_pre(:,1) acc_pos(:,1) acc_pre(:,2) acc_pos(:,2) acc_pre(:,3) acc_pos(:,3) acc_pre(:,4) acc_pos(:,4)],'Positions',positions)
ylim([0.1,1.3])
labels={'pre','pos','pre','pos','pre','pos','pre','pos','pre','pos'};
set(gca,'XTickLabel',labels)

colors = [0      0.4470 0.7410;
          0.8500 0.3250 0.0980;
          0.9290 0.6940 0.1250;
          0.4660 0.6740 0.1880];

a=get(get(gca,'children'),'children');
t=get(a,'tag');
box1=a(17);
set(box1,'Color',colors(1,:));
median=a(9);
set(median,'Color',colors(1,:));
box1=a(18);
set(box1,'Color',colors(1,:));
median=a(10);
set(median,'Color',colors(1,:));

box1=a(19);
set(box1,'Color',colors(2,:));
median=a(11);
set(median,'Color',colors(2,:));
box1=a(20);
set(box1,'Color',colors(2,:));
median=a(12);
set(median,'Color',colors(2,:));

box1=a(21);
set(box1,'Color',colors(3,:));
median=a(13);
set(median,'Color',colors(3,:));
box1=a(22);
set(box1,'Color',colors(3,:));
median=a(14);
set(median,'Color',colors(3,:));

box1=a(23);
set(box1,'Color',colors(4,:));
median=a(15);
set(median,'Color',colors(4,:));
box1=a(24);
set(box1,'Color',colors(4,:));
median=a(16);
set(median,'Color',colors(4,:));
legend([a(23),a(21),a(19),a(17)],'target N-2','distractor N-2','target N-3','distractor N-3')
title('Accuracy')
subplot(1,2,2)
positions = [1 2 4 5 7 8 10 11];
boxplot([rti_pre(:,1) rti_pos(:,1) rti_pre(:,2) rti_pos(:,2) rti_pre(:,3) rti_pos(:,3) rti_pre(:,4) rti_pos(:,4)],'Positions',positions)
ylim([-10 1600])
labels={'pre','pos','pre','pos','pre','pos','pre','pos','pre','pos'};
set(gca,'XTickLabel',labels)

colors = [0      0.4470 0.7410;
          0.8500 0.3250 0.0980;
          0.9290 0.6940 0.1250;
          0.4660 0.6740 0.1880];

a=get(get(gca,'children'),'children');
t=get(a,'tag');
box1=a(17);
set(box1,'Color',colors(1,:));
median=a(9);
set(median,'Color',colors(1,:));
box1=a(18);
set(box1,'Color',colors(1,:));
median=a(10);
set(median,'Color',colors(1,:));

box1=a(19);
set(box1,'Color',colors(2,:));
median=a(11);
set(median,'Color',colors(2,:));
box1=a(20);
set(box1,'Color',colors(2,:));
median=a(12);
set(median,'Color',colors(2,:));

box1=a(21);
set(box1,'Color',colors(3,:));
median=a(13);
set(median,'Color',colors(3,:));
box1=a(22);
set(box1,'Color',colors(3,:));
median=a(14);
set(median,'Color',colors(3,:));

box1=a(23);
set(box1,'Color',colors(4,:));
median=a(15);
set(median,'Color',colors(4,:));
box1=a(24);
set(box1,'Color',colors(4,:));
median=a(16);
set(median,'Color',colors(4,:));

legend([a(23),a(21),a(19),a(17)],'target N-2','distractor N-2','target N-3','distractor N-3')
title('Reaction times')
%% Separate by group

figure;
subplot(1,2,1)
scatter([1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8],[acc_pre_a(:,1)' acc_pos_a(:,1)' acc_pre_a(:,2)' acc_pos_a(:,2)' acc_pre_a(:,3)' acc_pos_a(:,3)' acc_pre_a(:,4)' acc_pos_a(:,4)'],'filled')
labels={'pre','pos','pre','pos','pre','pos','pre','pos','pre','pos'};
set(gca,'XTickLabel',labels)

subplot(1,2,2)
scatter([1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7 8 8 8],[acc_pre_fc(:,1)' acc_pos_fc(:,1)' acc_pre_fc(:,2)' acc_pos_fc(:,2)' acc_pre_fc(:,3)' acc_pos_fc(:,3)' acc_pre_fc(:,4)' acc_pos_fc(:,4)'],'filled')
labels={'pre','pos','pre','pos','pre','pos','pre','pos','pre','pos'};
set(gca,'XTickLabel',labels)