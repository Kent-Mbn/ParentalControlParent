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
            } else {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        NSLog(@"Error: %@", error.description);
    }];
}

@end
