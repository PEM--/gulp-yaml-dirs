# gulp-yaml-dirs
Create a JSON file from YAML file in a directory structure

## Introduction
Suppose that you have multiple YAML file in a directory structure like so:
```
i18n
├── global.yml
└── schemas
    ├── address.yml
    └── configuration.yml
```

Using this plugin will create the following JSON file:
```
{
  // Content of global.yml as JSON
  ...
  "schemas": {
    // Content of address.yml as JSON
    ...
    // Content of configuration.yml as JSON
    ...
  }
}
```

## Installation
Install this plugin as a NPM development dependency:
```sh
npm i -D gulp-yaml-dirs
```

## Usage
A simple example for generating DRY translation from a directory of YAML files:
```coffee
gulp = require 'gulp'
gp = (require 'gulp-load-plugins')()
del = require 'del'
yamlDirs = require './tools/gulp-yaml-dirs'

i18n =
  src: 'i18n/**/*.yml'
  temp: 'i18n.json'
  dest: 'app/i18n'

gulp.task 'i18n.clean', ->
  del [i18n.dest]

gulp.task 'i18n.build', ->
  gulp.src 'i18n', read: false
    # Avoid breaking stream on error and notify error
    .pipe gp.plumberNotifier()
    # Concatenante YAML files and transform them into JSON
    .pipe yamlDirs i18n.temp
    # Separate translations into one file per locale
    .pipe gp.i18nCompile '[locale].json', localePlaceholder: "[locale]"
    # Set the proper extension required by TAPi18n
    .pipe gp.rename extname: '.i18n.json'
    .pipe gulp.dest i18n.dest

gulp.task 'i18n.watch', -> gulp.watch i18n.src, ['i18n.build']

gulp.task 'clean', ['i18n.clean']
gulp.task 'build', ['i18n.build']
gulp.task 'watch', ['i18n.watch']
gulp.task 'default', ['clean', 'build', 'watch']

```
