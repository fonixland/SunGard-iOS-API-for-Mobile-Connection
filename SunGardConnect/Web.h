//
//  WebView.h
//  New 2 WIT
//
//  Created by Sonny on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Web : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    
    IBOutlet UIActivityIndicatorView *spinner;
}
@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain)IBOutlet UIWebView *webView;
@end
