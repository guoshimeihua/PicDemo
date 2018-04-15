//
//  BlurPicView.m
//  PicDemo
//
//  Created by Bruce on 2018/4/11.
//  Copyright © 2018年 Bruce. All rights reserved.
//

#import "BlurPicView.h"

@interface UIImage (Blur)

+ (UIImage *)coreBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius;

@end

@implementation UIImage (Blur)

+ (UIImage *)coreBlurImage:(UIImage *)image blurRadius:(CGFloat)blurRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blurRadius) forKey: @"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    NSLog(@"result extent rect : %@", NSStringFromCGRect([inputImage extent]));
    CGImageRef outImage = [context createCGImage:result fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

@end

@interface BlurPicView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *blurImgView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation BlurPicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"timg.jpeg"];
        CGFloat scale = image.size.height / image.size.width;
        CGFloat imgH = frame.size.width * scale;
        CGRect rect = CGRectMake(0, 0, frame.size.width, imgH);
        
        self.blurImgView = [UIImageView new];
        self.blurImgView.contentMode = UIViewContentModeScaleToFill;
        self.blurImgView.clipsToBounds = YES;
        self.blurImgView.userInteractionEnabled = YES;
        self.blurImgView.frame = rect;
        self.blurImgView.center = self.center;
        [self addSubview:self.blurImgView];
        
        self.imgView = [UIImageView new];
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        self.imgView.clipsToBounds = YES;
        self.imgView.userInteractionEnabled = YES;
        self.imgView.frame = rect;
        self.imgView.center = self.center;
        [self addSubview:self.imgView];
    }
    return self;
}

- (void)blur {
    UIImage *image = [UIImage imageNamed:@"timg.jpeg"];
    UIImage *blurImage = [UIImage coreBlurImage:image blurRadius:10];
    
    self.blurImgView.image = blurImage;
    self.imgView.image = image;
    
    CGPoint center = CGPointMake(self.imgView.frame.size.width/2.0, self.imgView.frame.size.height/2.0);
    CAShapeLayer *shapeLayer = [self getShapeLayerWithPoint:center];
    self.imgView.layer.mask = shapeLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.imgView];
    NSLog(@"point : %@", NSStringFromCGPoint(point));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.shapeLayer.path = path.CGPath;
    self.imgView.layer.mask = self.shapeLayer;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.imgView];
    NSLog(@"point : %@", NSStringFromCGPoint(point));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.shapeLayer.path = path.CGPath;
    self.imgView.layer.mask = self.shapeLayer;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint center = CGPointMake(self.imgView.frame.size.width/2.0, self.imgView.frame.size.height/2.0);
    CAShapeLayer *shapeLayer = [self getShapeLayerWithPoint:center];
    self.imgView.layer.mask = shapeLayer;
}

- (CAShapeLayer *)getShapeLayerWithPoint:(CGPoint)point {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 1.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}

- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.lineWidth = 100.0;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
    }
    return _shapeLayer;
}

@end
