//
//  PHPBMasterViewController.h
//  12Daze
//
//  Created by Patrick B. Gibson on 12/10/13.
//  Copyright (c) 2013 fadeover.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DazeEmitterView.h"

@interface PHPBMasterViewController : UIViewController

@property (nonatomic, weak) IBOutlet DazeEmitterView *dazeView;

@property (nonatomic, weak) IBOutlet UISlider *intensitySlider;
@property (nonatomic, weak) IBOutlet UILabel  *intensityLabel;

@property (nonatomic, weak) IBOutlet UILabel  *spinLabel;
@property (nonatomic, weak) IBOutlet UILabel  *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel  *birthrateLabel;
@property (nonatomic, weak) IBOutlet UILabel  *scaleLabel;
@property (nonatomic, weak) IBOutlet UILabel  *opacityLabel;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderDone:(id)sender;

@end
