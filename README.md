LXWebServiceTool is a easey tool to request webservice with soap protcol.

# How to use

Copy WebServiceTool fold to your project. 
Note: This fold includes AFNetworking 2.x and XMLDictionary;

```
#import "LXWebServiceTool.h"
    NSArray *parArray = @[@"sText", _titleLabel.text];
    [LXWebServiceTool requestWithNameSpace:@"http://webxml.com.cn/" SoapMthod:@"toTraditionalChinese" parArray:parArray webServiceUrl:[NSURL URLWithString: @"http://www.webxml.com.cn/WebServices/TraditionalSimplifiedWebService.asmx"] success:^(NSString *methodName, id responseObject) {
      //This block will return methodName & responseObject
        NSLog(@"methodName = %@\nresponseObjecct = %@", methodName, responseObject);
        _titleLabel.text = responseObject;
    } errorBlock:^(NSString *methodName, NSError *error) {
      //This block will return methodName & error
        NSLog(@"methodName = %@\nerror = %@", methodName, error);
        _titleLabel.text = [NSString stringWithFormat:@"methodName = %@\nerror = %@", methodName, error];
    }];
```

# LXWebServiceTool

This is a free tool based on AFNetWork. It was used for request webservice through SOAP message, if you have any question, please feel free to contract me.
