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
}

- (void) viewDidAppear:(BOOL)animated {
    NSString *strCurrentDate = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    [self callWSGetAllHistories:@"3" andCreatedTime:strCurrentDate];
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
    [self performSegueWithIdentifier:@"sugueToListDeviceFromHistory" sender:nil];
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

#pragma mark - FUNCTIONS
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSLog(@"Click here!");
}

- (void) callWSGetAllHistories:(NSString *) device_id andCreatedTime:(NSString *)created_time {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"device_id":device_id,
                                            @"created_at":created_time,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_GET_HISTORIES([UserDefault user].parent_id)));
    [manager POST:URL_SERVER_API(API_GET_HISTORIES([UserDefault user].parent_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            NSArray *arrData = responseObject[0][@"data"];
            if ([arrData count] > 0) {
                NSMutableArray *arrPoints = [[NSMutableArray alloc] init];
                for (int i = 0; i < [arrData count]; i++) {
                    NSDictionary *dicPoint = arrData[i];
                    CLLocation *locaPoint = [[CLLocation alloc] initWithLatitude:[dicPoint[@"latitude"] doubleValue] longitude:[dicPoint[@"longitude"] doubleValue]];
                    [arrPoints addObject:locaPoint];
                }
                [self drawHistory:arrPoints];
            }
        } else {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        NSLog(@"Error: %@", error.description);
    }];
}

- (void) drawHistory:(NSMutableArray *)arrayPoints {
    if ([arrayPoints count] > 0) {
        for (int i = 0; i < [arrayPoints count]; i++) {
            CLLocation *locationTemp1;
            CLLocation *locationTemp2;
            locationTemp1 = (CLLocation *)[arrayPoints objectAtIndex:i];
            locationTemp2 = (CLLocation *)[arrayPoints objectAtIndex:i];
            [self drawLine:locationTemp1.coordinate andSecondPoint:locationTemp2.coordinate];
        }
    }
}

- (void) drawLine:(CLLocationCoordinate2D) firstPoint andSecondPoint:(CLLocationCoordinate2D) secondPoint {
    
    // remove polyline if one exists
    [_mapView removeAnnotations:[_mapView annotations]];
    
    //Create an array of coordinates
    CLLocationCoordinate2D coordinates[2];
    coordinates[0] = firstPoint;
    coordinates[1] = secondPoint;
    
    // Create a polyline with array of coordinates
    MKPolyline *polyLineFirst = [MKPolyline polylineWithCoordinates:coordinates count:2];
    
    // Create a polyline view
    _polylineView = [[MKPolylineView alloc] initWithPolyline:polyLineFirst];
    _polylineView.strokeColor = [UIColor redColor];
    _polylineView.lineWidth = 5;

    [_mapView addOverlay:polyLineFirst];
}

#pragma mark - MAP VIEW DELEGATE
- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    return _polylineView;
}


@end
