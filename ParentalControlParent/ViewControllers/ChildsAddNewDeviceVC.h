//
//  ChildsAddNewDeviceVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface ChildsAddNewDeviceVC : UIViewController
- (IBAction)actionBack:(id)sender;
- (IBAction)actionDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

@property (weak, nonatomic) IBOutlet UITextField *tfFullName;
@end
