//
//  ZoomingMultiPagePDFViewerViewController.m
//  ZoomingMultiPagePDFViewer
//
//  Created by dogan kaya berktas on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoomingMultiPagePDFViewerViewController.h"
#import "PDFScrollView.h"

@implementation ZoomingMultiPagePDFViewerViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 0, 1024, 768);
    scroll.pagingEnabled = YES;
    scroll.scrollEnabled = YES;
    
    NSString *pdfFileName = @"alice.pdf";
    
    PDFScrollView *sv = [[PDFScrollView alloc] initWithFrame:[[self view] bounds] andFileName:pdfFileName];
    sv.pageIndex = 1;
    sv.frame = CGRectMake(0, 0, 1024, 768);

    [scroll addSubview:sv];    
    
    PDFScrollView *sv2 = [[PDFScrollView alloc] initWithFrame:[[self view] bounds] andFileName:pdfFileName];
    sv2.pageIndex = 2;
    sv2.frame = CGRectMake(0, 768, 1024, 768);
    [scroll addSubview:sv2];

    scroll.contentSize = CGSizeMake(1024, 768*2);
    
    [self.view addSubview:scroll];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
