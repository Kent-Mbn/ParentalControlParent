//
//  RegisterVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Define.h"

@interface RegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfFullName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPass;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPass;
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;
@property (weak, nonatomic) IBOutlet UIScrollView *scrRegister;
@property (weak, nonatomic) IBOutlet UIView *viewBGRegister;


- (IBAction)actionRegister:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
