//
//  PHPBMasterViewController.m
//  12Daze
//
//  Created by Patrick B. Gibson on 12/10/13.
//  Copyright (c) 2013 fadeover.org. All rights reserved.
//

#import "PHPBMasterViewController.h"


@interface PHPBMasterViewController ()
@end

@implementation PHPBMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateLabels];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabels
{
    [self.intensityLabel setText:[self trimString:[NSString stringWithFormat:@"%f",self.intensitySlider.value]]];
    
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.dazeView.layer;
    
    CAEmitterCell *emitterCell = [[emitterLayer emitterCells] firstObject];
    
    if ( emitterCell )
    {
        [self.speedLabel        setText:[self trimString:[NSString stringWithFormat:@"%f",emitterCell.velocity]]];
        [self.spinLabel         setText:[self trimString:[NSString stringWithFormat:@"%f",emitterCell.spin]]];
        [self.birthrateLabel    setText:[self trimString:[NSString stringWithFormat:@"%f",emitterCell.birthRate]]];
        [self.scaleLabel        setText:[self trimString:[NSString stringWithFormat:@"%f",emitterCell.scale]]];
        
        // get components of the color (init with -1 for unset)
        CGFloat tmpWhite = -1.0f;
        CGFloat tmpAlpha = -1.0f;
        [[UIColor colorWithCGColor:emitterCell.color] getWhite:&tmpWhite alpha:&tmpAlpha];
        
        [self.opacityLabel      setText:[self trimString:[NSString stringWithFormat:@"%f",tmpAlpha]]];
    }
}

- (IBAction)sliderChanged:(UISlider *)slider
{
    CGFloat tmpValue = slider.value;
    
    // gotta go all the way to the end to turn it off
    if ( tmpValue > 0.0f && tmpValue < 1.5f )
        tmpValue = 1.0f;
    
    [self.dazeView setIntensity:tmpValue];

    [self updateLabels];
}

- (IBAction)sliderDone:(UISlider *)sender
{
    CGFloat tmpValue = sender.value;

    if ( tmpValue > 0.0f && tmpValue < 1.5f )
        tmpValue = 1.0f;

    tmpValue = roundf(tmpValue);
    
    [sender setValue:tmpValue animated:YES];
    
    [self sliderChanged:sender];
}

- (NSString *)trimString:(NSString *)string
{
    NSString *rtnString = string;
    
    if ( rtnString.length > 4 )
        rtnString = [rtnString substringToIndex:4];

    return rtnString;
}


@end
