function plotClassROC(tag,prob,N)
%plotClassROC
%by Pan Zeng
%email:q64545@sina.com
%2015,11,4
%%
%tagÎª²âÊÔ±êÇ©(ÁÐÏòÁ¿)£¬probÎªÔ€²âµÄÃ¿Ò»ÀàµÄžÅÂÊ£¬NÎªROC»æÍŒãÐÖµ²ÉµãÊý£¬·¶Î§Îª[0,1]
%p_0ÎªãÐÖµ
p_0=linspace(0,1,N);
%ÏÈÇó³öÒ»¹²ÓÐ¶àÉÙÀà£¬ÓÃn±íÊŸ£¬²¢ÓÃprobClassi±íÊŸµÚiÀàµÄÑù±Ÿ·ÖÀàžÅÂÊ,tagi±íÊŸµÍiÀà±ŸµÄÕýÈ··ÖÀà
[l,n]=size(prob);
for i = 1:n
    eval(['probClass',num2str(i),'=prob(:,',num2str(i),');']);
    eval(['tag',num2str(i),'=tag;']);
    eval(['posed=find(tag',num2str(i),'==(',num2str(i),'-1));']);
    eval(['deposed=find(tag',num2str(i),'~=(',num2str(i),'-1));']);
    eval(['tag',num2str(i),'(posed)=1;']);
    eval(['tag',num2str(i),'(deposed)=0;']);
end
%œ«probClassiºÍtagiºÏ²¢
for i = 1:n
    eval(['probClass',num2str(i),'=[probClass',num2str(i),',tag',num2str(i),'];']);
end
figure;
%Çó³öN×é[FPR,TPR]
for i = 1:n
    for j = 1:N
        eval(['prePositive',num2str(j),'=find(probClass',num2str(i),'(:,1)>=p_0(j));']);
        eval(['preNegative',num2str(j),'=find(probClass',num2str(i),'(:,1)<p_0(j));']);
        eval(['TP(j)=length(find(probClass',num2str(i),'(prePositive',num2str(j),',2)==1));']);
        eval(['FP(j)=length(find(probClass',num2str(i),'(prePositive',num2str(j),',2)==0));']);
        eval(['FN(j)=length(find(probClass',num2str(i),'(preNegative',num2str(j),',2)==1));']);
        eval(['TN(j)=length(find(probClass',num2str(i),'(preNegative',num2str(j),',2)==0));']);
    end
    %ŒÆËãFPRºÍTPR
    for j = 1:N
        FPR(j)=FP(j)/(FP(j)+TN(j));
        TPR(j)=TP(j)/(TP(j)+FN(j));
    end
    %Çó³öÃ¿Ò»ÀàROCÇúÏßµÄAUC
    AUC(i)=0;
    for j = 1:N-1
        if TPR(j) > TPR(j+1)
            AUC(i)=AUC(i)+(abs(TPR(j)-TPR(j+1))/2+TPR(j+1))*(FPR(j)-FPR(j+1));
        else
            AUC(i)=AUC(i)+(abs(TPR(j)-TPR(j+1))/2+TPR(j))*(FPR(j)-FPR(j+1));
        end
    end
    
    %»­³öROCÇúÏß
    subplot(ceil(n/2),2,i);
    plot(FPR,TPR,'b-');
    eval(['title(''Class',num2str(i-1),' ROC curve'');']);
    xlabel('false positive rate');
    ylabel('true positive rate');
    hold on
    h=plot(FPR,FPR,':');
    set(h,'color',[96 96 96]/255);
end

disp(['AUC IS ', num2str(AUC)]);







