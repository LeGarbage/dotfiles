return {
    settings = {
        ["nil"] = {
            formatting = {
                command = {
                    "nixfmt"
                }
            },
            nix = {
                maxMemoryMB = nil,
                flake = {
                    autoEvalInputs = true
                }
            }
        }
    }
}
