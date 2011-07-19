//
//  ZoomingMultiPagePDFViewerViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageViewController.h"
#import "PDFScrollView.h"

@interface PageViewController (Private)
    - (void)tilePages;
    - (BOOL)isDisplayingPageForIndex:(NSInteger)index;
    - (PDFScrollView *)dequeueRecycledPage;
@end

@implementation PageViewController

@synthesize recycledPages;
@synthesize visiblePages;
@synthesize scrollView;
@synthesize pageCount;

- (void)dealloc
{
    [scrollView release];
    
    [recycledPages release];
    [visiblePages release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    [self tilePages];
}

- (void)tilePages
{
    CGRect visibleBounds = [scrollView bounds];
    
    int firstNeededPageIndex = (floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds))) - 1;
    int lastNeededPageIndex = firstNeededPageIndex + 2;
    
    firstNeededPageIndex = MAX(firstNeededPageIndex, 1);
    lastNeededPageIndex = MIN(lastNeededPageIndex, self.pageCount);

    for (PDFScrollView *pageView in visiblePages) 
    {
        if(pageView.pageIndex < firstNeededPageIndex || pageView.pageIndex > lastNeededPageIndex)
        {
            [recycledPages addObject:pageView];
            [pageView removeFromSuperview];
        }
    }
    
    [visiblePages minusSet:recycledPages];
    
    [recycledPages removeAllObjects];
    
    // Add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) 
    {
        if(![self isDisplayingPageForIndex:index])
        {
            PDFScrollView *page = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, 748 * (index - 1), 1024, 748) 
                                                           andFileName:@"alice.pdf" 
                                                              withPage:index];
            [scrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }
}

- (PDFScrollView *)dequeueRecycledPage
{
    PDFScrollView *page = [recycledPages anyObject];
    if(page)
    {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index
{
    for (PDFScrollView *page in visiblePages) 
    {
        if (page.pageIndex == index) 
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // http://stackoverflow.com/questions/4732386/how-to-find-the-total-number-of-pages-in-pdf-file-loaded-in-objective-c
    NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"alice.pdf" withExtension:nil];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    self.pageCount = CGPDFDocumentGetNumberOfPages(pdf);
    
    visiblePages = [[NSMutableSet alloc] init];
    recycledPages = [[NSMutableSet alloc] init];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, 1024, 768);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(1024, 768 * pageCount);
    [self.view addSubview:scrollView];
    
    PDFScrollView *pageA = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748) 
                                                           andFileName:@"alice.pdf" withPage:1];
    
    PDFScrollView *pageB = [[PDFScrollView alloc] initWithFrame:CGRectMake(0, 748 * 1, 1024, 748) 
                                                   andFileName:@"alice.pdf" withPage:2];
    
    [scrollView addSubview:pageA];
    [visiblePages addObject:pageA];
    [scrollView addSubview:pageB];
    [visiblePages addObject:pageB];
    
    //[self tilePages];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
