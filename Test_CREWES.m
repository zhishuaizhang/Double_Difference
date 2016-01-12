clear all
close all
clc

% x=1:50:35000;
% vo=1800;c=.6;nrays=10;
% thetamin=5;thetamax=80;
% deltheta=(thetamax-thetamin)/nrays;
% zraypath=zeros(nrays,length(x));
% for k=1:nrays
%     
%     theta=thetamin+(k-1)*deltheta;
%     p=sin(pi*theta/180)/vo;
%     cs=cos(pi*theta/180);
%     z = (sqrt( 1/(p^2*c^2) - (x-cs/(p*c)).^2) -vo/c);
%     ind=find(imag(z)~=0.0);
%     
%     if(~isempty(ind))
%         z(ind)=nan*ones(size(ind));
%     end
%     ind=find(real(z)<0.);
%     if(~isempty(ind))
%         z(ind)=nan*ones(size(ind));
%     end
%     zraypath(k,:) = real(z);
% end
% 
% figure;plot(x/1000,zraypath/1000);flipy;
% xlabel('x kilometers');ylabel('z kilometers')

%%

% zp=0:10:4000;vp=1800+.6*zp;vs=.5*vp;zs=zp;
% xoff=1000:100:3000;
% caprad=10;itermax=4;%cap radius, and max iter
% pfan=-1;optflag=1;pflag=1;dflag=2;% default ray fan, and various
% 
% raycode=[0 1;1500 1;1300 1;2000 1;1800 1;3000 1;2000 1;2300 1;1000 1; 1500 1; 0 1];
% figure;subplot(2,1,1);flipy
% [t,p]=traceray(vp,zp,vs,zs,raycode,xoff,caprad,pfan,itermax,optflag,pflag,dflag);
% title('A P-P-P-P-P-P-P-P-P-P mode in vertical gradient media');
% xlabel('meters');ylabel('meters')
% line(xoff,zeros(size(xoff)),'color','b','linestyle','none','marker','v')
% line(0,0,'color','r','linestyle','none','marker','*');grid
% subplot(2,1,2);plot(xoff,t);
% grid;flipy;xlabel('offset');ylabel('time')
% 
% raycode=[0 1;1500 2;1300 2;2000 2;1800 2;3000 1;2000 1;2300 1;1000 1; 1500 2; 0 1];
% figure;subplot(2,1,1);flipy
% [t,p]=traceray(vp,zp,vs,zs,raycode,xoff,caprad,pfan,itermax,optflag,pflag,dflag);
% title('A P-S-S-S-S-P-P-P-P-S mode in vertical gradient media');
% xlabel('meters');ylabel('meters')
% line(xoff,zeros(size(xoff)),'color','b','linestyle','none','marker','v')
% line(0,0,'color','r','linestyle','none','marker','*');grid
% subplot(2,1,2);plot(xoff,t);
% grid;flipy;xlabel('offset');ylabel('time')

%%

zp = -1000 : 10 : 4000  ;
vp = 1800 + .6 * zp ;
vs = .5 * vp        ;
zs = zp             ;


%define the ray code for a pure P multiple
raycode=[  2000 1 ;
           1500 1 ;
           1300 1 ;
           2000 1 ;
           1800 1 ;
           3000 1 ;
           2000 1 ;
           2300 1 ;
           1000 1 ;
           1500 1 ; 
           -300 1   ];
      
figure ;
subplot(2,1,1) ;
flipy
%trace the rays
xoff = 1000 : 100 : 3000 ;
[ t, p ] = traceray( vp , zp , vs , zs , raycode , xoff , 10 , -1 , 10 , 1 , 1 , 2 ) ;
%Source and receiver symbols
line(xoff,raycode(end,1)*ones(size(xoff)),'color','b','linestyle','none','marker','v')
line(0,raycode(1,1),'color','r','linestyle','none','marker','*')
%annotate
title('A P-P-P-P-P-P-P-P-P-P mode in vertical gradient media');grid
%Plot traveltimes
subplot(2,1,2);flipy
plot(xoff,t);grid;xlabel('offset');ylabel('time')
xlim([0 3000])

%define the ray code for a P-S multimode
raycode=[0 1;1500 2;1300 2;2000 2;1800 2;3000 1;2000 1;2300 1;1000 1;...
			 1500 2; 300 1];
figure;subplot(2,1,1);flipy
%trace the rays
xoff=1000:100:3000;
[t,p]=traceray(vp,zp,vs,zs,raycode,xoff,10,-1,10,1,1,2);
%source and receiver symbols
line(xoff,raycode(end,1)*ones(size(xoff)),'color','b','linestyle','none','marker','v')
line(0,raycode(1,1),'color','r','linestyle','none','marker','*')
%annotate
title('A P-S-S-S-S-P-P-P-P-S mode in vertical gradient media');grid
%Plot traveltimes
subplot(2,1,2);flipy
plot(xoff,t);grid;xlabel('offset');ylabel('time')
xlim([0 3000])

pos=get(gcf,'position');
set(gcf,'position',[1.1*pos(1) .9*pos(2) pos(3:4)])

