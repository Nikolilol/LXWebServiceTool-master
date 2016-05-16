//
//  ViewController.m
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "ViewController.h"
#import "LXWebServiceTool.h"

@interface ViewController ()
@property(nonatomic, weak) LXWebServiceTool *tool;
@property(nonatomic, weak) UILabel *titleLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView{
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    titleLabel.text = @"中国";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:20.0];
    _titleLabel = titleLabel;
    [self.view addSubview:titleLabel];
    
    titleLabel.backgroundColor = [UIColor redColor];
    
    UIButton *toTraditionalChinese = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, (self.view.frame.size.width - 30 )/2 , 60)];
    [toTraditionalChinese setTitle:@"toTraditionalChinese" forState:UIControlStateNormal];
    [toTraditionalChinese addTarget:self action:@selector(toTraditionalChineseClick:) forControlEvents:UIControlEventTouchUpInside];
    toTraditionalChinese.backgroundColor = [UIColor grayColor];
    [self.view addSubview:toTraditionalChinese];
    
    UIButton *toSimplifiedChinese = [[UIButton alloc] initWithFrame:CGRectMake(toTraditionalChinese.frame.size.width + 20, 210, toTraditionalChinese.frame.size.width, 60)];
    [toSimplifiedChinese setTitle:@"toSimplifiedChinese" forState:UIControlStateNormal];
    [toSimplifiedChinese addTarget:self action:@selector(toSimplifiedChineseClick:) forControlEvents:UIControlEventTouchUpInside];
    toSimplifiedChinese.backgroundColor = [UIColor grayColor];
    [self.view addSubview:toSimplifiedChinese];
}

//for example:
/*
 SOAP 1.2
 
 以下是 SOAP 1.2 请求和响应示例。所显示的占位符需替换为实际值。
 
 POST /WebServices/TraditionalSimplifiedWebService.asmx HTTP/1.1
 Host: www.webxml.com.cn
 Content-Type: application/soap+xml; charset=utf-8
 Content-Length: length
 
 <?xml version="1.0" encoding="utf-8"?>
 <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
 <soap12:Body>
 <toTraditionalChinese xmlns="http://webxml.com.cn/">
 <sText>string</sText>
 </toTraditionalChinese>
 </soap12:Body>
 </soap12:Envelope>
 HTTP/1.1 200 OK
 Content-Type: application/soap+xml; charset=utf-8
 Content-Length: length
 
 <?xml version="1.0" encoding="utf-8"?>
 <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
 <soap12:Body>
 <toTraditionalChineseResponse xmlns="http://webxml.com.cn/">
 <toTraditionalChineseResult>string</toTraditionalChineseResult>
 </toTraditionalChineseResponse>
 </soap12:Body>
 </soap12:Envelope>
 */
- (void)toTraditionalChineseClick:(id)sender
{
    NSArray *parArray = @[@"sText", _titleLabel.text];
    [LXWebServiceTool requestWithNameSpace:@"http://webxml.com.cn/" SoapMthod:@"toTraditionalChinese" parArray:parArray webServiceUrl:[NSURL URLWithString: @"http://www.webxml.com.cn/WebServices/TraditionalSimplifiedWebService.asmx"] success:^(NSString *methodName, id responseObject) {
        NSLog(@"methodName = %@\nresponseObjecct = %@", methodName, responseObject);
        _titleLabel.text = responseObject;
    } errorBlock:^(NSString *methodName, NSError *error) {
        
        NSLog(@"methodName = %@\nerror = %@", methodName, error);
        _titleLabel.text = [NSString stringWithFormat:@"methodName = %@\nerror = %@", methodName, error];
    }];
}

- (void)toSimplifiedChineseClick:(id)sender
{
    NSArray *parArray = @[@"sText", _titleLabel.text];
    [LXWebServiceTool requestWithNameSpace:@"http://webxml.com.cn/" SoapMthod:@"toSimplifiedChinese" parArray:parArray webServiceUrl:[NSURL URLWithString: @"http://www.webxml.com.cn/WebServices/TraditionalSimplifiedWebService.asmx"] success:^(NSString *methodName, id responseObject) {
        NSLog(@"methodName = %@\nresponseObjecct = %@", methodName, responseObject);
        _titleLabel.text = responseObject;
    } errorBlock:^(NSString *methodName, NSError *error) {
        
        NSLog(@"methodName = %@\nerror = %@", methodName, error);
        _titleLabel.text = [NSString stringWithFormat:@"methodName = %@\nerror = %@", methodName, error];
    }];
}
@end
