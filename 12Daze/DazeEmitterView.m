//
// DazeEmitterView
// Created by Patrick B. Gibson on 12/10/13
//

#import "DazeEmitterView.h"

#define limit_generator YES
// #define bypass_intensity YES

@implementation DazeEmitterView

@synthesize intensity=_intensity;

-(id)initWithFrame:(CGRect)frame
{
    
	self = [super initWithFrame:frame];
	if (self) {
        
        self.backgroundColor = kDazeEmitterViewDefaultBackgroundColor;
        self.sparkle = YES;
        self.intensity = DazeEmitterViewIntensityMedium;

	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
	self = [super initWithCoder:aDecoder];
	if (self) {

        self.backgroundColor = kDazeEmitterViewDefaultBackgroundColor;
        self.sparkle = YES;
        self.intensity = DazeEmitterViewIntensityMedium;

	}
	
	return self;
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

-(void)awakeFromNib
{
    [self setupEmitters];
}

- (void)setupEmitters
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;

	emitterLayer.name = @"bubbleLayer";
    
    // "The emission shape is a one, two or three dimensional shape that defines where the emitted particles originate. The shapes are defined by a subset of emitterPosition, emitterZPosition, emitterSize and emitterDepth properties."
	emitterLayer.emitterShape = kCAEmitterLayerRectangle;
#ifndef limit_generator
    emitterLayer.emitterSize = CGSizeMake(CGRectGetWidth(self.frame)*2.0f, CGRectGetHeight(self.frame)*2.0f);
    emitterLayer.emitterPosition = CGPointMake(0.0f, 0.0f);
#else
    emitterLayer.emitterSize = CGSizeMake(self.frame.size.width*2.0f, 50.0f);
    emitterLayer.emitterPosition = CGPointMake(0.0f, self.frame.size.height);
#endif
    
    emitterLayer.emitterMode = kCAEmitterLayerSurface;
	emitterLayer.renderMode = kCAEmitterLayerBackToFront;
    
	emitterLayer.seed = 630879317;
    
    emitterLayer.lifetime = 1.0f;
    // emitterLayer.opacity = 0.9f;

    emitterLayer.backgroundColor = self.backgroundColor.CGColor;
    
    
    // bubbles!
	CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
	
	emitterCell.name = @"bubbleCell";
    
    UIImage *tmpParticleImage = self.particleImage?:kDazeEmitterViewDefaultParticleImage;
	emitterCell.contents = (id)tmpParticleImage.CGImage;
	emitterCell.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00);
    
	emitterCell.scale = 0.10;
	emitterCell.scaleRange = 0.00;
	emitterCell.scaleSpeed = 0.10;
    
	emitterCell.emissionLatitude = 0.0;
	emitterCell.emissionLongitude = -M_PI/2;
	emitterCell.emissionRange = 0.000;
    
    UIColor *tmpParticleColor = self.particleColor?:kDazeEmitterViewDefaultParticleColor;
    emitterCell.color = tmpParticleColor.CGColor;
    
	emitterCell.lifetime = 5.0;
	emitterCell.lifetimeRange = 1.5;
	emitterCell.birthRate = (250.0f/320.0f)*self.frame.size.width;

    // see if we want to add a little extra
    if ( self.sparkle )
    {
        emitterCell.velocity = 250.00;
        emitterCell.velocityRange = 50.00;
        
        emitterCell.spin = M_PI;
        emitterCell.spinRange = M_PI/2;
        
        emitterCell.alphaRange = 0.20;
        emitterCell.alphaSpeed = 0.10;
    }

    if ( !self.ambiance )
    {
        emitterLayer.emitterCells = @[emitterCell];
    }
    else // and some ambiance?
    {
        CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
        
        emitterCell2.name = @"ambiance";
        
        UIImage *tmpParticleImage = self.particleImage?:kDazeEmitterViewDefaultParticleImage;
        emitterCell2.contents = (id)[tmpParticleImage CGImage];
        emitterCell2.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        
        emitterCell2.scale = 10.0f;
        emitterCell2.scaleRange = 0.0f;
        emitterCell2.scaleSpeed = 1.0f;
        
        emitterCell2.velocity = 200.0f;
        emitterCell2.velocityRange = 25.0f;
        
        emitterCell2.emissionLongitude = +M_PI/2;
        emitterCell2.emissionRange = 0.0f;
        
        emitterCell.spin = (3.0f*M_PI)/4.0f;
        emitterCell.spinRange = 2*M_PI;
        
        emitterCell2.color = [[UIColor colorWithWhite:1.0f alpha:0.15f] CGColor];
        
        emitterCell2.alphaRange = 0.1f;
        emitterCell2.alphaSpeed = -0.025f;
        
        emitterCell2.lifetime = 20.0f;
        emitterCell2.lifetimeRange = 0.0f;
        emitterCell2.birthRate = 5.0f;
        
        
        emitterLayer.emitterCells = @[emitterCell, emitterCell2];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setupEmitters];
    
#ifdef limit_generator
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;
    emitterLayer.emitterSize = CGSizeMake(self.frame.size.width*2.0f, 50.0f);
    emitterLayer.emitterPosition = CGPointMake(self.frame.size.height>200.0f?50.0f:0.0f, self.frame.size.height);
#endif
}

