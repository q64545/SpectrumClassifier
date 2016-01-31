clc;
clear;
%³ÌÐòÈë¿Ú£¬Ö÷Òª×÷ÓÃÊÇ¶ÁÈ¡ŽæÔÚs1.xlsx,s2.xlsx,s3.xlsx,s4.xlsxÀïÃæµÄ¹âÆ×ÊýŸÝ£¬²¢×éÖ¯³ÉÑµÁ·ÊýŸÝŒ¯ºÍ²âÊÔÊýŸÝŒ¯


%%
%¶ÁÈ¡ÊýŸÝ²¿·Ö£º
%Ê×ÏÈœ«4ÖÖÀàÐÍµÄ¹âÆ×ÊýŸÝ·Ö±ð¶Á³öÀŽŽæÈës1,s2,s3,s4ËÄžöŸØÕóÖÐ
s1=xlsread('SpectrumData.xlsx',1);
s2=xlsread('SpectrumData.xlsx',2);
s3=xlsread('SpectrumData.xlsx',3);
s4=xlsread('SpectrumData.xlsx',4);
%œ«4ÖÐÀàÐÍµÄ¹âÆ×ÊýŸÝŽòÉÏ±êÇ©£¬·Ö±ðÎª0,1,2,3
[r1,c1]=size(s1);
[r2,c2]=size(s2);
[r3,c3]=size(s3);
[r4,c4]=size(s4);
s1=[s1;zeros(1,c1)];
s2=[s2;ones(1,c2)];
s3=[s3;2*ones(1,c3)];
s4=[s4;3*ones(1,c4)];
%ÔÚÃ¿ÖÖ¹âÆ×ÊýŸÝÖÐËæ»ú³éÈ¡10žöÑù±Ÿ×÷Îª²âÊÔÑù±Ÿ£¬ÆäÓàµÄ×÷ÎªÑµÁ·Ñù±Ÿ
%Ê×ÏÈÈ·¶šËæ»ú³éÈ¡10žöÑù±ŸµÄÐòºÅ
s1_rand=randperm(floor(c1*0.25));
s2_rand=randperm(floor(c2*0.25));
s3_rand=randperm(floor(c3*0.25));
s4_rand=randperm(floor(c4*0.25));
%œ«ÐòºÅÄÚµÄÑù±Ÿ³éÈ¡
s1_test=s1(:,s1_rand);
s1(:,s1_rand)=[];
s2_test=s2(:,s2_rand);
s2(:,s2_rand)=[];
s3_test=s3(:,s3_rand);
s3(:,s3_rand)=[];
s4_test=s4(:,s4_rand);
s4(:,s4_rand)=[];
%œ«ËùÓÐ²âÊÔÑù±ŸºÍÑµÁ·Ñù±Ÿ·ÅÔÚÒ»Æð
s_testSample=[s1_test,s2_test,s3_test,s4_test];
s_trainSample=[s1,s2,s3,s4];
s_trainSample=s_trainSample';
s_testSample=s_testSample';
%Œì²éÎÞÐ§ÊýŸÝ
s_trainSample(ceil(find(s_trainSample==16383)/length(s_trainSample)),:)=[];
s_testSample(ceil(find(s_testSample==16383)/length(s_testSample)),:)=[];

%%
%ÑµÁ·Ä£ÐÍ£¬ÆäÖÐspectrumClassModelÊÇ·ÖÀàÆ÷Ä£ÐÍ£¬idealSpectraÊÇÓÃÀŽ×ömscµÄ²Î¿Œ¹âÆ×£¬psÊÇÊýŸÝ¹éÒ»»¯Ä£ÐÍ
[spectrumClassModel,idealSpectra,ps]=trainSpectrumAndTest(s_trainSample,s_testSample);
%%
%œ«Ä£ÐÍ±£Žæ
save Model spectrumClassModel idealSpectra ps;












