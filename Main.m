clear all
close all
clc

Event_x   = 2 ;
Event_y   = 2 ;
Event_z   = 1 ;
Station_x = 2 ;
Station_y = 2 ;

Event_easting    = zeros( Event_x , Event_y , Event_z ) ;
Event_northing   = zeros( Event_x , Event_y , Event_z ) ;
Event_elevation  = zeros( Event_x , Event_y , Event_z ) ;
Event_occurrence = zeros( Event_x , Event_y , Event_z ) ;

for zz = 1:Event_z
    for yy = 1:Event_y
        for xx = 1:Event_x
            
            Event_easting(xx,yy,zz)    =  0.1 * ( xx - 1 ) + 2.5 ;
            Event_northing(xx,yy,zz)   =  0.1 * ( yy - 1 ) + 3.8 ;
            Event_elevation(xx,yy,zz)  = -1.5 + 0.1 * ( zz - 1 ) ;
            Event_occurrence(xx,yy,zz) = xx + yy + zz            ;
            
        end
    end
end

Station_easting   = zeros( Station_x , Station_y ) ;
Station_northing  = zeros( Station_x , Station_y ) ;
Station_elevation = zeros( Station_x , Station_y ) ;

for yy = 1:Station_y
    for xx = 1:Station_x
            
            Station_easting(xx,yy)   = 0.5 * xx ;
            Station_northing(xx,yy)  = 2.0 * yy ;
            Station_elevation(xx,yy) = 2.0      ;
            
    end
end

figure
scatter3( Event_easting(:) , Event_northing(:) , Event_elevation(:) , 10 , Event_occurrence(:) )
hold on
scatter3( Station_easting(:) , Station_northing(:) , Station_elevation(:) )
scatter3( Event_easting(1,1,1) , Event_northing(1,1,1) , Event_elevation(1,1,1) , 'filled' )

Receiver_location         = [ Station_easting(:)   , Station_northing(:)   , Station_elevation(:)   ] ;
Source_location_true      = [ Event_easting(:)     , Event_northing(:)     , Event_elevation(:)     , Event_occurrence(:)     ] ;
Source_location_reference = [ Event_easting(1,1,1) , Event_northing(1,1,1) , Event_elevation(1,1,1) , Event_occurrence(1,1,1) ] ;
Source_location_initial   = ones(size(Source_location_true,1),1) * Source_location_reference ;

Arrival_time           = Calculate_arrival_time( Source_location_true , Receiver_location )           ;
Arrival_time_reference = Calculate_arrival_time( Source_location_reference , Receiver_location ) ;

Difference_observe   = Arrival_time         - ones( size(Arrival_time,1) , 1 ) * Arrival_time_reference ;

Source_location = Source_location_initial ;

%%

tic

Arrival_time   = Calculate_arrival_time( Source_location , Receiver_location ) ;
Difference_calculate = Arrival_time - ones( size(Arrival_time,1) , 1 ) * Arrival_time_reference ;

Double_Difference = Difference_observe - Difference_calculate ;

G = zeros( length( Double_Difference(:) ) , length( Source_location(:) ) ) ;

for ii = 1 : length( Source_location(:) )
    
    Source_location_perturb = Source_location ;
    
    Source_location_perturb(ii) = 1.001*Source_location_perturb(ii) ;
    
    Arrival_time_perturb = Calculate_arrival_time( Source_location_perturb , Receiver_location ) ;
    
    G(:,ii) = ( Arrival_time_perturb(:) - Arrival_time(:) ) / 0.001 / Source_location(ii) ;

end

delta_m = G \ Double_Difference(:) ;

Source_location = Source_location + reshape( delta_m , size( Source_location ) ) ;

toc

figure
subplot(3,1,1)
scatter3( Source_location(:,1) , Source_location(:,2) , Source_location(:,3) , 10 , Source_location(:,4) )
subplot(3,1,2)
scatter3( Source_location_initial(:,1) , Source_location_initial(:,2) , Source_location_initial(:,3) , 10 , Source_location_initial(:,4) )
subplot(3,1,3)
scatter3( Source_location_true(:,1) , Source_location_true(:,2) , Source_location_true(:,3) , 10 , Source_location_true(:,4) )
