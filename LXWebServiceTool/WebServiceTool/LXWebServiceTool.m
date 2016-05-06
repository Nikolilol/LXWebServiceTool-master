//
//  LXWebServiceTool.m
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "LXWebServiceTool.h"
#import "AFNetworking.h"

@interface LXWebServiceTool()
@end

@implementation LXWebServiceTool
/**
 *  参数
 */
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;

+ (void)requestWithTarget:(id)target SoapMethod:(NSString *)soapMethod parArray:(NSArray *)parArray webServiceUrl:(NSURL *)webServiceUrl
{
    LXWebServiceTool *tool = [[LXWebServiceTool alloc] init];
    [tool webServiceWithSoapMethod:soapMethod parArray:parArray webServiceUrl:webServiceUrl];
    tool.delegate = target;
}


#pragma mark LXWebServiceTool 调用webService的工具
/**
 *  webService 调用
 *
 *  @param soapMethod webservice方法名
 *  @param matchinStr webservice匹配返回结果的关键字
 *  @param parArray   参数列表及参数的值
 */
- (void)webServiceWithSoapMethod:(NSString *)soapMethod parArray:(NSArray *)parArray webServiceUrl:(NSURL *)webServiceUrl
{
    // 1.传入匹配关键字
    matchingElement = [NSString stringWithFormat:@"%@Result", soapMethod];
    // 2.传入参数
    NSMutableString *soapBody = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < (parArray.count) / 2;i ++) {
        NSString *templeString = [NSString stringWithFormat:@"<%@>%@</%@>",[parArray objectAtIndex:i],[parArray objectAtIndex:(i + (parArray.count)/2)],[parArray objectAtIndex:i]];
        [soapBody appendFormat:templeString];
    }
    
    // 3.传入webservice方法名，并创建soap消息主体
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<%@ xmlns=\"http://tempuri.org/\">"
                         "%@"
                         "</%@>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", soapMethod, soapBody,soapMethod];
    NSLog(@"soapMsg = %@",soapMsg);
    // 4. 创建URL，内容是webservice请求报文中第二行主机地址加上第一行URL字段
    NSURL *url = webServiceUrl;
    // 4.1 根据上面的URL创建一个请求
    //    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    // 添加超时请求 10s
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    // 4.2 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 4.3 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 5. 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 6. 创建连接
    //AFNetworking 2.x已过期  AFNetworking3.0已经全面抛弃URLconnection，采用URLSession代替
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject != nil) {
            webData = [NSMutableData data];
            [webData appendData:responseObject];
            // 使用NSXMLParser解析出我们想要的结果
            xmlParser = [[NSXMLParser alloc] initWithData: webData];
            [xmlParser setDelegate: self];
            [xmlParser setShouldResolveExternalEntities: YES];
            [xmlParser parse];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        // delegate
        if ([self.delegate respondsToSelector:@selector(WebServiceToolFailedWithXmlPar:)]) {
            [self.delegate WebServiceToolFailedWithXmlPar:error];
        }
    }];
    [operation start];
}

#pragma mark XML Parser Delegate Methods
// 7. 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if ([elementName isEqualToString:matchingElement]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

// 8. 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
        [soapResults appendString: string];
    }
}

// 9. 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:matchingElement]) {
        elementFound = FALSE;
        // 强制放弃解析
        [xmlParser abortParsing];
        // 利用userdefaults存储获得的数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:soapResults forKey:matchingElement];
        /**
         *  实现代理方法
         */
        if ([self.delegate respondsToSelector:@selector(WebServiceToolFinsihedWithXmlPar:)]) {
            [self.delegate WebServiceToolFinsihedWithXmlPar:soapResults];
        }
    }
}
// 10. 解析整个文件结束后
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    if (soapResults) {
        soapResults = nil;
    }
}
// 11.出错时，例如强制结束解析
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
}
@end
