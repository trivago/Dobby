/// A disposable that will run an action upon disposal.
public final class Disposable {
    private var action: (() -> ())?

    /// Whether this disposable has been disposed already.
    public var disposed: Bool {
        return action == nil
    }

    /// Initializes a new disposable with the given action.
    public init(action: () -> ()) {
        self.action = action
    }

    /// Performs the disposal, running the associated action.
    public func dispose() {
        action?()
        action = nil
    }
}
