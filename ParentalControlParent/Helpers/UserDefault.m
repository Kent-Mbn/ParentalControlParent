//
//  UserDefault.m
//  UserDefaultEx
//
//  Created by CHAU HUYNH on 10/12/14.
//  Copyright (c) 2014 CHAU HUYNH. All rights reserved.
//

#import "UserDefault.h"
#define kUserDefault_Acc @"User_App"

@implementation UserDefault

static UserDefault *globalObject;

- (id)initWithId:(NSInteger)parentId
{
    self.parent_id = [NSString stringWithFormat:@"%d", parentId];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.parent_id = [aDecoder decodeObjectForKey:@"parent_id"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.token_device = [aDecoder decodeObjectForKey:@"token_device"];
        self.full_name = [aDecoder decodeObjectForKey:@"full_name"];
        self.phone_number = [aDecoder decodeObjectForKey:@"phone_number"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.parent_id forKey:@"parent_id"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.token_device forKey:@"token_device"];
    [aCoder encodeObject:self.full_name forKey:@"full_name"];
    [aCoder encodeObject:self.phone_number forKey:@"phone_number"];
}

- (void) updateUserDefault
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:kUserDefault_Acc];
    [userDefault synchronize];
}

+ (void) clearInfo{
    UserDefault *user = [UserDefault user];
    user.parent_id = nil;
    user.email = nil;
    user.token_device = nil;
    user.full_name = nil;
    user.phone_number = nil;
    [user update];
}

+ (UserDefault *) user
{
    if (!globalObject) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        globalObject = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault dataForKey:kUserDefault_Acc]] ;
        if (!globalObject) {
            globalObject = [[UserDefault alloc] init] ;
            [globalObject update];
        }
    }
    
    return globalObject;
}
- (void) update
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:self]
                    forKey:kUserDefault_Acc];
    [userDefault synchronize];
}

+ (void) update
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:globalObject]
                    forKey:kUserDefault_Acc];
    [userDefault synchronize];
}

@end
