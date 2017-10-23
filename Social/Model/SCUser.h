//
//  SCUser.h
//  Social
//
//  Created by yujie cao on 9/24/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface SCUser : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

+ (BOOL)isUserLogin;
+ (void)userLogInSuccess;
+ (NSString *)defaultUserName;
+ (void)saveDefaultUserName:(NSString *)username;

@end


