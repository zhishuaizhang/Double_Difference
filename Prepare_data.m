function [ Receivers , Sources_initial , Sources_true , Differences , Velocity_model ] = Prepare_data

%% Prepare velocity model

Velocity_model.Elevation = -4000 : 10 : 1000               ;
Velocity_model.Vp        = 3000 - Velocity_model.Elevation ;
% Velocity_model.Vp        = 3000 * ones( size( Velocity_model.Elevation ) ) ;
Velocity_model.Vs        = Velocity_model.Vp / sqrt(3)     ;

%% Prepare sources
Sources_x   = 3 ;
Sources_y   = 3 ;
Sources_z   = 1 ;

Number_of_Sources = Sources_x * Sources_y * Sources_z ;

Sources_true.ID         = 'SourceID' ;
Sources_true.Easting    = 0 ;
Sources_true.Northing   = 0 ;
Sources_true.Elevation  = 0 ;
Sources_true.Occurrence = 0 ;

Sources_true(Number_of_Sources).ID = [] ;

for zz = 1:Sources_z
    for yy = 1:Sources_y
        for xx = 1:Sources_x
            
            Source_Index = xx + (yy-1)*Sources_x + (zz-1)*Sources_x*Sources_y ;
            
            Sources_true(Source_Index).ID = [ num2str(xx) ,             ...
                                              num2str(yy) ,             ...
                                              num2str(zz)   ] ;
                                                  
            Sources_true(Source_Index).Easting    = 100 * ( xx - 2 ) + 2500 ;
            Sources_true(Source_Index).Northing   = 100 * ( yy - 2 ) + 3000 ;
            Sources_true(Source_Index).Elevation  = 100 * ( zz - 1 ) - 1500 ;
            Sources_true(Source_Index).Occurrence = xx + yy + zz            ;
            
        end
    end
end

Sources_initial = Sources_true ;

for ii = 1:length(Sources_initial)
    Sources_initial(ii).Easting    = Sources_true(5).Easting    ;
    Sources_initial(ii).Northing   = Sources_true(5).Northing   ;
    Sources_initial(ii).Elevation  = Sources_true(5).Elevation  ;
    Sources_initial(ii).Occurrence = Sources_true(5).Occurrence ;
end

%% Prepare receivers

Receivers_x = 2 ;
Receivers_y = 2 ;

Number_of_Receivers = Receivers_x * Receivers_y ;

Receivers.ID         = 'ReceiverID' ;
Receivers.Easting    = 0 ;
Receivers.Northing   = 0 ;
Receivers.Elevation  = 0 ;

Receivers(Number_of_Receivers).ID = [] ;

for yy = 1:Receivers_y
    for xx = 1:Receivers_x
                    
            Receiver_Index = xx + (yy-1)*Receivers_x + (zz-1)*Receivers_x*Receivers_y ;
            
            Receivers(Receiver_Index).ID = [ num2str(xx) , num2str(yy) ] ;
                                                  
            Receivers(Receiver_Index).Easting    = 500  * ( xx - 1.5 ) + 2500 ;
            Receivers(Receiver_Index).Northing   = 2000 * ( yy - 1.5 ) + 3000 ;
            Receivers(Receiver_Index).Elevation  = 500                        ;
            
    end
end

%% Prepare difference

Differences.Source_1    = 'SourceID_1' ;
Differences.Source_2    = 'SourceID_2' ;
Differences.Receiver    = 'ReceiverID' ;
Differences.Value       = 0            ;
Differences.Uncertainty = 0.0          ;
Differences.Phase       = 'N'          ;


Differences(Number_of_Sources*Number_of_Receivers).Value  = 0 ;

ii = 0 ;
for rr = 1:Number_of_Receivers
    for s1 = 1:Number_of_Sources
        for s2 = (s1+1):Number_of_Sources
            for Phase = [ 'P' , 'S' ]
                
                ii = ii + 1 ;
                
                Arrival_time_1 = Calculte_arrival_time                  ...
                ( Sources_true(s1) , Receivers(rr) , Velocity_model , Phase ) ; 

                Arrival_time_2 = Calculte_arrival_time                  ...
                ( Sources_true(s2) , Receivers(rr) , Velocity_model , Phase ) ; 
        
                Differences(ii).Source_1    = Sources_true(s1).ID ;
                Differences(ii).Source_2    = Sources_true(s2).ID ;
                Differences(ii).Receiver    = Receivers(rr).ID    ;
                Differences(ii).Value       = Arrival_time_1 - Arrival_time_2 ;
                Differences(ii).Uncertainty = 0.1                 ;
                Differences(ii).Phase       = Phase               ;
                
            end
            
        end
    end
end

    
    
