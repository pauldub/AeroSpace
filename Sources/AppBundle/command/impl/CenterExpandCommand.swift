import AppKit
import Common

struct CenterExpandCommand: Command {
    let args: CenterExpandCmdArgs

    func run(_ env: CmdEnv, _ io: CmdIo) -> Bool {
        guard let target = args.resolveTargetOrReportError(env, io) else { return false }
        guard let window = target.windowOrNil else {
            return io.err(noWindowIsFocused)
        }
        let newState: Bool = switch args.toggle {
            case .on: true
            case .off: false
            case .toggle: !window.isCenterExpanded
        }
        if newState == window.isCenterExpanded {
            io.err((newState ? "Already center-expanded. " : "Already not center-expanded. ") +
                "Tip: use --fail-if-noop to exit with non-zero code")
            return !args.failIfNoop
        }

        // Store the current layout rect before expanding
        if newState && !window.isCenterExpanded {
            window.lastTiledLayoutRect = window.lastAppliedLayoutPhysicalRect
        }

        window.isCenterExpanded = newState

        // If we're turning off center-expand and have a stored rect, we'll use it in layout
        // Otherwise, let the normal layout system handle it

        // Focus on its own workspace
        window.markAsMostRecentChild()
        return true
    }
}
