//
//  ChangePassVC.h
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

@interface ChangePassVC : UIViewController<UITextFieldDelegate>
- (IBAction)actionBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
- (IBAction)actionDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfOldPass;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPass;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPass;

@end
