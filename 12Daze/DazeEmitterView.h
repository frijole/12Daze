//
// DazeEmitterView
// Created by Patrick B. Gibson on 12/10/13
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// champagne
#define kDazeEmitterViewDefaultBackgroundColor [UIColor colorWithRed:247/255.0f green:231/255.0f blue:206/255.0f alpha:1.0f];

// water
// #define kDazeEmitterViewDefaultBackgroundColor [UIColor colorWithRed:77/255.0f green:170/255.0f blue:213/255.0f alpha:1.0f];

#define kDazeEmitterViewDefaultParticleColor [UIColor colorWithWhite:1.0f alpha:0.5f]
#define kDazeEmitterViewDefaultParticleImage [UIImage imageNamed:@"dot.png"]

// Intensity from 0-10
// Use enums for preset levels.
typedef NS_ENUM(NSInteger, DazeEmitterViewIntensity) {
    DazeEmitterViewIntensityDead = 0,
    DazeEmitterViewIntensityLow = 1,
    DazeEmitterViewIntensityMedium = 5, // default
    DazeEmitterViewIntensityHigh = 10
};

@interface DazeEmitterView : UIView

@property UIColor *backgroundColor;
// default: kDazeEmitterViewDefaultBackgroundColor

@property UIColor *particleColor;
// default: kDazeEmitterViewDefaultParticleColor

@property UIImage *particleImage;
// default: kDazeEmitterViewDefaultParticleImage

@property (nonatomic) BOOL sparkle;
// default: YES
// description: varies alpha and size slightly for a magical effect

@property (nonatomic) BOOL ambiance;
// default: NO
// description: uses some large, low-alpha particles to add general shadows/highlights

@property (nonatomic) DazeEmitterViewIntensity intensity;
// default: DazeEmitterViewIntensityMedium
// description: varies speed and density of particle emitter
// tip: use DazeEmitterIntensityLow when you're working on other parts of an app ;) 

@end