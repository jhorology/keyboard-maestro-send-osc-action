[Keyboard Maestro](http://www.keyboardmaestro.com) Action Plug-in to support sending OSC message via UDP.

### Installation
- Cloning this repository.
```shellscript
git clone https://github.com/jhorology/keyboard-maestro-send-osc-action.git
cd keyboard-maestro-send-osc-action
```
- Install dependencies.
```shellscript
npm install
```
- If Keyboard Maestro or Keyboard Maestro Engine are running, close them, and then install action plug-in.
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
- Javascript version is better performance than shellscript version, but you need to re-install plug-in when the node execution path is changed. The node execution path will be appended automatically to SendOSC.js as shebang in installation process.
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
