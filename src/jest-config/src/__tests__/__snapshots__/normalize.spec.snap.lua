-- Jest Roblox Snapshot v1, http://roblox.github.io/jest-roblox-internal/snapshot-testing
local exports = {}
exports[ [=[displayName should throw an error when displayName is is an empty object 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[displayName should throw an error when displayName is missing color 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[displayName should throw an error when displayName is missing name 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[displayName should throw an error when displayName is using invalid values 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>displayName</>\" must be of type:</>
<red></>
<red>  {</>
<red>    name: string;</>
<red>    color: string;</>
<red>  }</>
<red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[reporters throws an error if first value in the tuple is not a string 1]=] ] = [=[

"<red><bold><bold>● </><bold>Reporter Validation Error</>:</>
<red></>
<red>  Unexpected value for reporter name at index 0 of reporter at index 1</>
<red>  Expected:</>
<red>    <red><bold>ModuleScript or string</></><red></>
<red>  Got:</>
<red>    <green><bold>number</></><red></>
<red>  Reporter configuration:</>
<red>    <green><bold>{\"reporter\":123}</></><red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[reporters throws an error if second value in the tuple is not an object 1]=] ] = [=[

"<red><bold><bold>● </><bold>Reporter Validation Error</>:</>
<red></>
<red>  Unexpected value for Reporter Configuration at index 1 of reporter at index 1</>
<red>  Expected:</>
<red>    <red><bold>table</></><red></>
<red>  Got:</>
<red>    <green><bold>boolean</></><red></>
<red>  Reporter configuration:</>
<red>    <green><bold>{\"options\":true,\"reporter\":\"some-reporter\"}</></><red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[reporters throws an error if second value is missing in the tuple 1]=] ] = [=[

"<red><bold><bold>● </><bold>Reporter Validation Error</>:</>
<red></>
<red>  Unexpected value for Reporter Configuration at index 1 of reporter at index 1</>
<red>  Expected:</>
<red>    <red><bold>table</></><red></>
<red>  Got:</>
<red>    <green><bold>nil</></><red></>
<red>  Reporter configuration:</>
<red>    <green><bold>{\"reporter\":\"some-reporter\"}</></><red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[reporters throws an error if value is neither string nor array 1]=] ] = [=[

"<red><bold><bold>● </><bold>Reporter Validation Error</>:</>
<red></>
<red>  Reporter at index 1 must be of type:</>
<red>    <green><bold>table or string or ModuleScript</></><red></>
<red>  but instead received:</>
<red>    <red><bold>number</></><red></>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[rootDir throws error when rootDir is string 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Directory <bold>rootDir</> in the <bold>rootDir</> option was not found.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[rootDir throws error when rootDir is table 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Directory <bold>TABLE</> in the <bold>rootDir</> option was not found.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[rootDir throws if the options is missing a rootDir property 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Configuration option <bold>rootDir</> must be specified.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[testMatch throws if testRegex and testMatch are both specified 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Configuration options <bold>testMatch</> and <bold>testRegex</> cannot be used together.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

exports[ [=[testPathPattern --testPathPattern ignores invalid regular expressions and logs a warning 1]=] ] = [=[
"<red>  Invalid testPattern a( supplied. Running all tests instead.</>"]=]

exports[ [=[testPathPattern <regexForTestFiles> ignores invalid regular expressions and logs a warning 1]=] ] = [=[
"<red>  Invalid testPattern a( supplied. Running all tests instead.</>"]=]

exports[ [=[testTimeout should throw an error if timeout is a negative number 1]=] ] = [=[

"<red><bold><bold>● </><bold>Validation Error</>:</>
<red></>
<red>  Option \"<bold>testTimeout</>\" must be a natural number.</>
<red></>
<red>  <bold>Configuration Documentation:</></>
<red>  https://roblox.github.io/jest-roblox-internal/configuration</>
<red></>"
]=]

return exports
