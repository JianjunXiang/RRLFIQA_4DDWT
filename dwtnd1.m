function [ca,cd] = dwtnd1(x,s,arg2,arg3)
%DWT Single-level discrete N-D wavelet transform in one dimension.
%Here x is a N-D array, and s is the dimension index you want to do DWT.
%[ca,cd] is the approximation coefficients vector CA and detail coefficients vector CD.
%arg2,arg3 is the same meaning as dwt and dwt2 in MATHWORKS wavelet toolbox.
%Two style is 
%       [CA,CD] = DWTND1(X,S,'wname') 
%       [CA,CD] = DWTND1(X,S,Lo_D,Hi_D) 

global DWT_Ext_Mode

if errargn(mfilename,nargin,[3:4],nargout,[0:2]), error('*'), end
if nargin == 3
        [LoF_D,HiF_D] = wfilters(arg2,'d');
else
        LoF_D = arg2;   HiF_D = arg3;
end
if  isempty(DWT_Ext_Mode) , DWT_Ext_Mode = 'zpd'; end

switch DWT_Ext_Mode
    case 'zpd'	% zpd is the default

        % Decomposition.
        ca = dyaddownnd(convndcut(x,s,LoF_D),s);
        cd = dyaddownnd(convndcut(x,s,HiF_D),s);

    case 'sym'

        % Symmetrization.
        lx = length(x);
        lf = length(LoF_D);
        if size(x,1)==1
                x = [x(lf:-1:1) x x(lx:-1:lx-lf+1)];
        else
                x = [x(lf:-1:1); x ; x(lx:-1:lx-lf+1)];
        end

        % Decomposition.
        la = floor((lx+lf-1)/2);
        ca  = dyaddownnd(convndcut(x,s,LoF_D,la),s);
        cd  = dyaddownnd(convndcut(x,s,HiF_D,la),s);

    case 'spd'

        % Smooth padding.
        lx = length(x);
        lf = length(LoF_D);
        if size(x,1)==1
                x = [zeros(1,lf) x zeros(1,lf)];
        else
                x = [zeros(lf,1); x ; zeros(lf,1)];
	end
	for k=lf:-1:1
                x(k) = 2*x(k+1)-x(k+2);
        end
        for k=lf+lx+1:lx+2*lf
                x(k) = 2*x(k-1)-x(k-2);
        end

        % Decomposition.
        la = floor((lx+lf-1)/2);
        ca  = dyaddownnd(convndcut(x,s,LoF_D,la),s);
        cd  = dyaddownnd(convndcut(x,s,HiF_D,la),s);

    otherwise
	errargt(mfilename,'Invalid Extension Mode for DWT!','msg');
        error('*')
end

%   
% Part of Multi-dimension Wavelet Toolbox Version 1.0
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail chen_fu@263.net
%   
