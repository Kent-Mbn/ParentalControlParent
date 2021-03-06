//
//  ForgotPassVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Define.h"

@interface ForgotPassVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewBGFGPass;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
- (IBAction)actionForgotPass:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionHideKeyboard:(id)sender;

@end
