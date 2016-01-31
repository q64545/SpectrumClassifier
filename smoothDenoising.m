function [s_trainSample, s_testSample]=smoothDenoising(varargin)
%žÃº¯ÊýÓÐÁœÖÖÐÎÊœ
%function [s_trainSample, s_testSample]=smoothDenoising(s_trainSample, s_testSample, n,)
%function [s_trainSample, s_testSample]=smoothDenoising(s_trainSample, s_testSample, n, mode)
%žÃº¯Êý¿ÉÒÔÎªÃ¿Ò»ÐÐÑù±Ÿ×öÆœ»¬ŽŠÀí£¬Æœ»¬²œ³€n
if nargin == 3
    s_trainSample=varargin{1};
    s_testSample=varargin{2};
    n=varargin{3};
    [len1,wi] = size(s_trainSample);
    for i = 1:len1
        s_trainSample(i,:)=smooth(s_trainSample(i,:),n);
    end
    [len2,wi] = size(s_testSample);
    for i = 1:len2
        s_testSample(i,:)=smooth(s_testSample(i,:),n);
    end
elseif nargin == 4
    s_trainSample=varargin{1};
    s_testSample=varargin{2};
    n=varargin{3};
    mode=varargin{4};
    [len1,wi] = size(s_trainSample);
    for i = 1:len1
        s_trainSample(i,:)=smooth(s_trainSample(i,:),n, mode);
    end
    [len2,wi] = size(s_testSample);
    for i = 1:len2
        s_testSample(i,:)=smooth(s_testSample(i,:),n, mode);
    end
end
end
