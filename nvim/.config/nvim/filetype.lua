vim.filetype.add({
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
        ["go.work"] = "gowork",
        ["go.work.sum"] = "gowork",
    },
    pattern = {
        [".*/.gitlab%-ci%.yml"] = "yaml.gitlab",
        [".*/.gitlab/ci/.*%.yml"] = "yaml.gitlab",
    },
    extension = {
        gotmpl = "gotmpl",
        templ = "templ",
    },
})
