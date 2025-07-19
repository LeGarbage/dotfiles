return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        event = { "User PersistenceLoadPost", "BufReadPost" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>ha", function()
                local list = harpoon:list()
                local path = vim.fn.expand("%")
                list:add()
                local index = nil
                for i, item in ipairs(list.items) do
                    if item.value == path then
                        index = i
                        break
                    end
                end
                local filename = vim.fn.fnamemodify(path, ":t")
                if index then
                    vim.notify(string.format("Harpooned %s[[%d]]", filename, index), vim.log.levels.INFO,
                        { title = "Harpoon" })
                else
                    vim.notify("File added to Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
                end
            end, { desc = "Harpoon file" })
            vim.keymap.set("n", "<leader>hd", function()
                local list = harpoon:list()
                local path = vim.fn.expand("%")
                local index = nil

                for i, item in ipairs(list.items) do
                    if item.value == path then
                        index = i
                        break
                    end
                end

                if index then
                    list:remove()
                    local filename = vim.fn.fnamemodify(path, ":t")
                    vim.notify(string.format("Released %s[[%d]]", filename, index), vim.log.levels.WARN,
                        { title = "Harpoon" })
                else
                    vim.notify("File not in Harpoon list", vim.log.levels.ERROR, { title = "Harpoon" })
                end
            end, { desc = "Release Harpooned file" })

            vim.keymap.set("n", "<leader>hh", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>hj", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>hk", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>hl", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)

            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<leader>hf", function() toggle_telescope(harpoon:list()) end,
                { desc = "Open harpoon window" })
        end,
    }
}
