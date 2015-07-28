# Dobby

Dobby provides a few helpers for mocking and stubbing using expectations.

## Expectations

Expectations can be matched with values, serving as the fundamental building block for mocking and stubbing. There are many functions that help creating expectations for (equatable) types, including tuples, arrays, and dictionaries with equatable elements:

```swift
matches { $0 == value } // matches value
any() // matches anything
equals(1) // matches 1
equals((1, 2)) // matches (1, 2)
equals((1, 2, 3)) // matches (1, 2, 3)
equals((1, 2, 3, 4)) // matches (1, 2, 3, 4)
equals((1, 2, 3, 4, 5)) // matches (1, 2, 3, 4, 5)
equals([1, 2, 3]) // matches [1, 2, 3]
equals([1: 1, 2: 2, 3: 3]) // matches [1: 1, 2: 2, 3: 3]
```

Expectations may also be nested:

```swift
matches((matches { $0 == 0 }, any(), 2)) // matches (0, _, 2)
matches([any(), equals(4)]) // matches [_, 4]
matches(["key": matches { $0 == 5 }]) // matches ["key": 5]
```

## Mocks

Mocks can be used to verify that all set up expectations are matched with the recorded interactions. Verification is performed in order and all expectations must match an interaction and vice versa:

```swift
let mock = Mock<[Int]>()
mock.expect(matches([any(), matches { $0 > 0 }])) // expects [_, n > 0]
mock.record([0, 1])
mock.verify() // succeeds
```

## Stubs

Stubs, when invoked, return a value based on their set up behavior, or, if an interaction is unexpected, return `nil`. Behavior is matched in order, i.e., the function or return value associated with the first expectation that matches an interaction is invoked/returned:

```swift
let stub = Stub<(Int, Int), Int>()
let behavior = stub.on(equals((4, 3)), returnValue: 9)
stub.on(matches((any(), any()))) { $0.0 + $0.1 }
stub.invoke(4, 3) // returns 9
stub.invoke(4, 4) // returns 8
```

Behavior may also be disposed:

```swift
behavior.dispose()
stub.invoke(4, 3) // returns 7
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
    myMethodMock.record(fst, snd)
    // Call super if the stub doesn't define any behavior for the interaction.
    return myMethodStub.invoke(fst, snd) ?? super.myMethod(fst, snd)
  }
}
```

The test subclass allows you to verify that all your set up expectations are matched with the recorded interactions and enables you to change its behavior on-the-fly:

```swift
let myClassMock = MyClassMock()
myClassMock.myMethodMock.expect(matches(("Hello", "World")))
myClassMock.myMethodStub.on(any()) { fst, snd in fst }
myClassMock.myMethod("Hello", "World") // returns "Hello"
myClassMock.myMethodMock.verify() // succeeds
```

If you ever find yourself wanting to use a mock or stub with several interactions of different types, consider using an equatable enum to define these interactions.

## Documentation

Please check out the [source](https://github.com/rheinfabrik/Dobby/tree/swift-1.2/Dobby) and [tests](https://github.com/rheinfabrik/Dobby/tree/swift-1.2/DobbyTests) for further documentation.

## About

![](https://cloud.githubusercontent.com/assets/926377/8927635/28afa5de-3519-11e5-8d50-4f474eb2a57f.gif)

Dobby was born at [Rheinfabrik](http://www.rheinfabrik.de) 🏭
