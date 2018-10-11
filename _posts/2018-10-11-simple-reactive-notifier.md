---
layout: post
title:  "Simple Reactive: Notifier"
date:   2018-10-11 16:12:00 -0500
categories: swift ios mobile programming simple-reactive
editors_note: This is the second example in a series of Reactive design patterns for Swift that have no dependencies. See [here](/2018/simple-reactive) for details.
editors_note_markdown: true
---

After trying out simple KVO, I wanted to try assigning a single property to each observableclass
that would emit events when something changed. I liked this idea because it would, in theory,
require very few changes to the actual observable class, and could thus live separately from it,
such as in an extension or in a subclass even. To keep it simple, I opted to not worry about
sending the current (or previous) value, as KVO does, and instead just let observers know
that something changed, and make them investigate.

The event emitter, which I've called `Notifier`, might look like this:

```swift
class Notifier<T> {
    typealias NotificationCallback = (T) -> Void
    var notificationCallbacks = [NotificationCallback]()

    func observe(_ callback: @escaping NotificationCallback) {
        notificationCallbacks.append(callback)
    }

    func send(_ value: T) {
        for callback in notificationCallbacks {
            callback(value)
        }
    }
}
```

Consider our previous example of having a `Person` class with observable first and last names,
and a `ViewModel` that puts the pieces together for its view.

To our _really_ simple `Person` class, we'd add a single, public `Notifier` instance,
where the generic `T` is a Swift enum containing the field name that changed.

```swift
enum PersonProperty {
    case firstName, lastName
}

class Person {
    var notifier = Notifier<PersonProperty>()
    var firstName: String { didSet { notifier.send(.firstName) } }
    var lastName: String { didSet { notifier.send(.lastName) } }
}
```

Then, our View Model would just register a handler with likely a switch statement to decide what to do:

```swift
class PersonViewModel {
    var personNameText: String

    //...

    func bindPerson() {
        person.notifier.observe({[unowned self](property) in
            switch property {
            case .firstName:
                self.firstNameChanged()
            case .lastName:
                self.lastNameChanged()
            }
        })
    }
}
```

## Benefits

As noted above, this method hardly changes the observed class at all. The only changes necessary
are adding a `Notifier` instance, adding a swift `didSet` hook to each observable property,
and defining which properties can be observed in an enum. There is _zero_ dependence on Foundation,
NSObjects, or Objective-C.

## Costs

Unfortunately, there are some very real costs.

### Reference Counters

To be able to stop observing, you'd need to probably create a class containing a callback
and some way to identify it. Then, like with KVO, you'd need to keep a reference to it (or its
identifier), and when you no longer want to observe, you'd have to tell the `Notifier` to remove it.
I wound up doing this for subsequent patterns, meaning this problem isn't unique to this pattern.

### Initial Values

Remember in my [KVO post](/2018/simple-reactive-kvo) how I noticed that getting an initial value
was pretty nice? Without some modification, this pattern won't do that. I wound up getting around this
fairly easily, but it wasn't pretty.

```swift
class Notifier<T> {
    func observe(_ callback: @escaping NotificationCallback, withInitialValue initialValue: T? = nil) {
        //...
        if let initialValue = initialValue {
            callback(initialValue)
        }
    }
}

enum PersonProperty {
    case .initial, ...
}

class PersonViewModel {
    func bindPerson() {
        person.notifier.observe({[unowned self](property) in
            //...
        }, withInitialValue: .initial)
    }
}
```

## Rating: C+

The simplicity of this approach goes a _really_ long way. In many cases, where there's really only
one observer, you could make the `notifier` instance optional, and set it to nil to effectively
stop observing, the initialize a new one when you need to. But it just requires too much
funny business to make it practical, like passing in that initial value when observing.

Still, I think we may be onto something with this pattern, and I'm excited to explore some more
options before we can take the best of all of them!
