% function Sources = Double_Difference_Location                           ...
% ( Receivers , Sources_initial , Sources_true , Differences , Velocity_model )

clear variables
close all
clc

[ Receivers               , Sources_initial , Sources_true ,            ...
  Differences_Observation , Velocity_model ] = Prepare_data ;

%%

Arrival_time   = Calculate_arrival_time( Source_location , Receiver_location , Velocity_model ) ;
Difference_calculate = Arrival_time - ones( size(Arrival_time,1) , 1 ) * Arrival_time_reference ;

Double_Difference = Difference_observe - Difference_calculate ;

G = zeros( length( Double_Difference(:) ) , length( Source_location(:) ) ) ;

for ii = 1 : length( Source_location(:) )
    
    Source_location_perturb = Source_location ;
    
    Source_location_perturb(ii) = 1.001*Source_location_perturb(ii) ;
    
    Arrival_time_perturb = Calculate_arrival_time( Source_location_perturb , Receiver_location , Velocity_model ) ;
    
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


