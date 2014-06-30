//
//  GPUImageWaveFilter.h
//  GPUImageWaveFilterDemo
//
//  Created by 杨晨 on 6/28/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUImageWaveFilter : GPUImageFilter {
  GLint _normalizedPhaseUniform;
}

@property (nonatomic, assign) CGFloat normalizedPhase;

@end
