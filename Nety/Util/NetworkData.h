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

@interface NetworkData : NSObject

@property (nonatomic, strong) NSMutableArray *userDataArray;

@end
