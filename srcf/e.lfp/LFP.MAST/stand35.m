function varargout = stand35 (varargin)
for i = 1:length(varargin)
    LFPvarargout(i)= varargin(i);
    disp(i)
    x = varargin{i}(1:100,:)
    disp ('this is the first 5 lines of x at')
    disp (i)
    disp (x(1:5,:))
    %disp(x(1:100,:))
    
    varargout{i} = x
end
end 