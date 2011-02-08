//
//  SCAddressBarDemoViewController.m
//  SSCatalog
//
//  Created by Sam Soffes on 2/8/11.
//  Copyright 2011 Sam Soffes. All rights reserved.
//

#import "SCAddressBarDemoViewController.h"

@implementation SCAddressBarDemoViewController

#pragma mark Class Methods

+ (NSString *)title {
	return @"Address bar";
}


#pragma mark NSObject

- (void)dealloc {
	_webView.delegate = nil;
	[_webView release];
	[_headerView release];
	[_titleLabel release];
	[_addressBar release];
	[super dealloc];
}


#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = [[self class] title];
	self.view.backgroundColor = [UIColor colorWithRed:0.851 green:0.859 blue:0.882 alpha:1.0];
	
	_headerView = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 58.0f)];
	_headerView.topColor = [UIColor colorWithWhite:0.957f alpha:1.0f];
	_headerView.bottomColor = [UIColor colorWithWhite:0.827f alpha:1.0f];
	_headerView.bottomBorderColor = [UIColor colorWithWhite:0.369f alpha:1.0f];
	_headerView.hasTopBorder = NO;
	_headerView.hasBottomBorder = YES;
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 21.0f)];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.textColor = [UIColor colorWithWhite:0.404f alpha:1.0f];
	_titleLabel.textAlignment = UITextAlignmentCenter;
	_titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
	_titleLabel.shadowColor = [UIColor whiteColor];
	_titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	[_headerView addSubview:_titleLabel];
	
	_addressBar = [[SSAddressBarTextField alloc] initWithFrame:CGRectMake(10.0f, 21.0f, 300.0f, 31.0f)];
	_addressBar.delegate = self;
	[_headerView addSubview:_addressBar];
	
	[self.view addSubview:_headerView];
	
	_webView = [[SSWebView alloc] initWithFrame:CGRectMake(0.0f, 58.0f, 320.0f, self.view.frame.size.height - 58.0f)];
	_webView.scalesPageToFit = YES;
	_webView.delegate = self;
	[self.view addSubview:_webView];
	
	[_addressBar.refreshButton addTarget:_webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
	[_addressBar.stopButton addTarget:_webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
	
	[_webView loadURLString:@"http://samsoff.es"];
}


#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_removeGrayView) object:nil];
	
	// Gray Button
//	UIButton *aGrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	aGrayButton.frame = _webView.frame;
//	aGrayButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//	aGrayButton.alpha = 0.0;
//	aGrayButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	[aGrayButton addTarget:textField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
//	self.grayButton = aGrayButton;
//	[self.view addSubview:grayButton];
//	[grayButton fadeIn];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
//	[self performSelector:@selector(_removeGrayView) withObject:nil afterDelay:0.1];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[_webView loadURLString:textField.text];
	[textField resignFirstResponder];
	return YES;
}


#pragma mark SSWebViewDelegate

- (void)webViewDidStartLoadingPage:(SSWebView *)aWebView {
	_addressBar.loading = YES;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString *urlString = [[[_webView lastRequest] mainDocumentURL] absoluteString];
	NSString *addressBarUrlString = urlString; // [urlString stringByReplacingOccurrencesOfRegex:@"^https?://" withString:@""];
	_addressBar.text = addressBarUrlString;
	_titleLabel.text = urlString;
}


- (void)webViewDidFinishLoadingPage:(SSWebView *)aWebView {
	_addressBar.loading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	if (title) {
		_titleLabel.text = title;
	}
}


- (void)webView:(SSWebView *)aWebView didFailLoadWithError:(NSError *)error {
	_addressBar.loading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
