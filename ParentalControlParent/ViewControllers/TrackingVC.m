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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    _viewTopbar.backgroundColor = masterColor;
    _arrData = [[NSMutableArray alloc] init];
    _arrayLocationPins = [[NSMutableArray alloc] init];
    
    [Common roundView:_tblView andRadius:10];
    
    UIColor *colorBgViewTbl = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [_viewTblView setBackgroundColor:colorBgViewTbl];
    
    [self hideViewLoadListDevice];
}

- (void) viewWillAppear:(BOOL)animated {
    [Common setMapTypeGlobal:_mapView];
    [self callWSTrackingAllChild];
    [self startTimerTrackingChildrent];
}

- (void) viewDidAppear:(BOOL)animated {
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [self stopTimerTrackingChildrent];
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
    //[self performSegueWithIdentifier:@"sugueToListDeviceFromTracking" sender:nil];
    //[self focusToAPoint:[_arrayLocationPins objectAtIndex:0]];
    [self showViewLoadListDevice];
}

- (IBAction)actionHideViewTbl:(id)sender {
    [self hideViewLoadListDevice];
}

#pragma mark - FUNCTION
- (void) addArrayLocationToMap {
    [_arrayLocationPins removeAllObjects];
    for (int i = 0; i < [_arrData count]; i++) {
        NSDictionary *dicObj = [_arrData objectAtIndex:i];
        CLLocationCoordinate2D cooPoint = [Common get2DCoordFromString:[NSString stringWithFormat:@"%@,%@", dicObj[@"latitude"], dicObj[@"longitude"]]];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = cooPoint;
        point.title = dicObj[@"fullname"];
        point.subtitle = dicObj[@"address"];
        
        [_arrayLocationPins addObject:point];
        [_mapView addAnnotation:point];
    }
    [self zoomToFitMapAnnotations:_arrayLocationPins];
}

-(void) addPinViewToMap:(CLLocationCoordinate2D) location {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    point.title = @"Huynh Phong Chau";
    point.subtitle = @"Da Nang";
    [_mapView addAnnotation:point];
}

-(void) zoomToFitMapAnnotations:(NSMutableArray *)arrLocationPins {
    if ([_mapView.annotations count] == 0) {
        return;
    }
    
    MKMapPoint points[[arrLocationPins count]];
    for (int i = 0; i < [arrLocationPins count]; i++) {
        CLLocation *locationTemp;
        locationTemp = (CLLocation *)[arrLocationPins objectAtIndex:i];
        points[i] = MKMapPointForCoordinate(locationTemp.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[arrLocationPins count]];
    [_mapView setVisibleMapRect:[poly boundingMapRect] edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:YES];
}

- (void) focusToAPoint:(MKPointAnnotation *) point {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 500, 500);
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    [_mapView selectAnnotation:point animated:YES];
}

- (void) callWSTrackingAllChild {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_TRACKING_ALL_CHILD([UserDefault user].parent_id)));
    [manager POST:URL_SERVER_API(API_TRACKING_ALL_CHILD([UserDefault user].parent_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            NSArray *arrData = responseObject[0][@"data"];
            [_arrData removeAllObjects];
            for (int i = 0; i < [arrData count]; i++) {
                [_arrData addObject:[arrData objectAtIndex:i]];
            }
            if ([_arrData count] > 0) {
                [self addArrayLocationToMap];
            } else {
                [_mapView removeAnnotations:_mapView.annotations];
            }
        } else {
            [_mapView removeAnnotations:_mapView.annotations];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        NSLog(@"Error: %@", error.description);
    }];

}

- (void) showViewLoadListDevice {
    _viewTblView.hidden = NO;
    [_tblView reloadData];
}

- (void) hideViewLoadListDevice {
    _viewTblView.hidden = YES;
}

- (void) stopTimerTrackingChildrent {
    if (_timerTrackingChildrent) {
        [_timerTrackingChildrent invalidate];
        _timerTrackingChildrent = nil;
    }
}

- (void) startTimerTrackingChildrent {
    [self stopTimerTrackingChildrent];
    _timerTrackingChildrent = [NSTimer scheduledTimerWithTimeInterval:timeTrackingChildrent target:self selector:@selector(endTimerTrackingChildrent) userInfo:nil repeats:YES];
}

- (void) endTimerTrackingChildrent {
    [self callWSTrackingAllChild];
}

#pragma mark - MAP DELEGATE

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        /*
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
         */
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    }
    /*
    else {
        pinView.centerOffset = CGPointMake(0, -35 / 2);
        pinView.annotation = annotation;
    }
     */
    
    return pinView;
}

#pragma mark - TABLE VIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistorySelectDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historySelectDevicesCellId" forIndexPath:indexPath];
    
    NSDictionary *objDic = [_arrData objectAtIndex:indexPath.row];
    cell.lblName.text = objDic[@"fullname"];
    cell.lblEmail.text = objDic[@"email"];
    cell.lblPhoneNumber.text = objDic[@"phone_number"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self focusToAPoint:(MKPointAnnotation *)[_arrayLocationPins objectAtIndex:indexPath.row]];
    [self hideViewLoadListDevice];
}
@end
