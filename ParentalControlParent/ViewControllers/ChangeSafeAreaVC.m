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
    radiusCircle = 500;
    _lblRadius.text = [NSString stringWithFormat:@"%dm", radiusCircle];
    
    [Common setMapTypeGlobal:_mapView];
    [self setEventLongPress];
    
    [self initTapMap];
    typeSafeArea = radiusShape;
    [self setStatusBottomBar:typeSafeArea];
    _arrayForPolygon = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FUNCTIONS
- (void) setEventLongPress {
    UILongPressGestureRecognizer *longPressPlus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressPlus:)];
    [_btPlus addGestureRecognizer:longPressPlus];
    
    UILongPressGestureRecognizer *longPressMinus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionLongPressMinus:)];
    [_btMinus addGestureRecognizer:longPressMinus];
    
}

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
        centerPointCircle = touchCoordinate;
        [self addCircle:radiusCircle andCircleCoordinate:centerPointCircle];
        [self addPinViewToMap:touchCoordinate];
    } else {
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
        //Checking new touch point is valid with polygon, if not -> don't add to map
        if ([_arrayForPolygon count] > 2) {
            NSMutableArray *arrToCheck = [[NSMutableArray alloc] initWithArray:_arrayForPolygon];
            [arrToCheck addObject:currentLocation];
            if ([Common checkPolygonSafeArea:arrToCheck]) {
                [_arrayForPolygon addObject:currentLocation];
                [self addPinViewToMap:touchCoordinate];
                //Check if tapped 2 point -> draw a line before
                if ([_arrayForPolygon count] == 2) {
                    [self drawLine];
                } else {
                    [self drawPolygon];
                }
            } else {
                [Common showAlertView:APP_NAME message:MSS_ADD_SAFE_AREA_INVALID_POLYGON delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
            }
        } else {
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

- (void) callWSSaveSafeArea {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = nil;
    
    //Edit parameter for circle of polygon
    if (typeSafeArea == radiusShape) {
       // parameter for circle
        request_param = [@{
                                                @"device_id":@(self.device_id),
                                                @"latitude":@(centerPointCircle.latitude),
                                                @"longitude":@(centerPointCircle.longitude),
                                                @"radius":@(radiusCircle),
                                                } mutableCopy];
    } else {
       //parameter for polygon
        request_param = [@{
                                                @"device_id":@(self.device_id),
                                                @"latitude":[Common returnStringArrayLat:_arrayForPolygon],
                                                @"longitude":[Common returnStringArrayLong:_arrayForPolygon],
                                                @"radius":@"",
                                                } mutableCopy];

    }
    
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_SET_SAFE_AREA));
    [manager POST:URL_SERVER_API(API_SET_SAFE_AREA) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response LOGIN: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
        } else {
            [Common showAlertView:APP_NAME message:MSS_ADD_SAFE_AREA_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_ADD_SAFE_AREA_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

- (void) stopTimerPlus {
    if (_timerPlus) {
        [_timerPlus invalidate];
        _timerPlus = nil;
    }
}

- (void) stopTimerMinus {
    if (_timerMinus) {
        [_timerMinus invalidate];
        _timerMinus = nil;
    }
}

- (void) startTimerPlus {
    [self stopTimerPlus];
    _timerPlus = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(endTimerPlus) userInfo:nil repeats:YES];
}

- (void) startTimerMinus {
    [self stopTimerMinus];
    _timerMinus = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(endTimerMinus) userInfo:nil repeats:YES];
}

- (void) endTimerPlus{
    [self actionUpRadius:nil];
}

- (void) endTimerMinus{
    [self actionDownRadius:nil];
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
    if ((CLLocationCoordinate2DIsValid(centerPointCircle)  && radiusCircle > 0) || ([_arrayForPolygon count] > 2)) {
        NSLog(@"AREA: %f", [Common areaOfPolygon:_arrayForPolygon]);
        if ((typeSafeArea == polygonShape) && ([Common areaOfPolygon:_arrayForPolygon] < minOfAreaPolygon)) {
            [Common showAlertView:APP_NAME message:MSS_ADD_SAFE_AREA_TOO_SMALL delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        } else {
            [self callWSSaveSafeArea];
        }
    } else {
        [Common showAlertView:APP_NAME message:MSS_ADD_SAFE_AREA_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }
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
    radiusCircle += radiusUpDown;
    _lblRadius.text = [NSString stringWithFormat:@"%dm", radiusCircle];
}

- (IBAction)actionDownRadius:(id)sender {
    if (radiusCircle > 500) {
        radiusCircle -= radiusUpDown;
        _lblRadius.text = [NSString stringWithFormat:@"%dm", radiusCircle];
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

-(void) actionLongPressPlus:(id) sender {
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startTimerPlus];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self stopTimerPlus];
    }
}

-(void) actionLongPressMinus:(id) sender {
    UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startTimerMinus];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self stopTimerMinus];
    }
}

@end
