fs          = require 'fs'
gulp        = require 'gulp'
coffeelint  = require 'gulp-coffeelint'
clean       = require 'gulp-clean'
install     = require 'gulp-install'
tap         = require 'gulp-tap'
path        = require 'path'
xmldom      = (require 'xmldom').DOMParser
xpath       = require 'xpath'
_           = require 'underscore'

$ =
  generalPlugin: 'Send OSC'
  bitwigPlugin: 'Send OSC to Bitwig Studio'
  bitwigOschtml: 'Send OSC to Bitwig Studio/bitwig-studio-2.3.0beta2-osc-doc.html'
  kmActions: "#{process.env.HOME}/Library/Application Support/Keyboard Maestro/Keyboard Maestro Actions"
  kmLibs: "#{process.env.HOME}/Library/Application Support/Keyboard Maestro/Keyboard Maestro Libraries"

gulp.task 'coffeelint', ->
  gulp.src ['*.coffee']
    .pipe coffeelint './coffeelint.json'
    .pipe coffeelint.reporter()

#  install Action Plug-in to execute javascript (recomended)
#  better performance, but you need to re-install plugin on every changing node path
gulp.task 'install-js', ['install-general-plugin-js', 'install-bitwig-plugin-js']

#  install Action Plug-in to execute shell script
#  shebang as bash -l
#  in the case of using nvm, .bash_profile only knows node path.
gulp.task 'install-sh', ['install-general-plugin-sh', 'install-bitwig-plugin-sh']

gulp.task 'uninstall', ['uninstall-general-plugin', 'uninstall-bitwig-plugin'], ->

# install general purpose plug-in as javascript
gulp.task 'install-general-plugin-js', ['uninstall-general-plugin'], ->
  gulp.src ["#{$.generalPlugin}/**/*"], read: true
    .pipe tap (file) ->
      basename = path.basename file.path
      switch basename
        when 'SendOSC.js'
          # appned shebang as node path
          b = new Buffer "#!#{process.argv[0]}\n"
          file.contents = Buffer.concat [b, file.contents]
        when 'Keyboard Maestro Action.plist'
          template = _.template file.contents.toString 'utf-8'
          file.contents = new Buffer template Script: 'SendOSC.js'
    .pipe gulp.dest "#{$.kmActions}/#{$.generalPlugin}"
    .pipe install()

# install general purpose plug-in as shellscript
gulp.task 'install-general-plugin-sh', ['uninstall-general-plugin'], ->
  gulp.src ["#{$.generalPlugin}/**/*"], read: true
    .pipe tap (file) ->
      basename = path.basename file.path
      switch basename
        when 'Keyboard Maestro Action.plist'
          template = _.template file.contents.toString 'utf-8'
          file.contents = new Buffer template Script: 'SendOSC.sh'
    .pipe gulp.dest "#{$.kmActions}/#{$.generalPlugin}"
    .pipe install()

# install specialied plug-in for bitwig as javascript
gulp.task 'install-bitwig-plugin-js', ['uninstall-bitwig-plugin'], ->
  gulp.src ["#{$.bitwigPlugin}/**/*", "#{$.generalPlugin}/SendOSC.js", "#{$.generalPlugin}/package.json"], read: true
    .pipe tap (file) ->
      basename = path.basename file.path
      switch basename
        when 'SendOSC.js'
          # appned shebang as node path
          b = new Buffer "#!#{process.argv[0]}\n"
          file.contents = Buffer.concat [b, file.contents]
        when 'Keyboard Maestro Action.plist'
          template = _.template file.contents.toString 'utf-8'
          file.contents = new Buffer template
            Script: 'SendOSC.js'
            Addresses: parseBitwigOscHtml().join('|')
    .pipe gulp.dest "#{$.kmActions}/#{$.bitwigPlugin}"
    .pipe install()

gulp.task 'install-bitwig-plugin-sh', ['uninstall-bitwig-plugin'], ->
  gulp.src ["#{$.bitwigPlugin}/**/*", "#{$.generalPlugin}/SendOSC.*", "#{$.generalPlugin}/package.json"], read: true
    .pipe tap (file) ->
      basename = path.basename file.path
      switch basename
        when 'Keyboard Maestro Action.plist'
          template = _.template file.contents.toString 'utf-8'
          file.contents = new Buffer template
            Script: 'SendOSC.js'
            Addresses: parseBitwigOscHtml().join('|')
    .pipe gulp.dest "#{$.kmActions}/#{$.bitwigPlugin}"
    .pipe install()

gulp.task 'uninstall-general-plugin', ->
  gulp.src ["#{$.kmActions}/#{$.generalPlugin}", "#{$.generalPlugin}/node_modules"] , read: false
    .pipe clean force: true

gulp.task 'uninstall-bitwig-plugin', ->
  gulp.src ["#{$.kmActions}/#{$.bitwigPlugin}", "#{$.bitwigPlugin}/node_modules"] , read: false
    .pipe clean force: true

# html to array of OSC addresses
parseBitwigOscHtml = ->
  doc = new xmldom().parseFromString fs.readFileSync $.bitwigOschtml, 'utf-8'
  for node in xpath.select '/html/body/ul/li', doc
    node.textContent[0...(node.textContent.indexOf '(')]

