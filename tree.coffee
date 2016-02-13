fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
_ = require 'lodash'

###*
 * Parse a tree as an Object.
 * Interpret YAML files as JSON Object and insert them in the tree.
 * @param  {String} filepath File path.
 * @return {Object}          A tree as a JSON Object.
###
tree = (filepath, current = {}, firstNode = true) ->
  filepath = path.normalize filepath
  stats = fs.lstatSync filepath
  baseName = path.basename filepath
  # Current path is a directory
  if stats.isDirectory() or stats.isSymbolicLink()
    current[baseName] = {}
    (fs.readdirSync filepath).forEach (child) ->
      tree (path.join filepath, child), current[baseName], false
  # Current path is a YAML file
  else if stats.isFile() and (path.extname filepath) is '.yml'
    content = fs.readFileSync filepath, 'utf8'
    token = ((path.basename filepath).split '.')[0]
    _.extend current, yaml.safeLoad content
  return if firstNode then current[baseName] else current

module.exports = tree
