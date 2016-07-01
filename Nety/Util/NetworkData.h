//
//  NetworkData.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const keyName;
extern NSString *const keyJob;
extern NSString *const keyDescription;
extern NSString *const keyImage;

extern NSString *const keyExperienceName;
extern NSString *const keyExperienceTime;
extern NSString *const keyExperienceDescription;

@interface NetworkData : NSObject

@property (nonatomic, strong) NSMutableArray *userDataArray;

@property (nonatomic, strong) NSMutableArray *userExperienceArray;

@end
