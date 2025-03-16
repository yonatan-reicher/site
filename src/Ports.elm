port module Ports exposing (highlightAll, fixScriptTags)

port highlightAll : () -> Cmd msg

{-|
This port is called when requesting that a script tag be fixed. Because Elm
does not allow for <script> tags, we use mark elements with the `script`
attribute, and use it's value to create a new script tag via javascript.

## Example
```html
<div script="console.log('Hello, World!')"></div>
```
will be transformed after the this call into:
```html
<div hidden script="console.log('Hello, World!')"></div>
<script>console.log('Hello, World!')</script>
```

## Design Decisions
The reason for using the attribute value instead of the innerHTML is to avoid
having to escape the code, as characters like `<` and `{` are way too common.
-}
port fixScriptTags : () -> Cmd msg

