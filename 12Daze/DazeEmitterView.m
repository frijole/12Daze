//
// DazeEmitterView
// Created by Patrick B. Gibson on 12/10/13
//

#import "DazeEmitterView.h"

@implementation DazeEmitterView

-(id)initWithFrame:(CGRect)frame
{
    
	self = [super initWithFrame:frame];
	if (self) {
        self.backgroundColor = [UIColor blackColor];

        [self setupEmitters];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
	self = [super initWithCoder:aDecoder];
	if (self) {
        self.backgroundColor = [UIColor blackColor];

        [self setupEmitters];
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
    
    self.backgroundColor = [UIColor colorWithRed:1.0f
                                           green:0.83f
                                            blue:0.42f
                                           alpha:0.9f];
    
	emitterLayer.name = @"GlowLayer";
    
	emitterLayer.emitterShape = kCAEmitterLayerRectangle;
	emitterLayer.emitterMode = kCAEmitterLayerSurface;
	emitterLayer.renderMode = kCAEmitterLayerBackToFront;
    
	emitterLayer.seed = 630879317;
    
    emitterLayer.lifetime = 1.0f;
    emitterLayer.opacity = 0.9f;
	
    
    // bubbles!
	CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
	
	emitterCell.name = @"Glow";
    
	emitterCell.contents = (id)[[UIImage imageNamed:@"dot.png"] CGImage];
	emitterCell.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
	emitterCell.scale = 0.2f;
	emitterCell.scaleRange = 0.05f;
	emitterCell.scaleSpeed = 0.0f;
    
    emitterCell.velocity = 35.0f;
    emitterCell.velocityRange = 15.0f;
    
    emitterCell.emissionLongitude = -M_PI/2;
    emitterCell.emissionRange = 0.75f;
    
	emitterCell.color = [[UIColor colorWithWhite:1.0f alpha:0.75f] CGColor];

	emitterCell.alphaRange = 0.2f;
	emitterCell.alphaSpeed = -0.05f;
    
	emitterCell.lifetime = 10.0f;
	emitterCell.lifetimeRange = 5.0f;
	emitterCell.birthRate = 45.0f;
    
    
    emitterLayer.emitterCells = @[emitterCell];
    
    /*
    // and some ambiance?
    CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
	
	emitterCell2.name = @"Glow";
    
	emitterCell2.contents = (id)[[UIImage imageNamed:@"dot.png"] CGImage];
	emitterCell2.contentsRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
	emitterCell2.scale = 10.0f;
    
    emitterCell2.velocity = 0.0f;
    emitterCell2.velocityRange = 0.0f;
    
    emitterCell2.emissionLongitude = -M_PI/2;
    emitterCell2.emissionRange = 0.75f;
    
	emitterCell2.color = [[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor];
    
	emitterCell2.alphaRange = 0.1f;
	emitterCell2.alphaSpeed = -0.005f;
    
	emitterCell2.lifetime = 20.0f;
	emitterCell2.lifetimeRange = 0.0f;
	emitterCell2.birthRate = 1.0f;

    
	emitterLayer.emitterCells = @[emitterCell, emitterCell2];
     */
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)self.layer;
    CGFloat scale = [[UIScreen mainScreen] scale];
    emitterLayer.emitterSize = CGSizeApplyAffineTransform(frame.size, CGAffineTransformMakeScale(scale, scale));
}

@end
