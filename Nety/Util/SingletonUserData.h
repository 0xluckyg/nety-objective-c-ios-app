//
//  SingletonUserData.h
//  Nety
//
//  Created by Scott Cho on 7/21/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SingletonUserData : NSObject {
    NSString *_userID;
}

+(SingletonUserData *) sharedInstance;

@property (strong, nonatomic, readwrite) NSString *userID;

@end
