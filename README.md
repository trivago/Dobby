# Dobby

Dobby provides a few helpers for mocking and stubbing.

## Matchers

Matchers can be matched with values, serving as the fundamental building block for mocking and stubbing. There are many functions that help creating matchers for (equatable) types, including optionals, tuples, arrays, and dictionaries with equatable elements:

```swift
matches { $0 == value } // matches value
any() // matches anything
not(0) // matches anything but 0
none() // matches Optional<T>.None (nil)
some(1) // matches Optional<T>.Some(1)
equals(1) // matches 1
equals((1, 2)) // matches (1, 2)
equals((1, 2, 3)) // matches (1, 2, 3)
equals((1, 2, 3, 4)) // matches (1, 2, 3, 4)
equals((1, 2, 3, 4, 5)) // matches (1, 2, 3, 4, 5)
equals([1, 2, 3]) // matches [1, 2, 3]
equals([1: 1, 2: 2, 3: 3]) // matches [1: 1, 2: 2, 3: 3]
```

Matchers may also be nested:

```swift
matches((matches { $0 == 0 }, any(), 2)) // matches (0, _, 2)
matches((not(equals(3)), some(any()))) // matches (not(3), _)
matches([any(), equals(4)]) // matches [_, 4]
matches(["key": matches { $0 == 5 }]) // matches ["key": 5]
```

## Mocks

Mocks can be used to verify that all set up expectations have been fulfilled.

### Strict mocks

By default, mocks are strict and the order of expectations matters, meaning all interactions must be expected and occur in the order they were expected:

```swift
let mock = Mock<[Int]>()
mock.expect(matches([any(), matches { $0 > 0 }])) // expects [_, n > 0]
mock.record([0, 1]) // succeeds
mock.verify() // succeeds
mock.record([1, 0]) // fails (fast)
```

The order of expectations may also be ignored:

```swift
let mock = Mock<[String: Int]>(ordered: false)
mock.expect(matches([0, 1]))
mock.expect(matches([1, 0]))
mock.record([1, 0]) // succeeds
mock.record([0, 1]) // succeeds
mock.verify() // succeeds
mock.record([0, 0]) // fails (fast)
```

### Nice mocks

Nice mocks allow unexpected interactions while still respecting the order of expectations:

```swift
let mock = Mock<[Int?]>(strict: false)
mock.expect(matches([some(0)]))
mock.expect(matches([some(any())]))
mock.record([nil]) // succeeds
mock.verify() // fails
mock.record([1]) // fails (fast)
mock.record([0]) // succeeds
mock.record([1]) // succeeds
mock.verify() // succeeds
```

Of course, nice mocks can ignore the order of expectations too:

```swift
let mock = Mock<[String: Int?]>(strict: false, ordered: false)
mock.expect(matches(["zero": some(0)]))
mock.expect(matches(["none": none()]))
mock.record(["none": nil]) // succeeds
mock.record(["zero": 0]) // succeeds
mock.verify() // succeeds
```

#### Negative expectations

In addition to normal expectations, nice mocks allow negative expectations to be set up:

```swift
let mock = Mock<Int>(strict: false)
mock.reject(0)
mock.record(0) // fails (fast)
```

### Verification with delay

Verification may also be performed with a delay, allowing expectations to be fulfilled asynchronously:

```swift
let mock = Mock<Int>()
mock.expect(1)

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
    mock.record(1) // succeeds
}

mock.verifyWithDelay(2.0) // succeeds
```

## Stubs

Stubs, when invoked, return a value based on their set up behavior, or, if an interaction is unexpected, throw an error. Behavior is matched in order, i.e., the function or return value associated with the first matcher that matches an interaction is invoked/returned:

```swift
let stub = Stub<(Int, Int), Int>()
let behavior = stub.on(equals((4, 3)), returnValue: 9)
stub.on(matches((any(), any()))) { $0.0 + $0.1 }
try! stub.invoke((4, 3)) // returns 9
try! stub.invoke((4, 4)) // returns 8
```

Behavior may also be disposed:

```swift
behavior.dispose()
try! stub.invoke((4, 3)) // returns 7
```

## Example

The helpers provided for mocking and stubbing can be used with any testing approach, including protocol test implementations, test subclasses, etc. For example, imagine you want to verify interactions with the following class and change its behavior:

```swift
class MyClass {
  func myMethod(fst: String, _ snd: String) -> String {
    return fst + snd
  }
}
```

Writing a test subclass for the given class is very simple:

```swift
class MyClassMock: MyClass {
  let myMethodMock = Mock<(String, String)>()
  let myMethodStub = Stub<(String, String), String>()
  override func myMethod(fst: String, _ snd: String) -> String {
    myMethodMock.record((fst, snd))
    // Throw an exception if the stub doesn't define any behavior for the interaction.
    return try! myMethodStub.invoke((fst, snd))
  }
}
```

The test subclass allows you to verify that all your set up expectations are fulfilled and enables you to change its behavior on-the-fly:

```swift
let myClassMock = MyClassMock()
myClassMock.myMethodMock.expect(matches(("Hello", "World")))
myClassMock.myMethodStub.on(any()) { fst, snd in fst }
myClassMock.myMethod("Hello", "World") // returns "Hello"
myClassMock.myMethodMock.verify() // succeeds
```

If you ever find yourself wanting to use a mock or stub with several interactions of different types, consider using an equatable enum to define these interactions.

## Documentation

Please check out the [source](https://github.com/rheinfabrik/Dobby/tree/master/Dobby) and [tests](https://github.com/rheinfabrik/Dobby/tree/master/DobbyTests) for further documentation.

## About

![](https://cloud.githubusercontent.com/assets/926377/8927635/28afa5de-3519-11e5-8d50-4f474eb2a57f.gif)

Dobby was born at [Rheinfabrik](http://www.rheinfabrik.de) 🏭
