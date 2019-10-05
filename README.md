# WeightedRandom

Crystal library for a fast `O(1)` weighted random samples generation
using [Alias algorithm](https://en.wikipedia.org/wiki/Alias_method).

Note that initialization is `O(N)` and `next_choice` call is `O(1)`.
**But** a straight-forward `O(N)` Linear Scan could be faster for
a few weights, or when you need just a few samples (especially one).

The case with just 2 weights (a biased coin) is optimized.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     weightedrandom:
       github: dimagog/weightedrandom
   ```

2. Run `shards install`

## Usage

The correct usage pattern is to create a new `WeightedRandom` object once and call `next_choice` on it many-many times.

```crystal
require "WeightedRandom"
```
> NOTE: **Only Integer weights are supported for now.**
Fractional weights support can be added with few modifications to the Alias algorithm to account for imprecise math.

### When you simply need indices of the weights

```crystal
r = WeightedRandom.new([1, 2])
r.next_choice
```
The `next_choice` above will randomly generate `0`s and `1`s. `1`s will be twice more likely than `0`s.

A common case is when weights are percentages:
```crystal
r = WeightedRandom.new([5, 70, 25])
r.next_choice
```
Here 5% of calls to `next_choice` will return `0`, 70% will return `1`, and 25% of calls will return `2`.

To be explicit that you are creating an indexed choice you can use `WeightedRandom.indexed` instead of `WeightedRandom.new`.

### When weights have labels
```crystal
r = WeightedRandom.new({"a" => 1, "b" => 2})
r.next_choice
```
The `next_choice` above will randomly generate `"a"` or `"b"`. `"b"`s will be twice more likely than `"a"`s.

To be explicit that you are creating a keyed choice you can use `WeightedRandom.keyed` instead of `WeightedRandom.new`.

## Contributors

- [Dmitry Kakurin](https://github.com/dimagog) - creator and maintainer
