//
//  ViewController.m
//  BLETools
//
//  Created by czl on 2017/7/10.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "SRBLEEnum.h"
#import "SRBLEReceivedData.h"
#import "SRBLEEncryptionInfo.h"
#import "SRBLEControlResult.h"
#import "SRBLEVehicleStatus.h"

static NSString * const kBluetoothID = @"kBluetoothID";
static NSString * const kBluetoothKey = @"kBluetoothKey";



@interface ViewController()<CBPeripheralManagerDelegate>


@property (weak) IBOutlet NSTextFieldCell *bleState;

@property (unsafe_unretained) IBOutlet NSTextView *log;

@property (nonatomic,strong) CBPeripheralManager *peripheralManager;

@property (nonatomic,strong) NSMutableString *contents;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSTimer *dataTimer;


@property (nonatomic,strong) NSMutableArray *persArray;


@property (weak) IBOutlet NSTextField *bleTextfield;

@end

@implementation ViewController
{

    CBMutableCharacteristic *FFF3;
    
    CBMutableCharacteristic *FFF5;
    
    CBMutableCharacteristic *FFF6;
    
    NSString *key;
    
    NSString *boothID;
    
    NSMutableData *Readdatas; //收到数据
    
    NSMutableData *Writedatas; //收到数据
    
    
    
}

#pragma mark - getter
- (NSMutableArray *)persArray{
    
    if (!_persArray) {
        _persArray = [NSMutableArray new];
    }
    return _persArray;
    
}

- (CBPeripheralManager *)peripheralManager{
    
    if (!_peripheralManager) {
        _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _peripheralManager;
}

-(NSMutableString *)contents{
    
    if (!_contents) {
        _contents = [NSMutableString new];
    }
    return _contents;
}

- (NSTimer *)timer{
    
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:30.f target:self selector:@selector(sendMsg) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}



- (void)sendMsg{
    [self sendToApp:@"*d5#8#5#a608#"];
    //    [self.peripheralManager updateValue:[@"0020" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:FFF6 onSubscribedCentrals:self.persArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self peripheralManager];
    [[SRBLEVehicleStatus share]addObserver:self forKeyPath:@"doorLF" options:NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSString *sendToAPPText = [NSString stringWithFormat:@"*fd#3#2#b301,%@",[[SRBLEVehicleStatus share] description]];
    NSRange crcRange = [sendToAPPText rangeOfString:@"#"];
    if (crcRange.location == NSNotFound) {
        return ;
    }
    NSString *sub = [sendToAPPText substringFromIndex:crcRange.location+crcRange.length];
    
    //如果第一位 不大于2 && b301 跳过（远键上报状态有问题）
    NSArray *arr=[sub componentsSeparatedByString:@","];
    NSString *firstObj = arr[0];
    NSInteger first1 = [sub substringWithRange:NSMakeRange(0, 1)].integerValue;;
    //    NSLog(@"first %ld %@",(long)first , firstObj);
    
    if ([firstObj hasSuffix:@"b301"] && first1 <= 2) {
        return;
    }
    
    
    __block UInt8 crcCalculate = 0;
    dispatch_apply(sub.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        crcCalculate += [sub characterAtIndex:index];
    });
    
    NSString *crcCalculateStr = [NSString stringWithFormat:@"%x", crcCalculate&0xff];
    sendToAPPText = [NSString stringWithFormat:@"*%@%@",crcCalculateStr,[sendToAPPText substringFromIndex:3]];
    
    [self addLogText:[NSString stringWithFormat:@"发送车辆状态通知:%@",sendToAPPText]];
    
    NSMutableData *newData = [[NSMutableData alloc]initWithData:[sendToAPPText dataUsingEncoding:NSUTF8StringEncoding]];
    [newData appendData:[ViewController transferEndFlagData]];
    
    [self.peripheralManager updateValue:newData forCharacteristic:FFF6 onSubscribedCentrals:nil];
 
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)start:(NSButton *)sender {
    
    NSString *name = _bleTextfield.stringValue.length>1?_bleTextfield.stringValue:@"12345";
    
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:SRUUID_Peripheral_service]],
                                               CBAdvertisementDataLocalNameKey :[NSString stringWithFormat:@"btn-%@",name]
                                               }
     ];
    
//    [self.contents appendString:@"开启广播\n"];
    [self addLogText:[NSString stringWithFormat:@"开启广播自定义广播名称： CBAdvertisementDataLocalNameKey:%@",[NSString stringWithFormat:@"btn-%@",name]]];
    _bleState.stringValue = @"蓝牙状态:开";
    
    [self.timer fire];
}

- (IBAction)stop:(id)sender {
    [self.peripheralManager stopAdvertising];

    [self addLogText:@"停止广播"];
    [self.persArray removeAllObjects];
     _bleState.stringValue = @"蓝牙状态:关";
    [self.timer invalidate];
    self.timer = nil;
    [[SRBLEVehicleStatus share]removeObserver:self forKeyPath:@"doorLF"];
}
#pragma mark -  外设代理
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            [self setUp];
            [self addLogText:@"开启蓝牙"];
            break;
        case CBPeripheralManagerStatePoweredOff:
            [self stop:nil];
            [self addLogText:@"关闭蓝牙"];
            break;
        default:
            break;
    }
}

