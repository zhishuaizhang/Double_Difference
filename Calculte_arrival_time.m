function Arrival_time = Calculte_arrival_time( Source , Receiver , Velocity_model , Phase ) 

Offset = sqrt( (Source.Easting  - Receiver.Easting ).^2 + ...
               (Source.Northing - Receiver.Northing).^2 ) ;
switch Phase
    case 'P'
        Phase_index = 1 ;
    case 'S'
        Phase_index = 2 ;
    otherwise
        disp( ' ' ) 
        disp( [ 'Phase ' , Phase , ' cannot be identified.' ] )
end

Raycode=[ -Source.Elevation    Phase_index ;
          -Receiver.Elevation  Phase_index   ] ;
      
[ Elevation , Sort_Index ]=sort( Velocity_model.Elevation , 'descend' ) ;
Vp = Velocity_model.Vp(Sort_Index) ;
Vs = Velocity_model.Vs(Sort_Index) ;

[ t , ~ ] = traceray( Vp , -Elevation , Vs , -Elevation ,               ...
                      Raycode , Offset , 10 , -1 , 10 , 1 , 1 , 0 ) ;
                  
Arrival_time = t + Source.Occurrence ;

