//
//  OMSwitch.m
//  MiaoBo
//
//  Created by kehwa on 16/7/13.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMSwitch.h"

@interface OMSwitch()

@property (nonatomic , strong)UIButton *switchButton;
@property (nonatomic , strong)UILabel *switchTitleLabel;

@property (nonatomic , assign , readwrite)BOOL isOpen;

@end

@implementation OMSwitch{
    NSString *_selectedText;
    NSString *_unselectedText;
    UIColor *_selectedTextColor;
    UIColor *_unselectedTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *selectedImage = [self createImageWithColor:[UIColor redColor]];
        [_switchButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
        UIImage *unselectedImage = [self createImageWithColor:[UIColor grayColor]];
        [_switchButton setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        _switchButton.layer.borderColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:221/255.0 alpha:1.0].CGColor;
        _switchButton.layer.borderWidth = 0.5f;
        _switchButton.layer.masksToBounds = YES;
        _switchButton.layer.cornerRadius = 2;
        _switchButton.selected = YES;
        [_switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_switchButton];
        
    
        _switchTitleLabel = [[UILabel alloc]init];
        _switchTitleLabel.backgroundColor = [UIColor whiteColor];
        _switchTitleLabel.font = [UIFont systemFontOfSize:12];
        _switchTitleLabel.text = @"ON";
        _switchTitleLabel.textColor = self.selectedTextColor;
        _switchTitleLabel.textAlignment = NSTextAlignmentCenter;
        _switchTitleLabel.layer.masksToBounds = YES;
        _switchTitleLabel.layer.cornerRadius = 2;
        [self addSubview:_switchTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _switchButton.frame = self.bounds;
    _switchTitleLabel.frame = CGRectMake(2, 2, self.frame.size.width * 0.7, self.frame.size.height - 4);
    
}

- (void)switchButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    
    [self switchAnimation:button.selected];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSwitch:status:)]) {
        [self.delegate didClickSwitch:self status:button.selected];
    }
}



- (void)switchAnimation:(BOOL)isOpen{
    
    [self showCurrentText];
    [self showCurrentTextColor];
    
    CGFloat x = (self.frame.size.width * 0.3 - 4);
    [UIView animateWithDuration:0.3 animations:^{
        if (!isOpen) {
            _switchTitleLabel.center = CGPointMake(_switchTitleLabel.center.x + x, _switchTitleLabel.center.y);
        }else{
            _switchTitleLabel.center = CGPointMake(_switchTitleLabel.center.x - x, _switchTitleLabel.center.y);
        }
    }];

}

#pragma mark - private method
//图片某一点的颜色
- (UIColor *)colorAtPixel:(UIImage *)image {
    
    CGPoint point = CGPointMake(10, 10);
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        
        return nil;
        
    }
    
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = image.CGImage;
    
    NSUInteger width = image.size.width;
    
    NSUInteger height = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 
                                                 1,
                                                 
                                                 1,
                                                 
                                                 bitsPerComponent,
                                                 
                                                 bytesPerRow,
                                                 
                                                 colorSpace,
                                                 
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

//颜色转图片
- (UIImage *)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)showCurrentText{
    _switchTitleLabel.text = _switchButton.selected?self.selectedText:self.unselectedText;
}

- (void)showCurrentTextColor{
    _switchTitleLabel.textColor = _switchButton.selected?self.selectedTextColor:self.unselectedTextColor;
}


#pragma mark - getters and setters

- (NSString *)selectedText{
    if (_selectedText == nil) {
        _selectedText = @"ON";
    }
    return _selectedText;
}

- (NSString *)unselectedText{
    if (_unselectedText == nil) {
        _unselectedText = @"OFF";
    }
    return _unselectedText;
}

- (UIColor *)selectedTextColor{
    if (_selectedTextColor == nil) {
        _selectedTextColor = [UIColor redColor];
    }
    return _selectedTextColor;
}
- (UIColor *)unselectedTextColor{
    if (_unselectedTextColor == nil) {
        _unselectedTextColor = [UIColor grayColor];
    }
    return _unselectedTextColor;
}


- (void)setSelectedText:(NSString *)selectedText{
    _selectedText = selectedText;
    [self showCurrentText];
}

- (void)setUnselectedText:(NSString *)unselectedText{
    _unselectedText = unselectedText;
    [self showCurrentText];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor{
    _selectedTextColor = selectedTextColor;
    [self showCurrentTextColor];
}

- (void)setUnselectedTextColor:(UIColor *)unselectedTextColor{
    _unselectedTextColor = unselectedTextColor;
    [self showCurrentTextColor];
}

- (void)setSelectedBgColor:(UIColor *)selectedBgColor{
    UIImage *image = [self createImageWithColor:selectedBgColor];
    [self.switchButton setBackgroundImage:image forState:UIControlStateSelected];
}
- (void)setUnselectedBgColor:(UIColor *)unselectedBgColor{
    UIImage *image = [self createImageWithColor:unselectedBgColor];
    [self.switchButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (BOOL)isOpen{
    return _switchButton.selected;
}

@end
