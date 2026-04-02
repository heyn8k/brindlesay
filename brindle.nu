#!/usr/bin/env nu

# brindlesay — a cowsay-style CLI featuring Brindle the owl
# Usage: nu brindle.nu [--animate] [message]
#        echo "text" | nu brindle.nu
#        nu brindle.nu --animate
def main [--animate (-a), ...rest: string]: [string -> nothing, nothing -> nothing] {
    let piped = $in
    let arg_msg = ($rest | str join " ")

    let script_dir = ($env.FILE_PWD? | default ($env.CURRENT_FILE | path dirname))
    let sayings_file = ($script_dir | path join "sayings.txt")

    let message = if ($arg_msg | is-not-empty) {
        $arg_msg
    } else if ($piped | default "" | is-not-empty) {
        $piped | str trim -r
    } else {
        let lines = (open $sayings_file | lines | where { $in | str trim | is-not-empty })
        $lines | get (random int 0..($lines | length | $in - 1))
    }

    let wrapped = (wrap-text $message 40)
    let bubble = (make-bubble $wrapped)
    let connector = (make-connector)
    let owl = (owl-frame 0)

    print ([$bubble $connector $owl] | str join "\n")

    if $animate {
        animate-owl
    }
}

# Animation frames for Brindle
# Frame 0: resting, Frame 1: feet shuffle, Frame 2: wink, Frame -1: blink
def owl-frame [frame: int]: nothing -> string {
    let ears = "      /\\  /\\"
    let face = "     (  ><  )"

    let eyes = match $frame {
        1 => "     ((◉)(◉))"    # same eyes, feet change
        2 => "     ((◉)(-))"    # wink — right eye closed
        -1 => "     ((-)(-))"   # blink — both eyes closed
        _ => "     ((◉)(◉))"    # resting
    }

    let feet = match $frame {
        1 => "      .----."     # feet shuffle
        _ => "      `----´"     # resting
    }

    [$ears $eyes $face $feet] | str join "\n"
}

# Run the idle animation loop. Ctrl-C exits.
def animate-owl []: nothing -> nothing {
    # Idle animation sequence
    let sequence = [0 0 0 0 1 0 0 0 -1 0 0 2 0 0 0]

    # Hide cursor for clean animation
    print -n $"\e[?25l"

    loop {
        for frame in $sequence {
            let owl = (owl-frame $frame)
            # Move cursor up 4 lines (owl height), erase and redraw
            print -n $"\e[4A"
            let owl_lines = ($owl | lines)
            for line in $owl_lines {
                print -n $"\e[2K($line)\n"
            }
            sleep 500ms
        }
    }

    # Restore cursor (unreachable, but defensive)
    print -n $"\e[?25h"
}

# Wrap text to a maximum width, breaking on word boundaries
def wrap-text [text: string, max_width: int]: nothing -> list<string> {
    let lines = ($text | lines)
    let wrapped = ($lines | each { |line|
        if (display-width $line) <= $max_width {
            [$line]
        } else {
            wrap-line $line $max_width
        }
    } | flatten)
    $wrapped
}

# Wrap a single line on word boundaries
def wrap-line [line: string, max_width: int]: nothing -> list<string> {
    let words = ($line | split row -r '\s+')
    mut result = []
    mut current = ""

    for word in $words {
        if ($current | is-empty) {
            $current = $word
        } else {
            let candidate = $"($current) ($word)"
            if (display-width $candidate) <= $max_width {
                $current = $candidate
            } else {
                $result = ($result | append $current)
                $current = $word
            }
        }
    }

    if ($current | is-not-empty) {
        $result = ($result | append $current)
    }

    $result
}

# Calculate display width
def display-width [text: string]: nothing -> int {
    $text | str length
}

# Build the speech bubble
def make-bubble [lines: list<string>]: nothing -> string {
    let max_len = ($lines | each { |l| display-width $l } | math max)
    # No leading space on top border — nushell print strips leading
    # whitespace from the first line of output
    let top = ('' | fill -c '_' -w ($max_len + 2))
    let bottom = $" ('' | fill -c '-' -w ($max_len + 2))"

    let body = if ($lines | length) == 1 {
        let line = ($lines | first)
        let pad = ($max_len - (display-width $line))
        let padding = ('' | fill -c ' ' -w $pad)
        [$"< ($line)($padding) >"]
    } else {
        $lines | enumerate | each { |item|
            let line = $item.item
            let idx = $item.index
            let count = ($lines | length)
            let pad = ($max_len - (display-width $line))
            let padding = ('' | fill -c ' ' -w $pad)

            if $idx == 0 {
                $"/ ($line)($padding) \\"
            } else if $idx == ($count - 1) {
                $"\\ ($line)($padding) /"
            } else {
                $"| ($line)($padding) |"
            }
        }
    }

    ([$top] | append $body | append $bottom | str join "\n")
}

# Build the connector lines between bubble and owl
def make-connector []: nothing -> string {
    "        \\\n         \\"
}
