clear variables
close all
clc

[ Receivers , Sources_initial , Sources_true , Differences_Observation , Velocity_model ] = Prepare_data ;

Sources = Double_Difference_Location                                    ...
( Receivers , Sources_initial , Differences_Observation , Velocity_model ) ;

figure
subplot( 1 , 9 , 1:5 )
scatter3( [Sources.Easting] , [Sources.Northing] , [Sources.Elevation] , 20 , 'filled' )
hold on
scatter3( [Sources_true.Easting] , [Sources_true.Northing] , [Sources_true.Elevation] , 50 )
scatter3( [Sources_initial.Easting] , [Sources_initial.Northing] , [Sources_initial.Elevation] , 80 , 'filled' )
scatter3( [Receivers.Easting] , [Receivers.Northing] , [Receivers.Elevation] , 80 , '^' , 'filled' )
xlabel( 'Easting (m)' )
ylabel( 'Northing (m)' )
zlabel( 'Elevation (m)' )
axis equal
subplot( 1 , 9 , 8:9 )
plot( Velocity_model.Vp , Velocity_model.Elevation )
hold on
plot( Velocity_model.Vs , Velocity_model.Elevation )
legend( 'Vp' , 'Vs' )
xlabel( 'Velocity (m/s)' )
ylabel( 'Elevation (m)' )
