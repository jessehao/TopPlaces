//
//  ImageViewController.m
//  Imaginarium
//
//  Created by 郝泽 on 2017/7/27.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (UITabBarController *)masterTabbarController {
	return self.splitViewController.viewControllers.firstObject;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UIImage *)image {
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image {
    self.scrollView.zoomScale = 1.0;
    [self.spinner stopAnimating];
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = image.size;
}

-(void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	self.navigationItem.leftItemsSupplementBackButton = YES;
	self.splitViewController.delegate = self;
    [self.scrollView addSubview:self.imageView];
    [self startDownloadingImage];
}

-(void)startDownloadingImage {
    self.image = nil;
    if (self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionTask *task = [session downloadTaskWithRequest:request
                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (!error) {
                                                        if ([request.URL isEqual:self.imageURL]) {
                                                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                self.image = image;
                                                            });
                                                        }
                                                    }
                                                }];
        [task resume];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
