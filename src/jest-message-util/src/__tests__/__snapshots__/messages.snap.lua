-- ROBLOX upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-message-util/src/__tests__/__snapshots__/messages.test.ts.snap
-- Jest Snapshot v1, https://goo.gl/fbAQLP

local exports = {}

exports[".formatExecError() 1"] = [[

"  <bold>● </>Test suite failed to run

    Whoops!
"
]]

exports["codeframe 1"] = [[

"  <bold>● </>Test suite failed to run

    Whoops!

    </><red><bold>></></><gray> 1 |</> <cyan>throw</> <cyan>new</> <yellow>Error</>(<green>\\"Whoops!\\"</>)<yellow>;</></>
    </> <gray>   |</>       <red><bold>^</></></>

      <dim>at Object.<anonymous> (</>file.js<dim>:1:7)</>
"
]]

exports["formatStackTrace does not print code frame when noCodeFrame = true 1"] = [[

"
      <dim>at Object.<anonymous> (</>file.js<dim>:1:7)</>
        "
]]

exports["formatStackTrace does not print codeframe when noStackTrace = true 1"] = [[

"
      <dim>at Object.<anonymous> (</>file.js<dim>:1:7)</>
        "
]]

exports["formatStackTrace prints code frame and stacktrace 1"] = [[

"
    </><red><bold>></></><gray> 1 |</> <cyan>throw</> <cyan>new</> <yellow>Error</>(<green>\\"Whoops!\\"</>)<yellow>;</></>
    </> <gray>   |</>       <red><bold>^</></></>

      <dim>at Object.<anonymous> (</>file.js<dim>:1:7)</>
        "
]]

exports["formatStackTrace should strip node internals 1"] = [[

"<bold><red>  <bold>● </><bold>Unix test</></>


        Expected value to be of type:
          \\"number\\"
        Received:
          \\"\\"
        type:
          \\"string\\"
<dim></>
<dim>      <dim>at Object.it (</><dim>__tests__/test.js<dim>:8:14)</><dim></>
"
]]

exports["no codeframe 1"] = [[

"  <bold>● </>Test suite failed to run

    Whoops!

      <dim>at Object.<anonymous> (</>file.js<dim>:1:7)</>
"
]]

exports["no stack 1"] = [[

"  <bold>● </>Test suite failed to run

    Whoops!
"
]]

exports["retains message in babel code frame error 1"] = [[

"<bold><red>  <bold>● </><bold>Babel test</></>


        packages/react/src/forwardRef.js: Unexpected token, expected , (20:10)
<dim></>
<dim>          </> <gray> 18 | </>        <cyan>false</><yellow>,</></>
<dim>           <gray> 19 | </>        <green>'forwardRef requires a render function but received a \`memo\` '</></>
<dim>          <red><bold>></><dim></><gray> 20 | </>          <green>'component. Instead of forwardRef(memo(...)), use '</> <yellow>+</></>
<dim>           <gray>    | </>          <red><bold>^</><dim></></>
<dim>           <gray> 21 | </>          <green>'memo(forwardRef(...)).'</><yellow>,</></>
<dim>           <gray> 22 | </>      )<yellow>;</></>
<dim>           <gray> 23 | </>    } <cyan>else</> <cyan>if</> (<cyan>typeof</> render <yellow>!==</> <green>'function'</>) {</></>
"
]]

exports["should exclude jasmine from stack trace for Unix paths. 1"] = [[

"<bold><red>  <bold>● </><bold>Unix test</></>

      at stack (../jest-jasmine2/build/jasmine-2.4.1.js:1580:17)
<dim></>
<dim>      <dim>at Object.addResult (</><dim>../jest-jasmine2/build/jasmine-2.4.1.js<dim>:1550:14)</><dim></>
<dim>      <dim>at Object.it (</><dim>build/__tests__/messages-test.js<dim>:45:41)</><dim></>
"
]]

exports["should not exclude vendor from stack trace 1"] = [[

"<bold><red>  <bold>● </><bold>Vendor test</></>


        Expected value to be of type:
          \\"number\\"
        Received:
          \\"\\"
        type:
          \\"string\\"
<dim></>
<dim>      <dim>at Object.it (</><dim>__tests__/vendor/cool_test.js<dim>:6:666)</><dim></>
<dim>      <dim>at Object.asyncFn (</><dim>__tests__/vendor/sulu/node_modules/sulu-content-bundle/best_component.js<dim>:1:5)</><dim></>
"
]]

return exports
