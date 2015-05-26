//
//  APIService.h
//  ProjectBase
//
//  Created by CHAU HUYNH on 9/19/14.
//  Copyright (c) 2014 CHAU HUYNH. All rights reserved.
//

//------SETUP SERVER IP------//

//SERVER OF ODC TEAM


#define SERVER_IP   @"http://117.3.65.103/parental-control/public"
#define SERVER_PORT @"80"

#define URL_SERVER_API_FULL [NSString stringWithFormat:@"%@", SERVER_IP]
#define URL_SERVER_API(method) [NSString stringWithFormat:@"%@%@",URL_SERVER_API_FULL,method]


//#define SERVER_IP   @"http://172.20.2.19"
//#define SERVER_PORT @"80"

//#define URL_SERVER_API_FULL [NSString stringWithFormat:@"%@:%@", SERVER_IP, SERVER_PORT]
//#define URL_SERVER_API(method) [NSString stringWithFormat:@"%@%@",URL_SERVER_API_FULL,method]

#define API_USER_REGISTER @"/user/register"
#define API_USER_LOGIN @"/user/login"
#define API_ADD_PAIR(parent_id) [NSString stringWithFormat:@"/userdevice/addpair/%@", parent_id]
#define API_ADD_PAIR_PUSH_NOTIFICATION @"/userdevice/pushnotificationios"

#define API_GET_LIST_CHILD(parent_id) [NSString stringWithFormat:@"/user/children/%@", parent_id] 
#define API_TRACKING_ALL_CHILD(parent_id) [NSString stringWithFormat:@"/history/trackingallchild/%@", parent_id]

#define API_SET_SAFE_AREA @"/safearea/addsafearea"

#define API_EDIT_DEVICE @"/device/edit"
#define API_DELETE_DEVICE(device_id) [NSString stringWithFormat:@"/device/delete/%@", device_id]

#define API_CHANGE_PASS_WORD @"/user/changepassword"
#define API_EDIT_PROFILE @"/user/updateprofile"

#define API_GET_HISTORIES(parent_id) [NSString stringWithFormat:@"/history/gethistories/%@", parent_id]


/*
#define API_GET_USER_POST_LIST @"/user/stat"
#define API_COMPOSE_POST @"/user/post"
#define API_UPLOAD_MEDIA(post_id) [NSString stringWithFormat:@"/post/%@/media", post_id]
#define API_GET_POST_OF_USER(user_id) [NSString stringWithFormat:@"/user/%@/post", user_id]
#define API_COMMENT_FOR_A_POST(post_id) [NSString stringWithFormat:@"/post/%@/comment", post_id]

#define API_UPDATE_LOCATION @"/user/location"
#define API_LIST_USER @"/user/search"
#define API_LIST_POST @"/post/search"
#define API_LIKE_DISLIKE_POST(post_id) [NSString stringWithFormat:@"/post/%@/vote", post_id]

#define API_CHANGE_NAME_MY_PROFILE @"/user/profile"
#define API_CHANGE_AVATAR_MY_PROFILE @"/user/avatar"

#define API_GET_PROFILE(user_id) [NSString stringWithFormat:@"/user/%@", user_id]
#define KEY_RESPONE_LOGIN_SUCCESS @"success"
 */



