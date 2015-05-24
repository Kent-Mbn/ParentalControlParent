//
//  MyProfileVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "MyProfileVC.h"

@interface MyProfileVC ()

@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewTopbar.backgroundColor = masterColor;
    
    //Init data
    _tfEmail.text = [UserDefault user].email;
    _tfName.text = [UserDefault user].full_name;
    _tfPhoneNum.text = [UserDefault user].phone_number;
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
- (void) callWSEditProfile {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"id":[UserDefault user].parent_id,
                                            @"email":_tfEmail.text,
                                            @"fullname":_tfName.text,
                                            @"phone_number":_tfPhoneNum.text,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_EDIT_PROFILE));
    [manager POST:URL_SERVER_API(API_EDIT_PROFILE) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [[UserDefault user] setEmail:_tfEmail.text];
            [[UserDefault user] setFull_name:_tfName.text];
            [[UserDefault user] setPhone_number:_tfPhoneNum.text];
            [UserDefault update];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Common showAlertView:APP_NAME message:MSS_EDIT_PROFILE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_EDIT_PROFILE_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

- (BOOL) validData {
    if (_tfEmail.text.length == 0) {
        return NO;
    }
    if (![Common isValidEmail:_tfEmail.text]) {
        return NO;
    }
    if (_tfName.text.length == 0) {
        return NO;
    }
    if (_tfPhoneNum.text.length == 0) {
        return NO;
    }
    return YES;
}

#pragma mark _ TEXTFIELD DELEGATE
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - ACTION
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    if ([self validData]) {
        [self callWSEditProfile];
    }
}
@end
