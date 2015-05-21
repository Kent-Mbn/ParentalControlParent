//
//  ChangePassVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChangePassVC.h"

@interface ChangePassVC ()

@end

@implementation ChangePassVC

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

#pragma mark - FUNCTIONS
- (void) callWSChangePass {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"id":[UserDefault user].parent_id,
                                            @"password":_tfNewPass.text,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_CHANGE_PASS_WORD));
    [manager POST:URL_SERVER_API(API_CHANGE_PASS_WORD) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            [[UserDefault user] setPassword:_tfNewPass.text];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Common showAlertView:APP_NAME message:MSS_CHANGE_PASS_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_CHANGE_PASS_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];

}

- (BOOL) validData {
    if (_tfNewPass.text.length == 0) {
        return NO;
    }
    if (_tfConfirmPass.text.length == 0) {
        return NO;
    }
    if (_tfOldPass.text.length == 0) {
        return NO;
    }
    if (![_tfOldPass.text isEqualToString:[UserDefault user].password]) {
        return NO;
    }
    if (![_tfNewPass.text isEqualToString:_tfConfirmPass.text]) {
        return NO;
    }
    return YES;
}

#pragma mark - TEXTFIELD DELEGATE
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
        [self callWSChangePass];
    } else {
        [Common showAlertView:APP_NAME message:MSS_CHANGE_PASS_INPUT_INVALID delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }
}
@end
