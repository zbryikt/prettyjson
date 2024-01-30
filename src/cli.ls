fs = require "fs-extra"
require! <[js-yaml yargs]>

argv = yargs
  .option \input, do
    alias: \i
    description: 'indicating the input file instead of using stdin'
    type: \string
  .option \indent, do
    alias: \t
    description: 'amount of indentation. default 2'
    type: \number
  .option \format, do
    alias: \f
    description: 'output format. either `json` or `yaml`. default `json`.'
    type: \string
  .help \help
  .alias \help, \h
  .check (argv) ->
    if argv.f? and !(argv.f in <[json yaml]>) => throw new Error("format #{argv.f} not recognized.")
    if argv.t? and isNaN(argv.t) => throw new Error("indentation should be a number, if provided.")
    return true
  .argv

format = argv.f or \json
indent = if argv.t? => +argv.t else 2
json = JSON.parse fs.read-file-sync(argv.i or 0).toString!
if format == \json => console.log JSON.stringify(json, null, (' ' * indent))
else console.log js-yaml.dump json, {indent: indent}

