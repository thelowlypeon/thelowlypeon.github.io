---
layout: post
title:  "Simple Reactive: KVO"
date:   2018-10-11 15:21:00 -0500
categories: swift ios mobile programming simple-reactive
editors_note: This is the first example in a series of Reactive design patterns for Swift that have no dependencies. See [here](/2018/simple-reactive) for details.
editors_note_markdown: true
---

My initial thought when considering how to build a reactive model without any dependencies was
to use iOS Foundation's KVO, or Key Value Observing. Baked into anything inheriting from `NSObject`
is a mechanism to observe changes at key paths of a specific object.

For example, let's suppose we have a `Person` model that has a first and last name.
If we want to observe changes to either attribute, we need only mark them as `dynamic`,
make them available in objective-c, and tell the instance that we want to be told when the value
changes.

```swift
class Person: NSObject {
    @objc dynamic var firstName: String
    @objc dynamic var lastName: String

    //...
}
```

And then in the ViewModel, where we want to build a string for our View to observe:

```swift
class PersonViewModel: NSObject {
    private var firstNameObserver: NSKeyValueObservation?
    private var lastNameObserver: NSKeyValueObservation?

    //...

    private func observePersonAttributes() {
        firstNameObserver = person.observe(\Person.firstName, options: [.initial, .new], changeHandler: {[unowned self] object, change in
            self.firstNameChanged(change.newValue as? String)
        })
        lastNameObserver = person.observe(\Person.lastName, options: [.initial, .new], changeHandler: {[unowned self] object, change in
            self.lastNameChanged(change.newValue as? String)
        })
    }
}
```

## Benefits

KVO is (probably) already there! _It_ will manage your observers, _it_ will send events on change.

You can also specify if you want your callback executed with the initial value or only new ones.
This may seem like not a big deal, but as we explore other patterns for reactive programming,
it's a pretty big plus.

## Costs

Doing this has quite a few requirements, so let's walk through them.

### Objective C

KVO depends entirely on meta-programming, because it observes changes to objects at _key paths_.
Swift doesn't like meta-programming, so this all needs to happen in the Objective-C under the hood.
This requires a simple `dynamic` declaration for each observable property, as well as an `@objc` export.

In practice, this doesn't matter _too much_. You can still write your app in Swift, and leverage
the compiler to make sure you're observing real keypaths. But it does mean some extra casting.

Note: Swift makes this a bit safer than it used to, telling the compiler to verify that the key path
used actually exists (previously it was a string, which of course guarantees a mistake at least
once).

### Type Constraints

...but the real bummer about requiring objective-c is that your observable types need to be
representable in objc. So, if, for example, you want to observe changes to a Swift enum,
you'll need to instead use monitor its raw value.

### `NSObject`

KVO's `observe` method lives in `NSObject`. So your models need to extend `NSObject`. That's a drag.

## Other Notes

* Observing will continue until your `NSKeyValueObservation` instance is deallocated. This is important! If you do not retain a reference to it, it will stop observing; if you retain a reference to it, your callback better be able to run
* If you don't know the difference between `unowned` and `weak` (or - gasp! - either), then take the time now to read up on the difference. Because if you refer to `self` in your callback, you probably want it to be weak or unowned, else you'll have circular references
* Have I mentioned the importance of retaining or destroying references?
* This one was too obvious to list as a cost, but this _does_ require `Foundation`. That doesn't matter for iOS/macOS projects, but if you're running a swift app elsewhere, that may not be desirable.

## Rating: B-

The fact that all of this comes right out of the box is pretty hard to beat. But I _really_ don't
want to introduce dependencies if I don't need them. And the fact that `NSObject#observe`, the
method used above, was introduced within the last year, makes me very wary that there may
be other interface changes. Furthermore, for many of my projects, the inability to use Swift types
not available in Objective-C is a deal breaker.
