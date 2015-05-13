//
//  TrackingVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "TrackingVC.h"

@interface TrackingVC ()

@end

@implementation TrackingVC
@synthesize arrayLocationPins = _arrayLocationPins;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    _viewTopbar.backgroundColor = masterColor;
    _arrayLocationPins = [[NSMutableArray alloc] init];
    
    //Add 2 points to map
    CLLocationCoordinate2D cooPoint1 = [Common get2DCoordFromString:@"0.012743,0.019655"];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = cooPoint1;
    point1.title = @"Huynh Phong Chau";
    point1.subtitle = @"Da Nang";
    
    CLLocationCoordinate2D cooPoint2 = [Common get2DCoordFromString:@"-0.0082,0.039255"];
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = cooPoint2;
    point2.title = @"Huynh Phong Chau";
    point2.subtitle = @"Da Nang";
    
    [_arrayLocationPins addObject:point1];
    [_arrayLocationPins addObject:point2];
    
    for (int i = 0; i < [_arrayLocationPins count]; i++) {
        [_mapView addAnnotation:[_arrayLocationPins objectAtIndex:i]];
    }
    [self zoomToFitMapAnnotations];
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"Parent Id: %@", [UserDefault user].parent_id);
}

- (void) viewDidAppear:(BOOL)animated {
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ACTION
- (IBAction)actionListDevice:(id)sender {
    [self performSegueWithIdentifier:@"sugueToListDeviceFromTracking" sender:nil];
    //[self focusToAPoint:[_arrayLocationPins objectAtIndex:0]];
    
}

#pragma mark - FUNCTION
-(void) addPinViewToMap:(CLLocationCoordinate2D) location {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    point.title = @"Huynh Phong Chau";
    point.subtitle = @"Da Nang";
    [_mapView addAnnotation:point];
}

-(void) zoomToFitMapAnnotations {
    if ([_mapView.annotations count] == 0) {
        return;
    }
    
    MKMapPoint points[[_arrayLocationPins count]];
    for (int i = 0; i < [_arrayLocationPins count]; i++) {
        CLLocation *locationTemp;
        locationTemp = (CLLocation *)[_arrayLocationPins objectAtIndex:i];
        points[i] = MKMapPointForCoordinate(locationTemp.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[_arrayLocationPins count]];
    [_mapView setVisibleMapRect:[poly boundingMapRect] edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:YES];
}

- (void) focusToAPoint:(MKPointAnnotation *) point {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 1000, 1000);
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    [_mapView selectAnnotation:point animated:YES];
}

#pragma mark - MAP DELEGATE

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 20, 32)];
        imageV.image = [UIImage imageNamed:@"ic_device_pin.png"];
        if (annotation == mapView.userLocation){
            customPinView.image = [UIImage imageNamed:@""];
            [customPinView addSubview:imageV];
        }
        else{
            [customPinView addSubview:imageV];
            customPinView.image = [UIImage imageNamed:@""];
            //customPinView.pinColor = MKPinAnnotationColorRed;
        }
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    } else {
        pinView.centerOffset = CGPointMake(0, -35 / 2);
        pinView.annotation = annotation;
    }
    
    return pinView;
}

@end
