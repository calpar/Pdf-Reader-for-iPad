//
//  ZoomingMultiPagePDFViewerViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoomingMultiPagePDFViewerViewController.h"
#import "PDFScrollView.h"

@interface ZoomingMultiPagePDFViewerViewController (Private)
    - (void)tilePages;
    - (BOOL)isDisplayingPageForIndex:(NSInteger)index;
    - (void)configurePage:(PDFScrollView *)page forIndex:(int)index;
    - (PDFScrollView *)dequeueRecycledPage;
@end


@implementation ZoomingMultiPagePDFViewerViewController

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

- (void)tilePages
{
    CGRect visibleBounds = [scrollView bounds];
    
    int firstNeededPageIndex = floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxY(visibleBounds)-1) / CGRectGetHeight(visibleBounds));
    
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, self.pageCount -1);

    for (PDFScrollView *pageView in visiblePages) 
    {
        if(pageView.pageIndex < firstNeededPageIndex || pageView.pageIndex > lastNeededPageIndex)
        {
            [recycledPages addObject:pageView];
            [pageView removeFromSuperview];
        }
    }
    
    [visiblePages minusSet:recycledPages];
    
    // Add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) 
    {
        if(![self isDisplayingPageForIndex:index])
        {
            PDFScrollView *page = [self dequeueRecycledPage];
            if(!page)
            {
                page = [[PDFScrollView alloc] initWithFrame:[[self view] bounds] andFileName:@"alice.pdf"];
            }
            [self configurePage:page forIndex:index];
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

- (void)configurePage:(PDFScrollView *)page forIndex:(int)index
{
    page.pageIndex = index;
    page.frame = CGRectMake(0, 768*(index - 1), 1024, 768);
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
    scrollView.contentSize = CGSizeMake(1024, 768*2);
    
    [self.view addSubview:scrollView];
    
    [self tilePages];
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
