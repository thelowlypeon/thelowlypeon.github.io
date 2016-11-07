---
layout: post
title: "NSKeyedUnarchiver with Swift 3"
date: 2016-10-27 12:03:49 -0500
categories: technology swift ios
---

Swift 3 brought with it lots of breaking changes, making the process of upgrading from 2.x quite an undertaking.

Most of the changes are handled reasonably well by Xcode's upgrade tool, but some changes cause issues not found until runtime, such as decoding basic types using `NSKeyedUnarchiver`.

**tl;dr**: [Attempt to decode from older versions or default to Swift 3](#the-solution).

## Encoding & Decoding

If you've written iOS projects before, you probably know `NSKeyedArchiver` and `NSKeyedUnarchiver` well.

For those of you who don't, these are the services used for storing data locally in a hierarchy of objects. (You can read more [here](https://developer.apple.com/reference/foundation/nskeyedunarchiver).)

### Swift 2.x

In older versions of Swift, you'd decode most things using `decodeObjectForKey`:

```swift
let myOptionalString = coder.decodeObjectForKey("key1") as? String
let myOptionalInteger = coder.decodeObjectForKey("key2") as? Int
```

And if you were certain that the values were non-nil during the `encode` step, you could unwrap them:

```swift
let myString = coder.decodeObjectForKey("key1") as! String
let myInteger = coder.decodeObjectForKey("key2") as! Int
```

### Swift 3

One of the more significant changes to Swift 3 syntax is that it moved parameter names out of the method and into the parameter label.
For example, in this case, `decodeObjectForKey("key")` is now called using `decodeObject(forKey: "key")`.

Thus, the Xcode upgrade tool changed how to decode a required string to:

```swift
let myString = coder.decodeObject(forKey: "key1") as! String
```

And for basic types, eg `Int`, `Bool`, etc, it changed the method altogether to decode the specific type:

```swift
let myInteger = coder.decodeInteger(forKey: "key2")
```

## Backwards Compatibility

Alright, so what's the problem? The new syntax looks cleaner, is easier to understand, and according to Apple's [docs](https://developer.apple.com/reference/foundation/nskeyedunarchiver/1413260-decodebool), things should default reasonably.

The problem is that the values encoded using Swift 2.x aren't compatible.

So if you encoded a boolean using, say, Swift 2.3:

```swift
//swift 2.3
coder.encode(true, forKey: "myBooleanKey")
```

and then try to decode it using a build created with Swift 3:

```swift
//swift 3
let myBool = coder.decodeBool(forKey: "myBooleanKey")
```

it would raise a nasty exception:

```
EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
```

(To be clear, this would _not_ cause any issues if you uninstalled the old build before installing the new,
making it a problem likely not caught by the developer who is constantly rebuilding, or unit tests that persist only for a specific test case.)

### The Solution

You can solve this by handling _both_ cases: attempt to `decodeObject` first, and then fall back to decoding the specific type, eg `decodeBool`:

```swift
let myBool = coder.decodeObject(forKey: "myBooleanKey") as? Bool ?? coder.decodeBool(forKey: "myBooleanKey")
```

(In this case, if there is no value at key `"myBooleanKey"`, `decodeBool:forKey` will return false gracefully.)

You won't need to do this for non basic types, such as strings or objects.
