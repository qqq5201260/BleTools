//
//  SRBLEBluetoothInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/19.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SREntity.h"

@interface SRBLEBluetoothInfo : SREntity

@property (nonatomic, assign) NSInteger authCode;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *softVersion;
@property (nonatomic, copy) NSString *hardVersion;

- (instancetype)initWithParameters:(NSArray *)parameters;

@end
