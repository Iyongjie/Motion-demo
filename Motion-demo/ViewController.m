//
//  ViewController.m
//  Motion-demo
//
//  Created by 李永杰 on 2019/11/1.
//  Copyright © 2019 muheda. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "YYWeakProxy.h"

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager       *motionManager; //  运动管理者保证不死
@property (nonatomic, strong) NSTimer               *updateTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self motionAvailable];
}

- (void)motionAvailable {
    
    if (!self.motionManager.isAccelerometerAvailable || !self.motionManager.isDeviceMotionAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    [self.motionManager startDeviceMotionUpdates];
    [self.motionManager startAccelerometerUpdates];
    
    // 定时器
    YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                    target:proxy selector:@selector(updateDisplay)
                                                  userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_updateTimer forMode:NSRunLoopCommonModes];
}

- (void)updateDisplay {

    // Z轴加速度
    double accelerometerZ = self.motionManager.accelerometerData.acceleration.z;
    // 重力加速度在Z轴的分量
    double deviceMotionZ = self.motionManager.deviceMotion.gravity.z;
    // 减去重力影响得到的值
    double accelerateZ = (accelerometerZ-deviceMotionZ) *9.8;
    if (fabs(accelerateZ) < 0.2) accelerateZ = 0;// 接近静止，展示0
    NSLog(@"Z轴加速度大小：%fm/s²  重力加速度分量：%fm/s²", accelerometerZ*9.8, deviceMotionZ*9.8);
    NSLog(@"加速度大小：%fm/s²", accelerateZ);
}


@end
