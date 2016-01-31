function [spectrumClassModel,idealSpectra,ps]=trainSpectrumAndTest(s_trainSample,s_testSample)
%º¯ÊýÖ÷Òª×÷ÓÃÎªÑµÁ·Ä£ÐÍ£¬ÊäÈëÊÇÑµÁ·ÊýŸÝŒ¯ºÏ²âÊÔÊýŸÝŒ¯£¬ÆäÖÐÑµÁ·ÊýŸÝŒ¯ºÍ²âÊÔÊýŸÝŒ¯±ØÐëÊÇÐÐÊýŽú±íÑù±ŸÊýÁ¿£¬ÁÐÊýŽú±íÃ¿žöÑù±ŸµÄÌØÕ÷
%žÃº¯ÊýÊä³ö·ÖÀàÆ÷Ä£ÐÍ£¬mscÐ£ÕýËùÐèµÄ²Î¿Œ¹âÆ×ÒÔŒ°ÊýŸÝ¹éÒ»»¯Ä£ÐÍ
%%
    %œ«ÊýŸÝºÍ±êÇ©·ÖÀë£¬ÒÔ·œ±ãÊýŸÝ×öÏÂÃæµÄÔ€ŽŠ
    train_tag=s_trainSample(:,end);
    test_tag=s_testSample(:,end);
    s_trainSample(:,end)=[];
    s_testSample(:,end)=[];

    figure;
    plot([s_trainSample;s_testSample]');

%%
    %¶Ô¹âÆ×ÊýŸÝµÄÔ€ŽŠÀí²¿·Ö£º
    %œ«Ã¿žöÑù±Ÿ×öÆœ»¬ŽŠÀí
    [s_trainSample,s_testSample]=smoothDenoising(s_trainSample,s_testSample,25, 'lowess');
    figure;
    plot([s_trainSample;s_testSample]');

    %œ«¹âÆ×ÊýŸÝlog10ŽŠÀí
    s_trainSample=log10(s_trainSample);
    s_testSample=log10(s_testSample);
    figure;
    plot([s_trainSample;s_testSample]');

    %œ«Ã¿žöÑù±Ÿ×ª»»ÎªµŒÊýÐÎÊœ
    [s_trainSample,s_testSample]=derivating1(s_trainSample,s_testSample);
    figure;
    plot([s_trainSample;s_testSample]');

    %œ«¹âÆ×ÊýŸÝœøÐÐmsc(¶àÔªÉ¢ÉäÐ£Õý)ŽŠÀí
    idealSpectra=mean([s_trainSample;s_testSample]);
    s_trainSample=msc(s_trainSample,idealSpectra);
    s_testSample=msc(s_testSample,idealSpectra);
    figure;
    plot([s_trainSample;s_testSample]');

    %œ«Ñù±Ÿ±êÇ©ŒÓÉÏ
    s_trainSample=[s_trainSample,train_tag];
    s_testSample=[s_testSample,test_tag];

    %%
    %ÑµÁ·Ñù±Ÿ²¿·Ö
    %œ«ÑµÁ·Ñù±ŸºÍ²âÊÔÑù±Ÿ°þÀë±êÇ©²¢¹éÒ»»¯
    [m,n]=size(s_trainSample);
    [k,l]=size(s_testSample);
    s_train=s_trainSample(:,1:(n-1));
    s_train_label=s_trainSample(:,n);
    s_test=s_testSample(:,1:(l-1));
    s_test_label=s_testSample(:,l);
    [s_Norm,ps]=mapminmax([s_train;s_test]',-1,1);
    s_trainNorm=s_Norm(:,1:m)';
    s_testNorm=s_Norm(:,m+1:end)';

    %œ»²æÑéÖ€
    optc=0; %¶šÒå×îŒÑc
    optg=0; %¶šÒå×îŒÑg
    bestcv=0;%¶šÒå×îŒÑ×ŒÈ·ÂÊ
    for log2c =-6:6, 
      for log2g =-6:6,
            cmd = ['-v 3 ','-t ',num2str(0),' -c ',num2str(2^log2c),'-g ',num2str(2^log2g)];
            cv = svmtrain(s_train_label,s_trainNorm,cmd); 
           if(cv>bestcv),
               bestcv = cv; optc = 2^log2c; optg = 2^log2g;
           end
      end
    end
    fprintf('(optimal c = %g,g = %g,rate = %g)\n',optc,optg,bestcv); %Êä³öÑéÖ€Íê³ÉºóµÄ×îŒÑc¡¢g²ÎÊýºÍ¶ÔÓŠµÄ×îŒÑ×ŒÈ·ÂÊ
    disp('---------------------------------------------------------------------------------------');

    %Ê¹ÓÃLIBSVMœøÐÐÑµÁ·
    cmd = ['-t ',num2str(0),' -c ',num2str(optc),' -g ',num2str(optg), ' -b ', num2str(1)];
    model = svmtrain(s_train_label,s_trainNorm,cmd);
    %%
    %Ñù±Ÿ²âÊÔ²¿·Ö
    %SVMÍøÂç²âÊÔ
    [predict_label, acc, prob] = svmpredict(s_test_label,s_testNorm,model, [' -b ', num2str(1)]);

    %Çó³ö²âÊÔ×ŒÈ·ÂÊ£¬×îÖÕœá¹ûÒÑÕâžö×ŒÈ·ÂÊÎª×Œ
    Accuracy=length(find(~(predict_label-s_test_label)))/length(s_test_label);
    disp(['The Accuracy is ', num2str(Accuracy*100),'%']);
    
    %»­³ö4ÖÐÀà±ðµÄ·ÖÀàžÅÂÊ
    figure;
    subplot(2,2,1);plot(prob(:,1));title('class 0')
    subplot(2,2,2);plot(prob(:,2));title('class 1')
    subplot(2,2,3);plot(prob(:,3));title('class 2')
    subplot(2,2,4);plot(prob(:,4));title('class 3')

    figure;
    plot(s_test_label,'bo');
    hold on
    plot(predict_label,'r*');
    grid on
    legend('ÊµŒÊÀà±ð','Ô€²âÀà±ð');

    %»­³örocÍŒ
    plotClassROC(s_test_label,prob,30);
    %œ«ÑµÁ·Ñù±ŸºÍ²âÊÔÑù±ŸÒ»ÆðÑµÁ·Ò»žöÄ£ÐÍ
    model = svmtrain([s_train_label;s_test_label],[s_trainNorm;s_testNorm],cmd);
    %·µ»Ømodel
    spectrumClassModel=model;

end
