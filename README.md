# brindlesay

A cowsay-style CLI for [nushell](https://www.nushell.sh/) featuring Brindle the owl.

```
 __________________________________
< have you tried reading the docs? >
 ----------------------------------
        \
         \
      /\  /\
     ((◉)(◉))
     (  ><  )
      `----´
```

## Usage

```bash
# Random saying
nu brindle.nu

# Custom message
nu brindle.nu "your message here"

# Animated idle loop (Ctrl-C to exit)
nu brindle.nu --animate

# Combine both
nu brindle.nu --animate "watching you code"
```

## Requirements

- [Nushell](https://www.nushell.sh/) 0.100+

## Files

- `brindle.nu` — the main script
- `sayings.txt` — one saying per line, picked at random when no message is given

## Adding sayings

Add one saying per line to `sayings.txt`. Blank lines are ignored.

## Who is Brindle?

A small, caustic owl with no patience and sharp debugging instincts. Brindle will judge your code before you've finished writing it.
