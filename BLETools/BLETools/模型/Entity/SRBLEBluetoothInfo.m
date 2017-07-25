//
//  SRBLEBluetoothInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/19.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRBLEBluetoothInfo.h"

@implementation SRBLEBluetoothInfo

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (!parameters || parameters.count < 4) {
        return nil;
    }
    
    self = [super init];
    
    _authCode = [parameters[0] integerValue];
    _moduleName = parameters[1];
    _softVersion = parameters[2];
    _hardVersion = parameters[3];
    
    
    return self;
}

@end
