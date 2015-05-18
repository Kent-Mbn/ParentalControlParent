//
//  ChangeSafeAreaVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChangeSafeAreaVC.h"

//met
#define radiusUpDown 10

@interface ChangeSafeAreaVC ()

@end

@implementation ChangeSafeAreaVC
@synthesize arrayForPolygon = _arrayForPolygon;
@synthesize polyLineFirst = _polyLineFirst;
@synthesize polylineViewFirst = _polylineViewFirst;
@synthesize polygon = _polygon;
@synthesize polygonView = _polygonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.opaque = YES;
    
    _viewTopbar.backgroundColor = masterColor;
    _viewBottombar.backgroundColor = masterColor;
    
    //met
    radius = 500;
    _lblRadius.text = [NSString stringWithFormat:@"%dm", radius];
    
    [self initTapMap];
    typeSafeArea = radiusShape;
    [self setStatusBottomBar:typeSafeArea];
    _arrayForPolygon = [[NSMutableArray alloc] init];
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

#pragma mark - FUNCTIONS
- (void) initTapMap {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMap:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [_mapView addGestureRecognizer:tapGes];
}

- (void) setStatusBottomBar:(NSTypeOfSafeArea) type {
    if (type == radiusShape) {
        _viewSettingForRadius.hidden = NO;
        _btBackDraw.hidden = YES;
    } else {
        _viewSettingForRadius.hidden = YES;
        _btBackDraw.hidden = NO;
    }
}

- (void) handleTapMap:(UIGestureRecognizer *) gesTap {
    if(gesTap.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint touchPoint = [gesTap locationInView:_mapView];
    CLLocationCoordinate2D touchCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    if (typeSafeArea == radiusShape) {
        [self addCircle:1000 andCircleCoordinate:touchCoordinate];
        [self addPinViewToMap:touchCoordinate];
    } else {
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
        [_arrayForPolygon addObject:currentLocation];
        
        [self addPinViewToMap:touchCoordinate];
        
        //Check if tapped 2 point -> draw a line before
        if ([_arrayForPolygon count] == 2) {
            [self drawLine];
        } else {
            [self drawPolygon];
        }
    }
}

- (void)addCircle:(double)radius andCircleCoordinate:(CLLocationCoordinate2D) coordinate {
    //Remove all overlaya and annotations
    [self removeAllOverlay];
    [self removeAllAnnotations];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:radius];
    [_mapView addOverlay:circle];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 3000, 3000);
    [_mapView setRegion:region animated:YES];
}

-(void) addPinViewToMap:(CLLocationCoordinate2D) location {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    [_mapView addAnnotation:point];
}

-(void)removeAllAnnotations
{
    [_mapView removeAnnotations:_mapView.annotations];
}

-(void)removeAllOverlay {
    [_mapView removeOverlays:_mapView.overlays];
}

- (void) drawLine {
    
    // remove polyline if one exists
    [_mapView removeOverlay:_polyLineFirst];
    
    //Create an array of coordinates
    CLLocationCoordinate2D coordinates[2];
    for (int i=0; i < 2; i++) {
        CLLocation *locationTemp;
        locationTemp = (CLLocation *)[_arrayForPolygon objectAtIndex:i];
        coordinates[i] = locationTemp.coordinate;
    }
    
    // Create a polyline with array of coordinates
    _polyLineFirst = [MKPolyline polylineWithCoordinates:coordinates count:2];
    
    // Create a polyline view
    _polylineViewFirst = [[MKPolylineView alloc] initWithPolyline:_polyLineFirst];
    _polylineViewFirst.strokeColor = [UIColor redColor];
    _polylineViewFirst.lineWidth = 5;
    
    [_mapView addOverlay:_polyLineFirst];
}

- (void) drawPolygon {
    
    // remove polygon if one exists
    [_mapView removeOverlay:_polygon];
    
    //Create an array of coordinates
    int countCoordinate = (int)[_arrayForPolygon count];
    CLLocationCoordinate2D coordinates[countCoordinate];
    for (int i=0; i < countCoordinate; i++) {
        CLLocation *locationTemp;
        locationTemp = (CLLocation *)[_arrayForPolygon objectAtIndex:i];
        coordinates[i] = locationTemp.coordinate;
    }
    
    // Create a polygon with array of coordinates
    _polygon = [MKPolygon polygonWithCoordinates:coordinates count:countCoordinate];
    
    // Create a polygon view
    _polygonView = [[MKPolygonView alloc] initWithPolygon:_polygon];
    _polygonView.strokeColor = [UIColor redColor];
    _polygonView.lineWidth = 5;
    _polygonView.fillColor = [UIColor colorWithRed:12/255 green:24/255 blue:26/255 alpha:0.5];
    
    [_mapView addOverlay:_polygon];
    
}


#pragma mark - MAP DELEGATE
- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if (typeSafeArea == radiusShape) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *) overlay];
        circleView.fillColor = [UIColor colorWithRed:12/255 green:24/255 blue:26/255 alpha:0.5];
        circleView.strokeColor = [UIColor redColor];
        return circleView;
    } else {
        if ([_arrayForPolygon count] == 2) {
            return _polylineViewFirst;
        } else {
            return _polygonView;
        }
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 35, 35)];
        imageV.image = [UIImage imageNamed:@"ic_gps.png"];
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



#pragma mark - ACTION

- (IBAction)actionBack:(id)sender {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.opaque = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    
}

- (IBAction)actionRadiusType:(id)sender {
    //Radius
    _imgBGButtonChangeType.image = [UIImage imageNamed:@"radius-highlight.png"];
    typeSafeArea = radiusShape;
    [self setStatusBottomBar:typeSafeArea];
    [self removeAllAnnotations];
    [self removeAllOverlay];
}

- (IBAction)actionPolygonType:(id)sender {
    //Polygon
    _imgBGButtonChangeType.image = [UIImage imageNamed:@"polygon-highlight.png"];
    typeSafeArea = polygonShape;
    [self setStatusBottomBar:typeSafeArea];
    [self removeAllOverlay];
    [self removeAllAnnotations];
    [_arrayForPolygon removeAllObjects];
}
- (IBAction)actionUpRadius:(id)sender {
    radius += radiusUpDown;
    _lblRadius.text = [NSString stringWithFormat:@"%dm", radius];
}

- (IBAction)actionDownRadius:(id)sender {
    if (radius > 500) {
        radius -= radiusUpDown;
        _lblRadius.text = [NSString stringWithFormat:@"%dm", radius];
    }
}

- (IBAction)actionCancelDraw:(id)sender {
    [self removeAllOverlay];
    [self removeAllAnnotations];
    [_arrayForPolygon removeAllObjects];
}

- (IBAction)actionBackDraw:(id)sender {
    if ([_arrayForPolygon count] > 0) {
        //If when tap back action draw, map still has 2 points -> remove all
        if ([_arrayForPolygon count] == 2) {
            [self actionCancelDraw:nil];
        } else {
            //If map has more 2 points -> remove last object and reDraw polygon
            /* Remove last pin view: remove all and reload */
            [self removeAllAnnotations];
            [_arrayForPolygon removeLastObject];
            for (int i = 0; i < [_arrayForPolygon count]; i++) {
                CLLocation *pinT = (CLLocation *)[_arrayForPolygon objectAtIndex:i];
                [self addPinViewToMap:pinT.coordinate];
            }
            [self drawPolygon];
        }
    }
}
@end
