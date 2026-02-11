return {
    "DrKJeff16/project.nvim",
    cmd = { -- Lazy-load by commands
        "ProjectAdd",
        "ProjectDelete",
        "ProjectExportJSON",
        "ProjectImportJSON",
        "ProjectRecents",
        "ProjectTelescope",
    },
    dependencies = { -- OPTIONAL. Choose any of the following
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
    },
    opts = {},
}
