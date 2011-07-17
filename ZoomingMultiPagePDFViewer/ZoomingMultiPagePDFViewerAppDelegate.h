//
//  ZoomingMultiPagePDFViewerAppDelegate.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomingMultiPagePDFViewerViewController;

@interface ZoomingMultiPagePDFViewerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ZoomingMultiPagePDFViewerViewController *viewController;

@end
