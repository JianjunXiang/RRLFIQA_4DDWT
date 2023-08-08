function [d]=convndcut(x,s,y,c)
%Almost same as convnd, 
%but add the ability to select center part of conv result.
%[D]=CONVND(X,S,Y,C)
%X is N-D array
%S is the dimension you want to conv
%Y is a vector to conv
%C is output's length in the s dimension

t=size(x);
if s>length(t), error('s can''t bigger than the dimensions of x.'), end;
x=shiftdim(x,s-1);
z=x(:,:); sz=size(z); 
if nargin>3
   first=fix((sz(1)+length(y)-1-c)/2);
   d=zeros(c,sz(2));
else
   first=0;
   c=sz(1)+length(y)-1;
   d=zeros(c,sz(2));
end
for i=1:size(z,2)
   g=conv(z(:,i)',y);
   d(:,i)=g([first+1:first+c])';
end;
t2=[t(s:length(t)),t(1:s-1)]; t2(1)=size(d,1);
   
d=reshape(d,t2);
d=shiftdim(d,length(t)-(s-1));

%   
% Part of Multi-dimension Wavelet Toolbox Version 1.0
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail chen_fu@263.net
%   
