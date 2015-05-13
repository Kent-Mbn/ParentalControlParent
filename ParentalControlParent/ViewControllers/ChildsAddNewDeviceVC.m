//
//  ChildsAddNewDeviceVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChildsAddNewDeviceVC.h"

@interface ChildsAddNewDeviceVC ()

@end

@implementation ChildsAddNewDeviceVC

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
- (BOOL) validData {
    if (_tfNickName.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_NICK_NAME_INVALID delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    
    if (_tfPhoneNumber.text.length == 0) {
        [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_PHONE_NUMBER_INVALID delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        return NO;
    }
    return YES;
}

- (void) callWSAddPair {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"phone_number":_tfPhoneNumber.text,
                                            @"nickname":_tfNickName.text,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_ADD_PAIR([UserDefault user].parent_id)));
    [manager POST:URL_SERVER_API(API_ADD_PAIR([UserDefault user].parent_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            // Save id and device token of child
            NSArray *arrRespone = (NSArray *)responseObject;
            NSDictionary *dataDic = arrRespone[0][@"data"];
            [self callPushNotificationToChild:dataDic[@"register_id"] andStrId:dataDic[@"id"]];
        } else {
            [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

- (void) callPushNotificationToChild:(NSString *) strDeviceToken andStrId:(NSString *) strId {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            @"device_token":strDeviceToken,
                                            @"push_to":@"child",
                                            @"message":MSS_ADD_PAIR_PUSH_NOTIFICATION_MESSAGE,
                                            @"pusher_id":[UserDefault user].parent_id,
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_ADD_PAIR_PUSH_NOTIFICATION));
    [manager POST:URL_SERVER_API(API_ADD_PAIR_PUSH_NOTIFICATION) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            
        } else {
            [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        NSLog(@"Error: %@", error.description);
        [Common showAlertView:APP_NAME message:MSS_ADD_PAIR_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

#pragma mark - ACTION
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    if ([self validData]) {
        [self callWSAddPair];
    }
}

#pragma mark - TEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
