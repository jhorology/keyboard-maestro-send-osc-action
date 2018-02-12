Two [Keyboard Maestro](http://www.keyboardmaestro.com) Action Plug-ins: general purpose and specialized for [Bitwig Studio](http://www.bitwig.com) to support sending OSC message via UDP.

### Installation
Cloning this repository.
```shellscript
git clone https://github.com/jhorology/keyboard-maestro-send-osc-action.git
cd keyboard-maestro-send-osc-action
```
Install dependencies.
```shellscript
npm install
```
If Keyboard Maestro or Keyboard Maestro Engine are running, close them, and then install action plug-ins.
  - javascript version(Recomended).
    ```shellscript
    npm run install-plugin-js
    ```
  - shellscript version
    ```shellscript
    npm run install-plugin-sh
    ```

### Uninstallation
```shellscript
npm run uninstall-plugin
```

### Notes
- Javascript version is better performance than shellscript version, but you need to re-install plug-ins when the node execution path is changed. The node execution path will be appended automatically to SendOSC.js as shebang during installation.
```shellscript
#!/path/to/node.js/bin/node
```
- In the case of using nvm, .bash_profile only knows the node execution path. So shellscript version execute javascript from following shell script.
```shellscript
#!/bin/bash -l
PWD=`dirname "${0}"`
cd "${PWD}"
node SendOSC.js
```
### ToDo
- Support Keyboard Maestro variables. 
