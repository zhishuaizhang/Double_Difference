function [ Differences , Jacobian ] = Calculate_Differences_and_Jacobian ...
( Receivers , Sources , Differences_Observation , Velocity_model)

Number_of_Differences = length( Differences_Observation ) ;
Number_of_Sources     = length( Sources )                 ;

Differences = zeros( Number_of_Differences , 1 )                   ;
Jacobian    = zeros( Number_of_Differences , 4*Number_of_Sources ) ;

for ii = 1 : Number_of_Differences
    
    Receiver_index = strcmp( Differences_Observation(ii).Receiver , {Receivers.ID} ) ;
    Source_1_index = find(strcmp( Differences_Observation(ii).Source_1 , {Sources.ID}   )) ;
    Source_2_index = find(strcmp( Differences_Observation(ii).Source_2 , {Sources.ID}   )) ;
    
    Receiver = Receivers(Receiver_index) ;
    Source_1 = Sources(Source_1_index)   ;
    Source_2 = Sources(Source_2_index)   ;
    Phase    = Differences_Observation(ii).Phase ;
        
    Arrival_time_1 = Calculte_arrival_time( Source_1 , Receiver , Velocity_model , Phase ) ;
    Arrival_time_2 = Calculte_arrival_time( Source_2 , Receiver , Velocity_model , Phase ) ;
 
    Differences(ii) = Arrival_time_1 - Arrival_time_2 ;
    
    % Perturb source 1 easting
    Source_1_perturb         = Source_1                 ;
    Source_1_perturb.Easting = 1.001 * Source_1.Easting ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_1_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,Source_1_index) = ( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_1.Easting ;
    
    % Perturb source 1 northing
    Source_1_perturb          = Source_1                 ;
    Source_1_perturb.Northing = 1.001 * Source_1.Northing ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_1_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,Number_of_Sources+Source_1_index) = ( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_1.Northing ;
    
    % Perturb source 1 elevation
    Source_1_perturb           = Source_1                   ;
    Source_1_perturb.Elevation = 1.001 * Source_1.Elevation ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_1_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,2*Number_of_Sources+Source_1_index) = ( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_1.Elevation ;
    
    % Perturb source 1 occurrence time
    Jacobian(ii,3*Number_of_Sources+Source_1_index) = 1 ;
    
    % Perturb source 2 easting
    Source_2_perturb         = Source_2                 ;
    Source_2_perturb.Easting = 1.001 * Source_2.Easting ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_2_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,Source_2_index) = -( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_2.Easting ;
    
    % Perturb source 1 northing
    Source_2_perturb          = Source_2                 ;
    Source_2_perturb.Northing = 1.001 * Source_2.Northing ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_2_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,Number_of_Sources+Source_2_index) = -( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_2.Northing ;
    
    % Perturb source 1 elevation
    Source_2_perturb           = Source_2                   ;
    Source_2_perturb.Elevation = 1.001 * Source_2.Elevation ;
    Arrival_time_1_perturb = Calculte_arrival_time( Source_2_perturb , Receiver , Velocity_model , Phase ) ;
    Jacobian(ii,2*Number_of_Sources+Source_2_index) = -( Arrival_time_1_perturb - Arrival_time_1 ) / 0.001 / Source_2.Elevation ;
    
    % Perturb source 1 occurrence time
    Jacobian(ii,3*Number_of_Sources+Source_2_index) = -1 ;
    
end


