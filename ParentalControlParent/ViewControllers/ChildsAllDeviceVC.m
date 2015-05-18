//
//  ChildsAllDeviceVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChildsAllDeviceVC.h"

@interface ChildsAllDeviceVC ()

@end

@implementation ChildsAllDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewTopbar.backgroundColor = masterColor;
    
    //Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    _arrayData = [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
    [self callWSListAllDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton *btSender = (UIButton *)sender;
    if ([[segue identifier] isEqualToString:@"segueToChangeSafeArea"]) {
        ChangeSafeAreaVC *desVC = [segue destinationViewController];
        desVC.device_id = btSender.tag;
    }
}

#pragma mark - ACTION
- (IBAction)actionAddNewDevice:(id)sender {
    
}

- (void) goToChangeSafeArea:(id)sender {
    UIButton *btTag = (UIButton *)sender;
    [self performSegueWithIdentifier:@"segueToChangeSafeArea" sender:btTag];
}

#pragma mark - FUNCTIONS
- (void) callWSListAllDevices {
    [Common showLoadingViewGlobal:nil];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSMutableDictionary *request_param = [@{
                                            
                                            } mutableCopy];
    NSLog(@"request_param: %@ %@", request_param, URL_SERVER_API(API_GET_LIST_CHILD([UserDefault user].parent_id)));
    [manager POST:URL_SERVER_API(API_GET_LIST_CHILD([UserDefault user].parent_id)) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideLoadingViewGlobal];
        NSLog(@"response: %@", responseObject);
        if ([Common validateRespone:responseObject]) {
            //Save data to array
            [_arrayData removeAllObjects];
            NSArray *arrTemp = responseObject[0][@"devices"];
            for (int i = 0; i < [arrTemp count]; i++) {
                NSDictionary *objDic = [arrTemp objectAtIndex:i];
                [_arrayData addObject:objDic];
            }
            
            //Reload table
            [_tblView reloadData];
        } else {
            [Common showAlertView:APP_NAME message:MSS_LOGIN_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideLoadingViewGlobal];
        [Common showAlertView:APP_NAME message:MSS_LOGIN_FAILED delegate:self cancelButtonTitle:@"OK" arrayTitleOtherButtons:nil tag:0];
    }];
}

#pragma mark - TABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildsAllDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildsAllDeviceCellId" forIndexPath:indexPath];
    NSDictionary *objDic = [_arrayData objectAtIndex:indexPath.row];
    cell.lblName.text = objDic[@"fullname"];
    cell.lblEmail.text = objDic[@"email"];
    cell.lblPhoneNumber.text = objDic[@"phone_number"];
    
    //Button tag = id of device
    cell.btSetArea.tag = [objDic[@"id"] integerValue];
    [cell.btSetArea addTarget:self action:@selector(goToChangeSafeArea:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueToEditDevice" sender:nil];
}

@end
