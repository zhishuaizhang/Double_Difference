function Arrival_time = Calculate_arrival_time( Source_location , Receiver_location , Velocity_model )

zp = -1000 : 10 : 4000  ;
vp = 1800 * ones( size( zp) )  ;
vs = .5 * vp        ;
zs = zp             ;

Source_number   = size( Source_location   , 1 ) ;
Receiver_number = size( Receiver_location , 1 ) ;

Arrival_time = zeros( Source_number , Receiver_number ) ;

for jj = 1 : Receiver_number
    
    for ii = 1 : Source_number
        
        Offset = sqrt( sum((Source_location(ii,1:2) - Receiver_location(jj,1:2)).^2 ) ) ;
        
        raycode=[   Source_location(ii,3)   1 ;
                                     1000   1 ;
                  Receiver_location(jj,3)   1   ] ;
                      
        [ t , ~ ] = traceray( vp , zp , vs , zs , raycode , Offset , 10 , -1 , 10 , 1 , 1 , 0 ) ;
        
        Arrival_time( ii , jj ) = t + Source_location(ii,4) ;
        
    end
    
end


