//
//  HistoryMainVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "HistoryMainVC.h"

@interface HistoryMainVC ()

@end

@implementation HistoryMainVC
@synthesize actionDatePicker = _actionDatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    _viewTopbar.backgroundColor = masterColor;
    _strCurrentTime = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    [Common setMapTypeGlobal:_mapView];
    _arrData = [[NSMutableArray alloc] init];
    [Common roundView:_tblView andRadius:10];
    UIColor *colorBgViewTbl = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [_viewTblView setBackgroundColor:colorBgViewTbl];
    [self hideViewLoadListDevice];
}

- (void) viewDidAppear:(BOOL)animated {
    if ([_mapView.annotations count] == 0) {
        [self callWSTrackingAllChild];
    }
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

- (IBAction)actionSelectDevice:(id)sender {
    [self showViewLoadListDevice];
}

- (IBAction)actionSelectDate:(id)sender {
    if (_actionDatePicker == nil) {
        _actionDatePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date]
                                                                  target:self action:@selector(dateWasSelected:element:) origin:sender];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dateWasSelected:element:)];
        doneButton.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        cancelButton.tintColor = [UIColor whiteColor];
        
        [_actionDatePicker setDoneButton:doneButton];
        [_actionDatePicker setCancelButton:cancelButton];
    }
    [_actionDatePicker showActionSheetPicker];
    _actionDatePicker.toolbar.barTintColor = masterColor;
}

- (IBAction)actionHideViewTbl:(id)sender {
    [self hideViewLoadListDevice];
}

#pragma mark - FUNCTIONS
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    _strCurrentTime = [NSString stringWithFormat:@"%.0f", [selectedDate timeIntervalSince1970]];
    [self callWSGetAllHistories];
}

- (void) callWSGetAllHistories {
    [Common showLoadingViewGlobal:nil];
    
    //Remove all annotations
    [_mapView removeAnnotations:_mapView.annotations];
    
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"device_id":_strIdChild,
                                            @"created_at":_strCurrentTime,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_GET_HISTORIES([UserDefault user].parent_id)));
    [manager POST:URL_SERVER_API(API_GET_HISTORIES([UserDefault user].parent_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            NSArray *arrData = responseObject[0][@"data"];
            if ([arrData count] > 0) {
                NSMutableArray *arrPoints = [[NSMutableArray alloc] init];
                CLLocationCoordinate2D centerPoint;
                for (int i = 0; i < [arrData count]; i++) {
                    NSDictionary *dicPoint = arrData[i];
                    CLLocationCoordinate2D coorPoint = [Common get2DCoordFromString:[NSString stringWithFormat:@"%f,%f", [dicPoint[@"latitude"] doubleValue],[dicPoint[@"longitude"] doubleValue]]];
                    
                    //Set name to top bar
                    if (i == 0) {
                        _lblName.text = dicPoint[@"fullname"];
                    }
                    
                    //Checking point valid or not before showed to map
                    //If nil value or distance > min distance checking to show on map
                    if (![Common isValidCoordinate:centerPoint] || ([Common isValidCoordinate:centerPoint] && [Common calDistanceTwoCoordinate:centerPoint andSecondPoint:coorPoint] > minDistanceToShowHistory)) {
                        centerPoint = coorPoint;
                    } else {
                        continue;
                    }
                    
                    CLLocation *locaPoint = [[CLLocation alloc] initWithLatitude:coorPoint.latitude longitude:coorPoint.longitude];
                    [arrPoints addObject:locaPoint];
                    [self addPinViewToMap:coorPoint];
                    [self zoomToFitMapAnnotations:arrPoints];
                }
            }
        } else {
            _lblName.text = @"";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        NSLog(@"Error: %@", error.description);
    }];
}

-(void) zoomToFitMapAnnotations:(NSMutableArray *) arrPoints {
    if ([arrPoints count] > 0) {
        MKMapPoint points[[arrPoints count]];
        for (int i = 0; i < [arrPoints count]; i++) {
            CLLocation *locationTemp;
            locationTemp = (CLLocation *)[arrPoints objectAtIndex:i];
            points[i] = MKMapPointForCoordinate(locationTemp.coordinate);
        }
        MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[arrPoints count]];
        [_mapView setVisibleMapRect:[poly boundingMapRect] edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:YES];
    }
}

-(void) addPinViewToMap:(CLLocationCoordinate2D) location {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    [_mapView addAnnotation:point];
}

- (void) drawLine:(NSMutableArray *) arrPoints {
    
    // remove polyline if one exists
    [_mapView removeOverlay:_polyline];
    
    //Create an array of coordinates
    CLLocationCoordinate2D coordinates[[arrPoints count]];
    int i = 0;
    for (CLLocation *point in arrPoints) {
        if (i == 0) {
            [_mapView setRegion:MKCoordinateRegionMakeWithDistance(point.coordinate, 1000, 1000) animated:YES];
        }
        coordinates[i] = point.coordinate;
        i++;
    }
    
    
    // Create a polyline with array of coordinates
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:[arrPoints count]];
    [_mapView addOverlay:polyLine];
    _polyline = polyLine;
    
    // Create a polyline view
    _polylineView = [[MKPolylineView alloc] initWithPolyline:_polyline];
    _polylineView.strokeColor = [UIColor redColor];
    _polylineView.lineWidth = 5;

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
                NSDictionary *objDic = _arrData[0];
                _strIdChild = objDic[@"id"];
                [self callWSGetAllHistories];
            }
        } else {
            
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

#pragma mark - MAP VIEW DELEGATE
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    }
    return pinView;
}


- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    return _polylineView;
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
    //[self focusToAPoint:(MKPointAnnotation *)[_arrayLocationPins objectAtIndex:indexPath.row]];
    NSDictionary *objDic = [_arrData objectAtIndex:indexPath.row];
    _strIdChild = [NSString stringWithFormat:@"%@",objDic[@"id"]];
    [self callWSGetAllHistories];
    [self hideViewLoadListDevice];
}



@end
