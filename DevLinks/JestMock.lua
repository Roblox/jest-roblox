local REQUIRED_MODULE = require(script.Parent.Parent.JestMock)
export type MaybeMockedDeep<T> = REQUIRED_MODULE.MaybeMockedDeep<T>
export type MaybeMocked<T> = REQUIRED_MODULE.MaybeMocked<T>
export type UnknownFunction = REQUIRED_MODULE.UnknownFunction 
export type Mock<T = UnknownFunction> = REQUIRED_MODULE.Mock<T >
export type ModuleMocker = REQUIRED_MODULE.ModuleMocker 
export type JestFuncFn = REQUIRED_MODULE.JestFuncFn 
export type JestFuncSpyOn = REQUIRED_MODULE.JestFuncSpyOn 
export type JestFuncMocked = REQUIRED_MODULE.JestFuncMocked 
return REQUIRED_MODULE
