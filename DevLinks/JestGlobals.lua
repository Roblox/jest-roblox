local REQUIRED_MODULE = require(script.Parent.Parent.JestGlobals)
export type MatcherState = REQUIRED_MODULE.MatcherState 
export type ExpectExtended<E, State = MatcherState> = REQUIRED_MODULE.ExpectExtended<E, State >
return REQUIRED_MODULE
