//
//  SRBLEVehicleStatus.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEVehicleStatus.h"

@implementation SRBLEVehicleStatus

+ (instancetype)share{
    
    static SRBLEVehicleStatus *install;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        install = [[SRBLEVehicleStatus alloc] initWithParameters:@[@"222220",
                                                                    @"220000",
                                                                    @"2000",
                                                                    @"00000",
                                                                    @"0222",
                                                                    @"12",
                                                                    @"0",
                                                                    @"22",
                                                                    @"211",
                                                                    @"0"
                                                                    ]];
    });
    return install;
}

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (!parameters || parameters.count < 5) {
        return nil;
    }
    
    self = [super init];
    
    _acc    = [parameters[0] substringWithRange:NSMakeRange(0, 1)].integerValue;
    _on     = [parameters[0] substringWithRange:NSMakeRange(1, 1)].integerValue;
    _engine = [parameters[0] substringWithRange:NSMakeRange(2, 1)].integerValue;
    _run    = [parameters[0] substringWithRange:NSMakeRange(3, 1)].integerValue;
    
    _doorLF = [parameters[1] substringWithRange:NSMakeRange(0, 1)].integerValue;
    _doorRF = [parameters[1] substringWithRange:NSMakeRange(1, 1)].integerValue;
    _doorLB = [parameters[1] substringWithRange:NSMakeRange(2, 1)].integerValue;
    _doorRB = [parameters[1] substringWithRange:NSMakeRange(3, 1)].integerValue;
    _trunkDoor  = [parameters[1] substringWithRange:NSMakeRange(4, 1)].integerValue;
    
    _doorLockLF = [parameters[2] substringWithRange:NSMakeRange(0, 1)].integerValue;
    _doorLockRF = [parameters[2] substringWithRange:NSMakeRange(1, 1)].integerValue;
    _doorLockLB = [parameters[2] substringWithRange:NSMakeRange(2, 1)].integerValue;
    _doorLockRB = [parameters[2] substringWithRange:NSMakeRange(3, 1)].integerValue;
    
    _windowLF   = [parameters[3] substringWithRange:NSMakeRange(0, 1)].integerValue;
    _windowRF   = [parameters[3] substringWithRange:NSMakeRange(1, 1)].integerValue;
    _windowLB   = [parameters[3] substringWithRange:NSMakeRange(2, 1)].integerValue;
    _windowRB   = [parameters[3] substringWithRange:NSMakeRange(3, 1)].integerValue;
    _windowSky  = [parameters[3] substringWithRange:NSMakeRange(4, 1)].integerValue;
    
    _lightBig   = [parameters[4] substringWithRange:NSMakeRange(0, 1)].integerValue;
    _lightSmall = [parameters[4] substringWithRange:NSMakeRange(1, 1)].integerValue;

    
    return self;
}

- (NSInteger)doorLock
{
    if (self.doorLockLF == 2 || self.doorLockLB == 2 || self.doorLockRB == 2 || self.doorLockRF == 2) {
        return 2;
    } else if (self.doorLockLF == 0 && self.doorLockLB == 0 && self.doorLockRB == 0 && self.doorLockRF == 0) {
        return 0;
    } else {
        return 1;
    }
}

- (NSString *)description{

    return [NSString stringWithFormat:@"%d%d%d%d,%d%d%d%d%d,%d%d%d%d,%d%d%d%d%d,%d%d,2200,0200,100,0#",self.acc,self.on,self.engine,self.run,self.doorLF,_doorRF,_doorLB,_doorRB,_trunkDoor,_doorLockLF,_doorLockRF,_doorLockLB,_doorLockRB,_windowLF,_windowRF,_windowLB,_windowRB,_windowSky,_lightBig,_lightSmall];
}

@end
