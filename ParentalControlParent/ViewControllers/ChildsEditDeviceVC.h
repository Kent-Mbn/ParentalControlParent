//
//  ChildsEditDeviceVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "APIService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"
#import "Common.h"
#import "AppDelegate.h"

@interface ChildsEditDeviceVC : UIViewController<UITextFieldDelegate>
- (IBAction)actionBack:(id)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionDelete:(id)sender;
- (IBAction)actionHideKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfFullName;
@property (nonatomic, strong) NSString *device_id;

@property (nonatomic, strong) NSDictionary *deviceObj;

@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

@end
