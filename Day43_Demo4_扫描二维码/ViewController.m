//
//  ViewController.m
//  Day43_Demo4_扫描二维码
//
//  Created by tarena on 12/18/15.
//  Copyright © 2015 hushuang. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
/**
 *  扫描二维码流程
 *  1. 打开后置摄像头
 *  2. 从后置摄像头中读取数据流
 *  3. 把输入流输出到屏幕进行展示
 *  4. 把输入流 -> 输出流 中间需要一个管道 -> 回话
 *  5. 让输出流实时过滤自己的内容, 监听是不是有二维码/条形码存在. 如果有, 就通过协议告知我们.
 */

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *videoLayer;
@property (weak, nonatomic) IBOutlet UITextView *label;



@end

@implementation ViewController
#pragma mark - 当扫描到时触发方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        [_videoLayer removeFromSuperlayer];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        NSLog(@"扫描到数据:%@", obj.stringValue);
        self.label.text = obj.stringValue;
    }
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
	if (_session.isRunning) {
		[_session stopRunning];
		[_videoLayer removeFromSuperlayer];
	}
}

- (IBAction)scanCode:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //拿到输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        return;
    }
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [AVCaptureSession new];
    [_session addInput:input];
    [_session addOutput:output];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    _videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_videoLayer];
    [_session startRunning];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






