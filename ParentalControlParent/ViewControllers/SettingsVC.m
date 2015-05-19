//
//  SettingsVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    _viewTopbar.backgroundColor = masterColor;
    typeOfMap = standanrd;
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

#pragma mark - TABLE VIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCellId" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            cell.imvTick.hidden = YES;
            switch (indexPath.row) {
                case 0:
                {
                    cell.lblTitle.text = @"My Profile";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_profile.png"];
                }
                break;
                case 1:
                {
                    cell.lblTitle.text = @"Change Password";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_key.png"];
                }
                break;
                case 2:
                {
                    cell.lblTitle.text = @"Logout";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_logout.png"];
                }
                break;
                    
                default:
                    break;
            }
        }
        break;
        case 1:
        {
            cell.imvTick.hidden = YES;
            switch (indexPath.row) {
                case 0:
                {
                    cell.lblTitle.text = @"Standard";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_map_standard.png"];
                    if (typeOfMap == indexPath.row) {
                        cell.imvTick.hidden = NO;
                    }
                }
                    break;
                case 1:
                {
                    cell.lblTitle.text = @"Hybrid";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_map_hybrid.png"];
                    if (typeOfMap == indexPath.row) {
                        cell.imvTick.hidden = NO;
                    }
                }
                    break;
                case 2:
                {
                    cell.lblTitle.text = @"Satellite";
                    cell.imvIconLeft.image = [UIImage imageNamed:@"ic_gps_setting.png"];
                    if (typeOfMap == indexPath.row) {
                        cell.imvTick.hidden = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Profile";
            break;
        case 1:
            return @"Map";
            break;
            
        default:
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self performSegueWithIdentifier:@"sugueToMyProfile" sender:nil];
                }
                break;
                    
                case 1:
                {
                    [self performSegueWithIdentifier:@"sugueToChangePass" sender:nil];
                }
                break;
                    
                case 2:
                {
                    [Common showAlertView:APP_NAME message:MSS_NOTICE_LOGOUT delegate:self cancelButtonTitle:@"Cancel" arrayTitleOtherButtons:@[@"Yes"] tag:0];
                }
                break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    typeOfMap = standanrd;
                }
                break;
                    
                case 1:
                {
                    typeOfMap = hybrid;
                }
                break;
                    
                case 2:
                {
                    typeOfMap = satellite;
                }
                break;
                    
                default:
                    break;
            }
            [_tblSettings reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ALERT DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0:
        {
            if (buttonIndex == 1) {
                [UserDefault clearInfo];
                [APP_DELEGATE setRootViewLogoutWithCompletion:^{
                    
                }];
            }
        }
        break;
            
        default:
            break;
    }
}

@end
