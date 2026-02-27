vim.filetype.add({
    filename = {
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
    },
    pattern = {
        [".*/.gitlab%-ci%.yml"] = "yaml.gitlab",
        [".*/.gitlab/ci/.*%.yml"] = "yaml.gitlab",
    },
})
