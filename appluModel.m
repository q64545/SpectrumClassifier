function spectrumTag=applyModel(json)
%º¯ÊýµÄÖ÷Òª×÷ÓÃÎªÓŠÓÃÄ£ÐÍ£¬ÊäÈëÎªÓÃ»§ÊýŸÝµÄjsonžñÊœ£¬²¢ÇÒÊäÈëµÄjson×Ö·ûŽ®±ØÐëÊÇ[234.34,234.3.3453.35,234,3453,...]ÕâÖÖÐÎÊœ
%%
%Œì²âjsonÊÇ·ñžñÊœÕýÈ·
if isa(json,'char') == 0
    fprintf('The input is not a json format\n');
    spectrumTag=-1;
    return;
end
%%
%ÏÈ¶ÁÈ¡±ŸµØÄ£ÐÍ
load Model;
%%
%œ«jsonžñÊœ×ª»»
    spectrumData=loadjson(json);
    if isa(spectrumData,'Double') == 0
        fprintf('The input is improper, It must be as a form of [Double,Double,Double]\n');
        spectrumTag=-1;
        return
    end
    figure;
    plot(spectrumData);
    %%
    %Ê×ÏÈœøÐÐÔ€ŽŠÀí
    %Æœ»¬
    spectrumData=smooth(spectrumData,25, 'lowess');
    figure;
    plot(spectrumData);
    %Çólog10
    spectrumData=log10(spectrumData);
    figure;
    plot(spectrumData);
    %ÇóµŒ
    spectrumData=diff(spectrumData);
    figure;
    plot(spectrumData);
    %mscÐ£Õý
    spectrumData=spectrumData';
    spectrumData=msc(spectrumData,idealSpectra);
    figure;
    plot(spectrumData);
    %¹éÒ»»¯
    spectrumData_scale=mapminmax('apply', spectrumData', ps);
    spectrumData_scale=spectrumData_scale';
    %%
    %Ê¹ÓÃÄ£ÐÍœøÐÐ·ÖÀà
    [predict_label, acc, prob] = svmpredict(0,spectrumData_scale,spectrumClassModel, [' -b ', num2str(1)]);
    spectrumTag=predict_label;
%%
    %ÅÐ¶ÏÊÇ·ñÎª¿ÉÊ¶±ð¹âÆ×
    if max(prob) < 0.85
        spectrumTag = -1;
    end
end
