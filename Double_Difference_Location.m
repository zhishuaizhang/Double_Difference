function Sources = Double_Difference_Location                           ...
( Receivers , Sources_initial , Differences_Observation , Velocity_model )

[ Differences , Jacobian ] = Calculate_Differences_and_Jacobian         ...
( Receivers , Sources_initial , Differences_Observation , Velocity_model) ;

Double_Differences = Differences - [Differences_Observation.Value]' ;

Number_of_Sources  = length( Sources_initial )    ;
Jacobian_constrain = zeros( 4 , 4*Number_of_Sources ) ;
Jacobian_constrain( 1 ,                         1 :     Number_of_Sources ) = 1 ;
Jacobian_constrain( 2 ,     Number_of_Sources + 1 : 2 * Number_of_Sources ) = 1 ;
Jacobian_constrain( 3 , 2 * Number_of_Sources + 1 : 3 * Number_of_Sources ) = 1 ;
Jacobian_constrain( 4 , 3 * Number_of_Sources + 1 : 4 * Number_of_Sources ) = 1 ;

Jacobian_joint = [ Jacobian ; Jacobian_constrain ] ;

Normalization = 1 ./ sqrt( sum( Jacobian_joint .* Jacobian_joint ) ) ;

Jacobian_joint = Jacobian_joint * diag( Normalization ) ;

delta_m = Jacobian_joint \ [ Double_Differences ; 0 ; 0 ; 0 ; 0 ] .* Normalization' ;

Sources = Sources_initial ;

for ii = 1 : Number_of_Sources 
    Sources(ii).Easting = Sources(ii).Easting + delta_m( ii ) ;
    Sources(ii).Northing = Sources(ii).Northing + delta_m( ii + Number_of_Sources ) ;
    Sources(ii).Elevation = Sources(ii).Elevation + delta_m( ii + 2*Number_of_Sources ) ;
    Sources(ii).Occurrence = Sources(ii).Occurrence + delta_m( ii + 3*Number_of_Sources ) ;
end





