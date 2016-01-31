function [s_trainSample, s_testSample]=derivating1(s_trainSample, s_testSample)
%žÃº¯ÊýžùŸÝµŒÊýµÄ¶šÒåœ«Ã¿žöÑù±ŸµÄ¹âÆ×ÇúÏß×ª»»ÎªÆäµŒÊýÇúÏß
    [len1,wi1] = size(s_trainSample);
    for i = 1:len1
        s_trainSample_temp(i,:)=diff(s_trainSample(i,:));
    end
    s_trainSample=s_trainSample_temp;
    [len2,wi2] = size(s_testSample);
    for i = 1:len2
        s_testSample_temp(i,:)=diff(s_testSample(i,:));
    end
    s_testSample=s_testSample_temp;
end
