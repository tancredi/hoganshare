fs = require 'fs'
Hogan = require 'hogan.js'

getTemplates = (sharedDir, ext = "html") ->
    templates = []
    exportTemplate = Hogan.compile fs.readFileSync(__dirname + "/../views/templates.js.mustache", "utf8")

    getDirFiles = (dir) -> fs.readdirSync dir

    fetchTemplates = (dir) ->
        for file in getDirFiles dir
            if file.substr(file.length - 5) is ".#{ext}"

                path = dir + '/' + file
                ns = path
                .replace(sharedDir, '')
                .substr(1)
                .replace(".#{ext}", '')
                template = Hogan.compile fs.readFileSync(path, "utf8"), { asString: true }

                templates.push { file: path, ns: ns.replace(/(\/)/g, '.'), template: template }

            else fetchTemplates "#{dir}/#{file}" 

    fetchTemplates sharedDir
    if templates.length isnt 0 then templates[templates.length - 1].last = true
    return exportTemplate.render({ templates: templates })

exports.getTemplates = getTemplates