#pragma mark - Property Overrides

- (void)setSparkle:(BOOL)sparkle
{
    _sparkle = sparkle;
    
    [self setupEmitters];
}

- (void)setAmbiance:(BOOL)ambiance
{
    _ambiance = ambiance;
    
    [self setupEmitters];
}

- (void)setIntensity:(DazeEmitterViewIntensity)intensity
{
#ifdef bypass_intensity
    _intensity = DazeEmitterViewIntensityMedium;
    [self setupEmitters];
    return;
#endif

    if ( intensity < 1.0f )
        intensity = 0.0f;
    
    // stash the current intensity to check for a change
    DazeEmitterViewIntensity tmpPreviousIntensity = _intensity;
    
    // set the new intensity
    _intensity = intensity;

    // and check to see if it was previously set, and if so, if it changed
    // and adjust the emitters if necessary.
    if ( tmpPreviousIntensity && tmpPreviousIntensity != _intensity ) {

        // [self setupEmitters];
        
        NSLog(@"Changing Intensity: %ld", (long)intensity);

        CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;
        
        CAEmitterCell *emitterCell = [[emitterLayer emitterCells] firstObject];
        
        if ( emitterCell ) {
            
            CGFloat tmpVelocity = 125.0f+(25.0f*intensity);
            [emitterLayer setValue:[NSNumber numberWithFloat:tmpVelocity] forKeyPath:@"emitterCells.bubbleCell.velocity"];
            // emitterCell.velocity = tmpVelocity;
            
            CGFloat tmpSpin = (((intensity/5.0f)*M_PI)/2.0f)+(M_PI/2.0f);
            [emitterLayer setValue:[NSNumber numberWithFloat:tmpSpin] forKeyPath:@"emitterCells.bubbleCell.spin"];
            //emitterCell.spin = tmpSpin;
            
            CGFloat tmpBirthrate = ((250.0f/320.0f)*self.frame.size.width)*(_intensity/10.0f);
            [emitterLayer setValue:[NSNumber numberWithFloat:tmpBirthrate] forKeyPath:@"emitterCells.bubbleCell.birthRate"];
            // emitterCell.birthRate = tmpBirthrate;

            CGFloat tmpScale = 2.0f*(1.0f/(2.0F*intensity)); // emitterCell.scale; // 2.0f*(2.0f/self.intensity+1.0f);
            [emitterLayer setValue:[NSNumber numberWithFloat:tmpScale] forKeyPath:@"emitterCells.bubbleCell.scale"];
            // emitterCell.scale = tmpScale;
            
            UIColor *tmpColor = [UIColor colorWithWhite:1.0f alpha:(_intensity/10.0f)];
            [emitterCell setValue:(id)tmpColor.CGColor forKey:@"emitterCells.bubbleCell.color"];
            // emitterCell.color = tmpColor.CGColor;
            
            CGFloat tmpWhite = -1.0f;
            CGFloat tmpAlpha = -1.0f;
            [tmpColor getWhite:&tmpWhite alpha:&tmpAlpha];
            
            NSLog(@"    Velocity: %f",emitterCell.velocity);
            NSLog(@"        Spin: %f",emitterCell.spin);
            NSLog(@"   Birthrate: %f",emitterCell.birthRate);
            NSLog(@"       Scale: %f",emitterCell.scale);
            NSLog(@"       Alpha: %f",tmpAlpha);
            
            // emitterLayer.emitterCells = @[emitterCell];
        }

        NSLog(@" ");
    }
}

@end
