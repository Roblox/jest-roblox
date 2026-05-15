# throat

Upstream: https://github.com/ForbesLindesay/throat/tree/6.0.1

Concurrency limiter for Promise-returning functions. Throttles parallel execution to at most `n` concurrent calls. Used by jest-runner and jest-circus to limit test concurrency.

## API

```lua
local throat = require(Packages.Throat)

-- Late-bound: returns a throttled wrapper, pass the function on each call
local throttle = throat(n)
throttle(fn, arg1, arg2)

-- Early-bound: bind the function upfront
local throttledFn = throat(n, fn)
throttledFn(arg1, arg2)
```
