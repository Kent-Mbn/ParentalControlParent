//
//  Define.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

// Master color
#define masterColor [UIColor colorWithRed:49/255.0f green:144/255.0f blue:181/255.0f alpha:1.0]
#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define timeTrackingChildrent 10

#pragma mark - CODE RESPONE FROM SERVER
#define CODE_RESPONE_SUCCESS 0

#pragma mark - NAME
#define APP_NAME @"Parent App"

//m2
#define minOfAreaPolygon 100000

//m
#define minDistanceToShowHistory 100

//GOOGLE KEY
#define GOOGLE_API_KEY @"AIzaSyDskXhfD0_lsUlyutZUd-U6vtS66xBgZlQ"

#pragma mark - MESSAGE
#define MSS_NOTICE_LOGOUT @"Are you want to logout?"
#define MSS_REGISTER_INVALID_FULLNAME @"Full name is invalid."
#define MSS_REGISTER_INVALID_EMAIL @"Email is invalid."
#define MSS_REGISTER_INVALID_PASSWORD @"Password is invalid."
#define MSS_REGISTER_INVALID_CONFIRM_PASS @"Confirm password is invalid."
#define MSS_REGISTER_INVALID_PASS_NOT_MATCH @"Password doesn't match."
#define MSS_REGISTER_INVALID_PHONE_NUMBER @"Phone Number is invalid."
#define MSS_REGISTER_FAILDED @"Register failed!"

#define MSS_LOGIN_INVALID_EMAIL @"Email is invalid."
#define MSS_LOGIN_INVALID_PASSWORD @"Password is invalid."
#define MSS_LOGIN_FAILED @"Login failed!"

#define MSS_FORGOT_PASS_INVALID_EMAIL @"Email is invalid."
#define MSS_FORGOT_PASS_SUCCESS @"Please see new password in your inbox mail!"
#define MSS_FORGOT_PASS_FAILED @"Forget password failed!"

#define MSS_ADD_PAIR_FAILED @"Add pair failed!"
#define MSS_ADD_PAIR_NICK_NAME_INVALID @"Nick name is invalid."
#define MSS_ADD_PAIR_PHONE_NUMBER_INVALID @"Phone Number is invalid."
#define MSS_ADD_PAIR_PUSH_NOTIFICATION_MESSAGE @"Request pair"

#define MSS_ADD_SAFE_AREA_FAILED @"Add safe area failed!"
#define MSS_ADD_SAFE_AREA_TOO_SMALL @"The safe area is too small! Please set other safe area!"
#define MSS_ADD_SAFE_AREA_INVALID_POLYGON @"Invalid point! Please add another point!"

#define MSS_EDIT_DEVICE_FAILED @"Edit device failed!"
#define MSS_DELETE_DEVICE_FAILED @"Delete device failed!"

#define MSS_CHANGE_PASS_FAILED @"Change password failed!"
#define MSS_CHANGE_PASS_INPUT_INVALID @"Input invalid!"

#define MSS_EDIT_PROFILE_FAILED @""
#define MSS_EDIT_PROFILE_INPUT_INVALID @"Input invalid!"

#define MSS_NO_CHILD @"No child!"
#define MSS_FAILED_GET_CHILD @"Get child failed!"