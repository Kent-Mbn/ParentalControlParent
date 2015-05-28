//
//  RegisterVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Common roundView:_viewBGRegister andRadius:10.0f];
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

#pragma mark - FUNCTION
- (BOOL) validInPut {
    if (_tfFullName.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_FULLNAME delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfEmail.text.length == 0 || ![Common isValidEmail:_tfEmail.text]) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_EMAIL delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfPass.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_PASSWORD delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfConfirmPass.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_CONFIRM_PASS delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (![_tfPass.text isEqualToString:_tfConfirmPass.text]) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_PASS_NOT_MATCH delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfPhoneNum.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_REGISTER_INVALID_PHONE_NUMBER delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    return YES;
}

#pragma mark - WEBSERVICE
- (void) callWSRegister {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"email":_tfEmail.text,
                                            @"password":_tfPass.text,
                                            @"fullname":_tfFullName.text,
                                            @"phone_number":_tfPhoneNum.text,
                                            @"register_id":[Common getDeviceToken],
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_USER_REGISTER));
    [manager POST:URL_SERVER_API(API_USER_REGISTER) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response LOGIN: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [UserDefault user].email = _tfEmail.text;
            [UserDefault user].password = _tfPass.text;
            [UserDefault update];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Common showAlertView:APP_NAME message:MSS_REGISTER_FAILDED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_REGISTER_FAILDED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

#pragma mark - ACTION
- (IBAction)actionRegister:(id)sender {
    if ([self validInPut]) {
        [self actionHideKeyboard:nil];
        [self callWSRegister];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionHideKeyboard:(id)sender {
    [_tfPhoneNum resignFirstResponder];
    [_tfFullName resignFirstResponder];
    [_tfEmail resignFirstResponder];
    [_tfPass resignFirstResponder];
    [_tfConfirmPass resignFirstResponder];
    [_scrRegister setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma - mark TEXTFIELD DELEGATE
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _tfFullName) {
        [_scrRegister setContentOffset:CGPointMake(0, 20) animated:YES];
    }
    
    if (textField == _tfEmail) {
        [_scrRegister setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    
    if (textField == _tfPass) {
        [_scrRegister setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    
    if(textField == _tfConfirmPass) {
        [_scrRegister setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    
    if (textField == _tfPhoneNum) {
        [_scrRegister setContentOffset:CGPointMake(0, 180) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _tfFullName) {
        [_tfEmail becomeFirstResponder];
    }
    if(textField == _tfEmail) {
        [_tfPass becomeFirstResponder];
    }
    if(textField == _tfPass) {
        [_tfConfirmPass becomeFirstResponder];
    }
    if(textField == _tfConfirmPass) {
        [_tfPhoneNum becomeFirstResponder];
    }
    if(textField == _tfPhoneNum) {
        [self actionRegister:nil];
    }
    return YES;
}

@end
