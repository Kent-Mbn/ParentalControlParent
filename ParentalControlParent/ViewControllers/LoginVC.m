//
//  LoginVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [Common roundView:_viewBGInput andRadius:10.0f];
    self.view.backgroundColor = masterColor;
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

#pragma mark - TEXT FIELD DELEGATE

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _tfEmail) {
        [_scrBG setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    
    if (textField == _tfPassword) {
        [_scrBG setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _tfEmail) {
        [_tfPassword becomeFirstResponder];
    }
    if(textField == _tfPassword) {
        [self actionLogin:nil];
    }
    return YES;
}


#pragma mark - FUNCTION

- (BOOL) validInPut {
    if (_tfEmail.text.length == 0 || ![Common isValidEmail:_tfEmail.text]) {
        [Common showAlertView:APP_NAME message:MSS_LOGIN_INVALID_EMAIL delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfPassword.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_LOGIN_INVALID_PASSWORD delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    return YES;
}

- (void) callWSLogin {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"email":_tfEmail.text,
                                            @"password":_tfPassword.text,
                                            @"register_id":[Common getDeviceToken],
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_USER_LOGIN));
    [manager POST:URL_SERVER_API(API_USER_LOGIN) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response LOGIN: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            
            //Save information
            NSArray *arrRespone = (NSArray *) responseObject;
            NSDictionary *userDic = arrRespone[1][@"user"];
            [[UserDefault user] setEmail:userDic[@"email"]];
            [[UserDefault user] setFull_name:userDic[@"fullname"]];
            [[UserDefault user] setParent_id:userDic[@"id"]];
            [[UserDefault user] setPassword:_tfPassword.text];
            [[UserDefault user] setPhone_number:userDic[@"phone_number"]];
            [[UserDefault user] setToken_device:[Common getDeviceToken]];
            [UserDefault update];
            
            [APP_DELEGATE setRootViewLoginWithCompletion:^{
                
            }];
        } else {
            [Common showAlertView:APP_NAME message:MSS_LOGIN_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_LOGIN_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}


#pragma mark - ACTION

- (IBAction)actionForgotPass:(id)sender {
}

- (IBAction)actionRegister:(id)sender {
}

- (IBAction)actionLogin:(id)sender {
    if ([self validInPut]) {
        [self actionHideKeyboard:nil];
        [self callWSLogin];
    }
}
- (IBAction)actionHideKeyboard:(id)sender {
    [_tfEmail resignFirstResponder];
    [_tfPassword resignFirstResponder];
    [_scrBG setContentOffset:CGPointMake(0, -20) animated:YES];
}
@end
