//
//  LoginVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Define.h"
#import "AppDelegate.h"
#import "APIService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"

@interface LoginVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBGInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrBG;
@property (weak, nonatomic) IBOutlet UIButton *btCheckBox;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

- (IBAction)actionForgotPass:(id)sender;
- (IBAction)actionRegister:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionHideKeyboard:(id)sender;



@end
