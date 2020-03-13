function y = test(varargin)
for i = 1:length(varargin)
    disp('this is i')
    disp(i) 
    for ii = 1:length(varargin(i))
        disp ('this is ii')
        disp (ii)
        disp (num2str(ii))
    end
end
