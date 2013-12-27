//
// DazeEmitterView
// Created by Patrick B. Gibson on 12/10/13
//

#import "DazeEmitterView.h"

@implementation DazeEmitterView

@synthesize intensity=_intensity;

-(id)initWithFrame:(CGRect)frame
{
    
	self = [super initWithFrame:frame];
	if (self) {
        
        self.backgroundColor = kDazeEmitterViewDefaultBackgroundColor;
        self.sparkle = YES;
        
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
	self = [super initWithCoder:aDecoder];
	if (self) {

        self.backgroundColor = kDazeEmitterViewDefaultBackgroundColor;
        self.sparkle = YES;

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
    emitterLayer.emitterSize = CGSizeMake(self.frame.size.width*2.0f, 50.0f);
    emitterLayer.emitterPosition = CGPointMake(0.0f, 550.0f);
	
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
	emitterCell.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
	emitterCell.scale = 0.2f;
	emitterCell.scaleRange = 0.05f;
	emitterCell.scaleSpeed = 0.005f;
    
    emitterCell.emissionLongitude = -M_PI/2;
    emitterCell.emissionLatitude = 0.0f;
    emitterCell.emissionRange = 0.0f;
    
    UIColor *tmpParticleColor = self.particleColor?:kDazeEmitterViewDefaultParticleColor;
    emitterCell.color = tmpParticleColor.CGColor;
    
	emitterCell.lifetime = 5.0f;
	emitterCell.lifetimeRange = 1.5f;
	emitterCell.birthRate = self.frame.size.width*(0.125*self.intensity);

    // see if we want to add a little extra
    if ( self.sparkle )
    {
        emitterCell.velocity = 25.0f*self.intensity;
        emitterCell.velocityRange = 5.0f*self.intensity;
        
        emitterCell.spin = (0.15*self.intensity)*M_PI;
        emitterCell.spinRange = M_PI/2.0f;
        
        emitterCell.alphaRange = 0.25f;
        emitterCell.alphaSpeed = 0.05f;
    }

    if ( !self.ambiance )
    {
        emitterLayer.emitterCells = @[emitterCell];
    }
    else
    {
        // and some ambiance?
        CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
        
        emitterCell2.name = @"ambiance";
        
        UIImage *tmpParticleImage = self.particleImage?:kDazeEmitterViewDefaultParticleImage;
        emitterCell2.contents = (id)[tmpParticleImage CGImage];
        emitterCell2.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        
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
    
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;
    emitterLayer.emitterSize = CGSizeMake(self.frame.size.width*2.0f, 50.0f);
    emitterLayer.emitterPosition = CGPointMake(self.frame.size.height>200.0f?50.0f:0.0f, self.frame.size.height);
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

- (DazeEmitterViewIntensity)intensity
{
    if ( !_intensity )
        _intensity = DazeEmitterViewIntensityMedium;
    
    return _intensity;
}

- (void)setIntensity:(DazeEmitterViewIntensity)intensity
{
    // stash the current intensity to check for a change
    DazeEmitterViewIntensity tmpPreviousIntensity = _intensity;
    
    // set the new intensity
    _intensity = intensity;

    // and check to see if it was previously set, and if so, if it changed
    // and adjust the emitters if necessary.
    if ( tmpPreviousIntensity && tmpPreviousIntensity != _intensity )
       [self setupEmitters];
}

@end
