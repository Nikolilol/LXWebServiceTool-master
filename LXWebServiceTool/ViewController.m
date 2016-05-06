//
//  ViewController.m
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "ViewController.h"
#import "LXWebServiceTool.h"

@interface ViewController ()<LXWebServiceToolDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self requestWebService];
}

//for example:
/*
POST /WebServices/MobileCodeWS.asmx HTTP/1.1
Host: webservice.webxml.com.cn
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
<soap12:Body>
<getMobileCodeInfo xmlns="http://WebXml.com.cn/">
<mobileCode>string</mobileCode>
<userID>string</userID>
</getMobileCodeInfo>
</soap12:Body>
</soap12:Envelope>

HTTP/1.1 200 OK
Content-Type: application/soap+xml; charset=utf-8
Content-Length: length

<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
<soap12:Body>
<getMobileCodeInfoResponse xmlns="http://WebXml.com.cn/">
<getMobileCodeInfoResult>string</getMobileCodeInfoResult>
</getMobileCodeInfoResponse>
</soap12:Body>
</soap12:Envelope>
 */

- (void)requestWebService
{
    NSArray *parArray = [[NSArray alloc] initWithObjects:@"mobileCode", @"userID", @" ", @" ", nil];
    [LXWebServiceTool requestWithTarget:self SoapMethod:@"getMobileCodeInfo" parArray:parArray webServiceUrl:[NSURL URLWithString: @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"]];
}

# pragma mark - WebServiceToolDelegate
- (void)WebServiceToolFailedWithXmlPar:(id)error
{
    //requst error
    NSLog(@"%@", error);
}

- (void)WebServiceToolFinsihedWithXmlPar:(id)responseObj
{
    //requst successful
    NSLog(@"%@",responseObj);
}

@end
