//
//  ZoomingMultiPagePDFViewerViewController.h
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomingMultiPagePDFViewerViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    
    int pageCount;
}

@property (nonatomic, assign) int pageCount;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;

@end
