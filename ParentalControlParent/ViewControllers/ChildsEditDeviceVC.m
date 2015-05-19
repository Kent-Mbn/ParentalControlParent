//
//  ChildsEditDeviceVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChildsEditDeviceVC.h"

@interface ChildsEditDeviceVC ()

@end

@implementation ChildsEditDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewTopbar.backgroundColor = masterColor;
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

#pragma mark - FUNCTION
- (void) callWSEditDevice {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"email":_tfEmail.text,
                                            @"fullname":_tfFullName.text,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_EDIT_DEVICE));
    [manager POST:URL_SERVER_API(API_EDIT_DEVICE) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Common showAlertView:APP_NAME message:MSS_EDIT_DEVICE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_EDIT_DEVICE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

- (void) callWSDeleteDevice {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_DELETE_DEVICE(self.device_id)));
    [manager POST:URL_SERVER_API(API_DELETE_DEVICE(self.device_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Common showAlertView:APP_NAME message:MSS_DELETE_DEVICE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_DELETE_DEVICE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

#pragma mark - TEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ACTION

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    if (!(_tfFullName.text.length == 0 || _tfEmail.text.length == 0)) {
        [self callWSEditDevice];
    }
}

- (IBAction)actionDelete:(id)sender {
    if (self.device_id.length > 0) {
        [self callWSDeleteDevice];
    }
}

- (IBAction)actionHideKeyboard:(id)sender {
    [_tfEmail resignFirstResponder];
    [_tfFullName resignFirstResponder];
}
@end
