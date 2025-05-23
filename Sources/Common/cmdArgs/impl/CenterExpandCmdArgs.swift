public let center_expand_help_generated = """
USAGE: center-expand [-h|--help] [<on|off|toggle>] [--fail-if-noop]

OPTIONS:
  -h, --help               Print help
  --fail-if-noop           Exit with non-zero code if already in the desired state

ARGUMENTS:
  <on|off|toggle>          'on' to enable, 'off' to disable, 'toggle' to toggle (default: toggle)

DESCRIPTION:
  Expand the focused window to fill the workspace with configurable margins.
  Similar to fullscreen but respects the configured center-expand-margin gaps.
"""

public struct CenterExpandCmdArgs: CmdArgs {
    public let rawArgs: EquatableNoop<[String]>
    fileprivate init(rawArgs: [String]) { self.rawArgs = .init(rawArgs) }
    public static let parser: CmdParser<Self> = cmdParser(
        kind: .centerExpand,
        allowInConfig: true,
        help: center_expand_help_generated,
        options: [
            "--fail-if-noop": trueBoolFlag(\.failIfNoop),
            "--window-id": optionalWindowIdFlag(),
        ],
        arguments: [ArgParser(\.toggle, parseToggleEnum)]
    )

    public var toggle: ToggleEnum = .toggle
    public var failIfNoop: Bool = false
    public var windowId: UInt32?
    public var workspaceName: WorkspaceName?
}

public func parseCenterExpandCmdArgs(_ args: [String]) -> ParsedCmd<CenterExpandCmdArgs> {
    parseSpecificCmdArgs(CenterExpandCmdArgs(rawArgs: args), args)
        .filter("--fail-if-noop requires 'on' or 'off' argument") { $0.failIfNoop.implies($0.toggle == .on || $0.toggle == .off) }
}