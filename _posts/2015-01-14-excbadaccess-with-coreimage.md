---
layout: post
title: "EXC_BAD_ACCESS When Using CoreImage"
date: 2015-01-14 13:40:00 -0500
categories: ios coreimage xcode swift
redirect_from: /108096113846/excbadaccess-when-using-coreimage
---

I'm working on an iOS app, in Swift. In general, I _love_ Swift. Xcode is still learning some things about it, but in general, it's simply fantastic.

Which is why it can be so frustrating when Swift, or Xcode when compiling it, gives you an annoying, useless error message, like `EXC_BAD_ACCESS`, and gives you no more information about it. 

(*tldr;* Swift extensions to `UIImage` can be wonky.)

Yesterday, I was working on adding a new controller to a `UINavigationController` stack. The stack is nothing exceptional:

1. `UITableView`, listing all of a certain kind of model
2. A detail view controller, which extends `UIViewController`, which has details about the model instance, including a `UICollectionView`, which includes zero to many images that you can page through
3. A map (MKMapView) in a `UIViewController`

It was that third controller I was adding yesterday, when I started getting really annoying errors. _In the second controller_.

After a while, I discovered steps to reproduce the crash:

1. Select any cell in the table view to go into the detail
2. Tap the button to push the map view controller
3. Go back to the detail
4. Go back to the table, and select either the same or a different model
5. Crash! `EXC_BAD_ACCESS`.

Xcode was pointing at this line, which was used to make a reflected image of the currently viewed photo in the detail view controller (controller 2, above):

    let cgImage = CI_CONTEXT.createCGImage(outputImage, fromRect: rect)

I tried everything to get more information from Xcode about what, exactly, was failing. I broke the line that was getting the error into six or so, to see which variable or method call was causing the issue. No dice.

Here's the whole snippet, which takes a `UIImage` and returns a `UIImage?` filtered by a gaussian blur:

    let CI_CONTEXT = CIContext(options: nil)
    import CoreImage
    extension UIImage {
        func getBlurryCopy() -> UIImage? {
            let gaussianFilter: CIFilter = CIFilter(name: "CIGaussianBlur")
            let ciImage = CoreImage.CIImage(image: self)
            gaussianFilter.setValue(25, forKey: "inputRadius")
            gaussianFilter.setValue(ciImage, forKey: kCIInputImageKey)
            let outputImage = gaussianFilter.outputImage
            let rect = ciImage.extent()
            let cgImage = CI_CONTEXT.createCGImage(outputImage, fromRect: rect) //EXC_BAD_ACCESS
            return UIImage(CGImage: cgImage)?
        }
    }


It worked perfectly until I started pushing that third controller onto the stack.

Hmm. I figured it was a memory problem, so I did a bunch of research about CoreImage's memory handling. Everything, including Apple's documentation, says clearly to _not_ try and handle memory allocation or release because Swift does that for you. Nonetheless, I checked all of my controllers' `didReceiveMemoryWarning()`, and still nothing.

I read up on `CIContext`, which is immutable and thus can (and should) be declared once and reused for multiple images. (`CIFilter` is mutable, and should be used once.) But I was already doing that. (Except I was also reusing my `CIFilter` instance. Fixing that didn't help though.)

Then I remembered seeing a Stack Overflow thread, in which someone was complaining about Swift extensions not working very well. So I decided to move that block above and make it into a class method in a generic helper class:

    let CI_CONTEXT = CIContext(options: nil)
    import CoreImage
    class ImageHelper {
        class func getBlurryCopy(image: UIImage) -> UIImage? {
            let gaussianFilter: CIFilter = CIFilter(name: "CIGaussianBlur")
            let ciImage = CoreImage.CIImage(image: image)
            gaussianFilter.setValue(25, forKey: "inputRadius")
            gaussianFilter.setValue(ciImage, forKey: kCIInputImageKey)
            let outputImage = gaussianFilter.outputImage
            let rect = ciImage.extent()
            let cgImage = CI_CONTEXT.createCGImage(outputImage, fromRect: rect)
            return UIImage(CGImage: cgImage)?
        }
    }

And that fixed it.

It's not a mind blowing solution by any means, but considering the amount of time I banged my head against the wall, trying again and again to squeeze more juice out of Xcode or logging, I'm posting it for all to see.
