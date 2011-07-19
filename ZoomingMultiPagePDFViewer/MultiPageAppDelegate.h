//
//  ZoomingMultiPagePDFViewerAppDelegate.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@interface MultiPageAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PageViewController *viewController;

@end
