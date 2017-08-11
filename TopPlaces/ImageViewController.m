//
//  ImageViewController.m
//  Imaginarium
//
//  Created by 郝泽 on 2017/7/27.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
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
	CGSize scaled = [self scaledSize:image.size];
    self.imageView.frame = CGRectMake(0, 0, scaled.width, scaled.height);
    self.scrollView.contentSize = image.size;
}

#pragma mark - Lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    [self startDownloadingImage];
}

#pragma mark - Operations
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

- (CGSize)scaledSize:(CGSize)size {
	CGSize boundsSize = self.view.bounds.size;
	CGFloat ratio = size.width / size.height;
	CGFloat newWidth = size.width;
	CGFloat newHeight = size.height;
	if (boundsSize.width > boundsSize.height){
		if (size.height > boundsSize.height) {
			newHeight = boundsSize.height;
			newWidth = newHeight * ratio;
		}
	} else if (size.width > boundsSize.width){
		newWidth = boundsSize.width;
		newHeight = newWidth / ratio;
	}
	return CGSizeMake(newWidth, newHeight);
}

#pragma mark - Scroll View Delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
