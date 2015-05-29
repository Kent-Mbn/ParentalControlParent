//
//  ForgotPassVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ForgotPassVC.h"

@interface ForgotPassVC ()

@end

@implementation ForgotPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Common roundView:_viewBGFGPass andRadius:10.0f];
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

- (BOOL) isValid {
    if (_tfEmail.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_FORGOT_PASS_INVALID_EMAIL delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (![Common isValidEmail:_tfEmail.text]) {
        [Common showAlertView:APP_NAME message:MSS_FORGOT_PASS_INVALID_EMAIL delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    return YES;
}

- (void) callWSForgetPass {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"email":_tfEmail.text,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_FORGET_PASSWORD));
    [manager POST:URL_SERVER_API(API_FORGET_PASSWORD) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response ForgetPass: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [self actionHideKeyboard:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
    if ([self isValid]) {
        [self callWSForgetPass];
    } else {
        [self actionHideKeyboard:nil];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionHideKeyboard:(id)sender {
    [_tfEmail resignFirstResponder];
    [_scrView setContentOffset:CGPointMake(0, -20) animated:YES];
}

#pragma mark - TEXTFIELD DELEGATE
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_scrView setContentOffset:CGPointMake(0, 30) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self actionForgotPass:nil];
    return YES;
}
@end
