//
//  FaceView.h
//  HappinessFace
//
//  Created by admin on 11/25/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceView : UIView

@property (nonatomic) CGFloat scaleFace;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
