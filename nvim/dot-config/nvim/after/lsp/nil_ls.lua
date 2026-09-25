return {
    settings = {
        ["nil"] = {
            formatting = {
                command = {
                    "nixfmt"
                }
            },
            nix = {
                maxMemoryMB = vim.NIL,
                flake = {
                    autoEvalInputs = true
                }
            }
        }
    }
}
