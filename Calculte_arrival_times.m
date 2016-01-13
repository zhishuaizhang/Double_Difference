function Arrival_times = Calculte_arrival_times( Sources , Receivers , Velocity_model ) 

Number_of_Sources   = length( Sources )   ;
Number_of_Receivers = length( Receivers ) ;

Arrival_times(1).Values = zeros( Number_of_Sources , Number_of_Receivers ) ;
Arrival_times(1).Phase  = 'P' ;

Arrival_times(2).Values = zeros( Number_of_Sources , Number_of_Receivers ) ;
Arrival_times(2).Phase  = 'S' ;

for jj = 1 : Number_of_Receivers
    
    for ii = 1 : Number_of_Sources
        
        Offset = sqrt( (Sources(ii).Easting  - Receivers(jj).Easting ).^2 + ...
                       (Sources(ii).Northing - Receivers(jj).Northing).^2 ) ;
                
        Raycode=[ -Sources(ii).Elevation    1 ;
                  -Receivers(jj).Elevation  1   ] ;
                      
        [ t , ~ ] = traceray( Velocity_model.Vp , -Velocity_model.Elevation , ...
                              Velocity_model.Vs , -Velocity_model.Elevation , ...
                              Raycode , Offset , 10 , -1 , 10 , 1 , 1 , 0 ) ;
        
        Arrival_times(1).Values( ii , jj ) = t + Sources(ii).Occurrence ;
        
        Raycode=[ -Sources(ii).Elevation    2 ;
                  -Receivers(jj).Elevation  2   ] ;
              
        [ t , ~ ] = traceray( Velocity_model.Vp , -Velocity_model.Elevation , ...
                              Velocity_model.Vs , -Velocity_model.Elevation , ...
                              Raycode , Offset , 10 , -1 , 10 , 1 , 1 , 0 ) ;
              
        Arrival_times(2).Values( ii , jj ) = t + Sources(ii).Occurrence ;
        
    end
    
end

