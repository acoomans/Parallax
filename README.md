# Parallax

Parallax is an iOS library that reproduces the parallax effect of the iOS7 home screen.

## Dependencies

- QuartzCore
- CoreMotion

## Usage

1. Add the _Parallax_ directory into your project.
2. Add `#import "ACParallax.h"` to your view controller.
3. Add a _ACParallax_ view and start the parallax effect with `parallaxView.parallax = YES;`

Optional:

If you want a delegate to be notified of begin/end parallax effect and changes in the motion attitude:
    
    parallaxView.parallaxDelegate = self;
    
    
If you want the parallax view to refocus slowly and automatically:

    parallaxView.refocusParallax = YES;
    
## Screenshot

![screenshots](https://raw.github.com/acoomans/Parallax/master/ParallaxDemo/parallax.gif)

## Bugs

- Device pitch is not handled correctly; behaves weirdly when the device is held straight up.
- Some implementations details missing (see TODOs)


## Credits

[San Francisco Bridge by Jeff Gunn (Creative Commons)](http://www.flickr.com/photos/jeffgunn/6663234085/)