//perihpheral添加了service
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    
//    [self.contents appendString:@"添加服务完毕\n"];
//    self.log.text = self.contents;
    [self addLogText:@"添加服务完毕"];
    
    
    
    
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    [self addLogText:[NSString stringWithFormat:@"订阅通知:%@\n%@",central.identifier,characteristic.UUID.UUIDString]];
    [self.persArray addObject:central];
    NSLog(@"%s",__FUNCTION__);
}

/*!
 *  @method peripheralManager:central:didUnsubscribeFromCharacteristic:
 *
 *  @param peripheral       The peripheral manager providing this update.
 *  @param central          The central that issued the command.
 *  @param characteristic   The characteristic on which notifications or indications were disabled.
 *
 *  @discussion             This method is invoked when a central removes notifications/indications from <i>characteristic</i>.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
      [self addLogText:[NSString stringWithFormat:@"取消订阅通知:%@\n%@",central.identifier,characteristic.UUID.UUIDString]];
    
    [self.persArray removeObject:central];

    NSLog(@"%s",__FUNCTION__);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
//        //对请求作出成功响应
        [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        [self addLogText:[NSString stringWithFormat:@"%@:读不允许写权限",request.characteristic.UUID.UUIDString]];
        return;
    }
    
   
    NSString *text = [[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding];
    if ([text isEqualToString:@""] || !text) {
        return;
    }
   

    if (!Readdatas) {
        Readdatas = [NSMutableData data];
    }
    
    [Readdatas appendData:request.value];
    
    NSData *last = [request.value subdataWithRange:NSMakeRange(request.value.length-1, 1)];
    
    
    BOOL hasBreak = [last isEqualToData:[ViewController transferEndFlagData]];
    if (hasBreak) {
        Readdatas = [NSMutableData new];
        if ([text containsString:@"#a608#"]) {
            return;
        }
        [self addLogText:[NSString stringWithFormat:@"%@:读接收通知:%@",request.characteristic.UUID.UUIDString,text]];
        
        [self sendToApp:text];
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests{
    
    CBATTRequest *request1 = requests[0];
    //判断是否有写数据的权限
    if (request1.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request1.characteristic;
        c.value = request1.value;
        [peripheral respondToRequest:request1 withResult:CBATTErrorSuccess];
    }else{
        [peripheral respondToRequest:request1 withResult:CBATTErrorWriteNotPermitted];
         [self addLogText:[NSString stringWithFormat:@"%@:写不允许写权限",request1.characteristic.UUID.UUIDString]];
        return;
    }
    
    
    if (!Writedatas) {
        Writedatas = [NSMutableData data];
    }
    
    
    
    
    for (CBATTRequest *request in requests) {
        NSString *text = [[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding];
        if ([text isEqualToString:@""] || !text) {
            return;
        }
        
        [Writedatas appendData:request.value];
        
        NSData *last = [request.value subdataWithRange:NSMakeRange(request.value.length-1, 1)];
        
        
        BOOL hasBreak = [last isEqualToData:[ViewController transferEndFlagData]];
        if (hasBreak) {
            NSString *text = [[NSString alloc]initWithData:Writedatas encoding:NSUTF8StringEncoding];
            Writedatas = [NSMutableData new];
            if ([text containsString:@"#a608#"]) {
                
                return;
            }
            [self addLogText:[NSString stringWithFormat:@"%@:写接收通知:%@",request.characteristic.UUID.UUIDString,text]];
            
            [self sendToApp:text];

       
            
        }
        
        
    }
    [peripheral respondToRequest:[requests lastObject] withResult:CBATTErrorSuccess];
    
    
    

}

//peripheral开始发送advertising
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{

    [self addLogText:@"peripheralManagerDidStartAdvertisiong"];

}


/**
 根据APP请求返回数据
 
 @param text
 */
