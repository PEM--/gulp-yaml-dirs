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
npm i -D
```

## Usage
A simple example for generating DRY translation from a directory of YAML files:
```coffee

```
