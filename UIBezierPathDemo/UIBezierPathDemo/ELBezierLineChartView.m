//
//  ELBezierLineChartView.m
//  UIBezierPathDemo
//
//  Created by EL on 2017/6/22.
//  Copyright © 2017年 etouch. All rights reserved.
//

#import "ELBezierLineChartView.h"

@implementation ELBezierLineChartView{
    CGFloat     _axisLineWidth;
    CGFloat     _axisToViewPadding;
    CGFloat     _axisPadding;
    CGFloat     _xAxisSpacing;
    CGFloat     _yAxisSpacing;
    NSInteger   _fontSize;
    
    CAShapeLayer *_bezierLineLayer;
    
    NSArray     *_xAxisInformationArray;
    NSArray     *_yAxisInformationArray;
    NSArray     *_pointYArray;
    NSMutableArray  *_pointsArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _axisLineWidth = 1;
        _fontSize = 11;
        _axisToViewPadding = 30;
        _axisPadding = 30;
        _xAxisInformationArray = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        _yAxisInformationArray = @[@"不佳", @"平平", @"还行", @"不错", @"极佳"];
        _xAxisSpacing = (CGRectGetWidth(self.frame) - _axisToViewPadding - _axisPadding) / _xAxisInformationArray.count;
        _yAxisSpacing = (CGRectGetHeight(self.frame) - _axisToViewPadding) / _yAxisInformationArray.count;
        _pointYArray = @[@(1), @(4), @(1), @(5), @(2), @(3), @(5)];
        _pointsArray = @[].mutableCopy;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self drawAxisLine];
    [self drawAxisInformation];
    [self drawBezierPath];
}

- (void)drawAxisLine{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, _axisLineWidth);
    // yAxis
    CGContextMoveToPoint(context, _axisToViewPadding, 0);
    CGContextAddLineToPoint(context, _axisToViewPadding, CGRectGetHeight(self.frame) - _axisToViewPadding);
    CGContextStrokePath(context);
    // xAxis
    CGContextMoveToPoint(context, _axisToViewPadding, CGRectGetHeight(self.frame) - _axisToViewPadding);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _axisToViewPadding);
    CGContextStrokePath(context);
}

- (void)drawAxisInformation{
    [_xAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算文字尺寸
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
        CGSize informationSize = [self getTextSizeWithText:obj fontSize:_fontSize maxSize:CGSizeMake(MAXFLOAT, _fontSize)];
        // 计算绘制起点
        float drawStartPointX = _axisToViewPadding + idx * _xAxisSpacing - informationSize.width/2 + 30;
        float drawStartPointY = CGRectGetHeight(self.frame) - _axisToViewPadding + (_axisToViewPadding - informationSize.height) / 2.0;
        CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY);
        // 绘制文字信息
        [obj drawAtPoint:drawStartPoint withAttributes:attributes];
    }];
    
    // y轴
    [_yAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算文字尺寸
        UIFont *informationFont = [UIFont systemFontOfSize:_fontSize];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
        attributes[NSFontAttributeName] = informationFont;
        if (!obj) {
            obj = @"";
        }
        CGSize informationSize = [self getTextSizeWithText:obj fontSize:_fontSize maxSize:CGSizeMake(MAXFLOAT, _fontSize)];
        // 计算绘制起点
        float drawStartPointX = 0;
        float drawStartPointY = CGRectGetHeight(self.frame) - _axisToViewPadding - idx * _yAxisSpacing - informationSize.height * 0.5 - 11;
        CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY);
        // 绘制文字信息
        [obj drawAtPoint:drawStartPoint withAttributes:attributes];
    }];
}

- (void)drawBezierPath{
    [_pointYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger objInter = 1;
        if ([obj respondsToSelector:@selector(integerValue)]) {
            objInter = [obj integerValue];
        }
        if ([obj respondsToSelector:@selector(integerValue)]) {
            objInter = [obj integerValue];
            if (objInter < 1) {
                objInter = 1;
            } else if (objInter > 5) {
                objInter = 5;
            }
        }
        CGPoint point = CGPointMake(_xAxisSpacing * idx + _axisToViewPadding + 30, CGRectGetHeight(self.frame) - _axisToViewPadding - (objInter - 1) * _yAxisSpacing - 11);
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
        [_pointsArray addObject:value];
    }];
    NSValue *firstPointValue = [NSValue valueWithCGPoint:CGPointMake(_axisToViewPadding, (CGRectGetHeight(self.frame) - _axisToViewPadding) / 2)];
    [_pointsArray insertObject:firstPointValue atIndex:0];
    NSValue *endPointValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame), (CGRectGetHeight(self.frame) - _axisToViewPadding) / 2)];
    [_pointsArray addObject:endPointValue];
    /** 折线路径 */
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < 6; i++) {
        CGPoint p1 = [[_pointsArray objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[_pointsArray objectAtIndex:i+1] CGPointValue];
        CGPoint p3 = [[_pointsArray objectAtIndex:i+2] CGPointValue];
        CGPoint p4 = [[_pointsArray objectAtIndex:i+3] CGPointValue];
        if (i == 0) {
            [path moveToPoint:p2];
        }
        [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
    }
    /** 将折线添加到折线图层上，并设置相关的属性 */
    _bezierLineLayer = [CAShapeLayer layer];
    _bezierLineLayer.path = path.CGPath;
    _bezierLineLayer.strokeColor = [UIColor redColor].CGColor;
    _bezierLineLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    _bezierLineLayer.lineWidth = 3;
    _bezierLineLayer.lineCap = kCALineCapRound;
    _bezierLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_bezierLineLayer];
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}


- (CGSize)getTextSizeWithText:(NSString *)text fontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize{
    CGSize size = CGSizeZero;
    if(text.length > 0){
        size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

@end