- (void)sendToApp:(NSString *)text{
    SRBLEReceivedData *receive = [[SRBLEReceivedData alloc]initWithData:text];
    NSString *sendToAPPText;
//    NSArray *douArray = [text componentsSeparatedByString:@","];
//    NSString *first = [douArray firstObject];
    
    if (!receive) {
        return;
    
    }
    

    if (receive.operationInstruction == SRBLEOperationInstruction_A605) {
        sendToAPPText = [NSString stringWithFormat:@"*30#8#2#a605,%d,btu.CC2640.0,0101.release.1,BT_M_B1b.0.0000#",arc4random()%89999999+10000000];
    }else if (receive.operationInstruction == SRBLEOperationInstruction_A606){
    
    }else if (receive.operationInstruction == SRBLEOperationInstruction_B203){
        if (receive.operationMessageType == SRBLEMessageType_Query) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:kBluetoothID] && [[NSUserDefaults standardUserDefaults]objectForKey:kBluetoothKey]) {
                sendToAPPText = [NSString stringWithFormat:@"*ce#3#2#b203,%@,%@#",[[NSUserDefaults standardUserDefaults]objectForKey:kBluetoothID],[[NSUserDefaults standardUserDefaults]objectForKey:kBluetoothKey]];
            }else{
                sendToAPPText = @"*ce#3#2#b203,00,00#";
            }
        }else if(receive.operationMessageType == SRBLEMessageType_Config){
          
            [[NSUserDefaults standardUserDefaults]setObject:[receive encryptionInfo].idStr forKey:kBluetoothID];
            [[NSUserDefaults standardUserDefaults]setObject:[receive encryptionInfo].keyCRC forKey:kBluetoothKey];
        }
        
    }else if (receive.operationInstruction == SRBLEOperationInstruction_A606){
        
        
    }else if (receive.operationInstruction == SRBLEOperationInstruction_B301){
        sendToAPPText = [NSString stringWithFormat:@"*fd#3#2#b301,%@",[[SRBLEVehicleStatus share] description]];
    }else if (receive.operationInstruction == SRBLEOperationInstruction_HEART){
        sendToAPPText = @"*d5#8#5#a608#";
    }else if (receive.operationInstruction == SRBLEOperationInstruction_B502){
        if (receive.operationMessageType == SRBLEMessageType_Query) {
          sendToAPPText = [NSString stringWithFormat:@"*4d#3#2#b502,%d#",arc4random()%8999+1000];
        }else if (receive.operationMessageType == SRBLEMessageType_Publish){
        int x = arc4random_uniform(3);
          sendToAPPText = [NSString stringWithFormat:@"*8a#3#7#b402,1,%d#",x];
            if (x == SRBLEControlResultCode_OK) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SRBLEVehicleStatus share].doorLF = arc4random()%2+1;
                });
            }
        }
        
    }
    
 
    if (!sendToAPPText) {
        return;
    }
    NSRange crcRange = [sendToAPPText rangeOfString:@"#"];
    if (crcRange.location == NSNotFound) {
        return ;
    }
//    NSString *crcStr = [sendToAPPText substringWithRange:NSMakeRange(1, crcRange.location-1)];
    
    NSString *sub = [sendToAPPText substringFromIndex:crcRange.location+crcRange.length];
    
    //如果第一位 不大于2 && b301 跳过（远键上报状态有问题）
    NSArray *arr=[sub componentsSeparatedByString:@","];
    NSString *firstObj = arr[0];
    NSInteger first1 = [sub substringWithRange:NSMakeRange(0, 1)].integerValue;;
    //    NSLog(@"first %ld %@",(long)first , firstObj);
    
    if ([firstObj hasSuffix:@"b301"] && first1 <= 2) {
        return;
    }
    
    
    __block UInt8 crcCalculate = 0;
    dispatch_apply(sub.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        crcCalculate += [sub characterAtIndex:index];
    });
    
    NSString *crcCalculateStr = [NSString stringWithFormat:@"%x", crcCalculate&0xff];
    sendToAPPText = [NSString stringWithFormat:@"*%@%@",crcCalculateStr,[sendToAPPText substringFromIndex:3]];
    
    [self addLogText:[NSString stringWithFormat:@"发送通知:%@",sendToAPPText]];
    
    NSMutableData *newData = [[NSMutableData alloc]initWithData:[sendToAPPText dataUsingEncoding:NSUTF8StringEncoding]];
    [newData appendData:[ViewController transferEndFlagData]];
    
    [self.peripheralManager updateValue:newData forCharacteristic:FFF6 onSubscribedCentrals:nil];
}



+ (NSData *)transferEndFlagData
{
    Byte byte[] = {0x00};
    return  [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
}



//配置bluetooch的
-(void)setUp{
    
    //characteristics字段描述
    //    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    
    /*
     可以通知的Characteristic
     properties：CBCharacteristicPropertyNotify
     permissions CBAttributePermissionsReadable
     */
    FFF6 = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_Terminal] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    
    
    
    
    /*
     只读的Characteristic
     properties：CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable
     */
    FFF3 = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:SRUUID_Characteristic_Write_BLE] properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsWriteable|CBAttributePermissionsReadable];
    
    FFF5 = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:SRUUID_Characteristic_Write_Terminal] properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsWriteable|CBAttributePermissionsReadable];
    
    
    //service1初始化并加入两个characteristics
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:SRUUID_Peripheral_service] primary:YES];
    [service1 setCharacteristics:@[FFF3,FFF5,FFF6]];
    
    
    
    //添加后就会调用代理的- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
    [self.peripheralManager addService:service1];
    
}


- (void)addLogText:(NSString *)text{
   
    [[self.log textStorage]appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",text] attributes:@{NSForegroundColorAttributeName:[NSColor whiteColor]}]];
    [self.log scrollRangeToVisible:NSMakeRange([[self.log string] length], 0)];
}

- (IBAction)clearLog:(id)sender {
    self.log.string = @"";
}




@end
