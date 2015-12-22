through = require 'through2'
gutil = require 'gulp-util'
path = require 'path'
tree = require './tree'

PLUGIN_NAME = 'gulp-yaml-dirs'

setGlobalError = (context, callback) ->
  (errMsg) ->
    context.emit 'error', new gutil.PluginError PLUGIN_NAME, " #{errMsg}"
    context.emit 'end'
    return callback()

module.exports = (config) ->
  # Handle results in this task
  result = {}
  # Real task
  yamlDirs = (file, enc, callback) ->
    setError = setGlobalError @, callback
    # No support for streams yet.
    return setError 'No stream support!' if file.isStream()
    # Check if buffer is a directory
    return setError 'Not a directory' unless file.isDirectory()
    # Analyse directory and create the tree structure as JSON
    result = tree file.path
    callback()
  # Task as a transform stream
  through.obj yamlDirs, (callback) ->
    setError = setGlobalError @, callback
    # Check if tree analysis worked
    return setError 'No directories found' if result is {}
    # Check if a result file is provided
    return setError 'No provided result filename' unless config
    return setError 'Filename must be a string' if typeof config isnt 'string'
    # Create and push new vinyl file
    currentPath = process.cwd()
    @push new gutil.File
      cwd: currentPath
      base: config
      path: path.join currentPath, config
      contents: new Buffer JSON.stringify result
    gutil.log gutil.colors.green PLUGIN_NAME, gutil.colors.white 'generates',
      gutil.colors.blue config
    callback()
