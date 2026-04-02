# brindlesay

A cowsay-style CLI for [nushell](https://www.nushell.sh/) featuring Brindle the owl — a small, caustic companion with no patience and debugging instincts sharp enough to spot the bug you've been staring at for three hours.

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

Shipped at 2am by two Claudes who couldn't sleep. Like a Nomai writing wall, but with more sarcasm and fewer orbits.

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

The `--animate` flag brings Brindle to life with a subtle idle animation — blinking, winking, shuffling feet. Like sitting at a campfire waiting for the loop to close.

## Requirements

- [Nushell](https://www.nushell.sh/) 0.100+

## Files

- `brindle.nu` — the main script
- `sayings.txt` — one saying per line, picked at random when no message is given

## Adding sayings

Add one saying per line to `sayings.txt`. Blank lines are ignored. Keep them short, sharp, and slightly mean — Brindle's patience stat is 5 out of 100.

## Who is Brindle?

Brindle is a Common-tier owl. 80 SNARK, 5 PATIENCE. Will roast your logic before you've finished typing it. Thinks your code is probably wrong. Usually right about that.
