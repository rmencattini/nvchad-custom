--[[ The real heros => u/b3zi   github.com/b3z
reddit link => https://www.reddit.com/r/neovim/comments/zrgufk/trying_to_add_lombok_to_jdtls_failing_terribly/
github link => https://github.com/b3z/nvimConfig/blob/master/lua/user/lsp/settings/jdtls.lua
lsp-zero kudos => https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md ]]

local home = os.getenv("HOME")
if vim.fn.has("mac") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "mac"
elseif vim.fn.has("unix") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "linux"
else
  print("Unsupported system")
end

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local local_on_attach = (function(_, bufnr)
  -- Set the completion shortcut + go back
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gn", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "gp", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format() end, { buffer = bufnr })
  vim.keymap.set("n", "<leader>coi", function() require('jdtls').organize_imports() end, opts)
end)

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_path ..
    "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
)
-- print(vim.inspect(bundles))

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local config = {
  cmd = {
    -- 💀
    "java",     -- or '/path/to/java11_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    -- 💀
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    -- 💀
    -- See `data directory configuration` section in the README
    "-data",
    workspace_dir,
  },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
  handlers = {},
  root_dir = require("jdtls.setup").find_root({ "build.gradle", "pom.xml", ".git" }),
  contentProvider = { preferred = "fernflower" },
  on_init = on_init,
  on_attach = local_on_attach,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- runtimes = {
        --   {
        --     name = "JavaSE-11",
        --     path = "/usr/lib/jvm/java-11-openjdk/",
        --     default = true
        --   },
        --   -- {
        --   --   name = "JavaSE-17",
        --   --   path = "/usr/lib/jvm/java-17-openjdk/",
        --   -- },
        -- },
      },

      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",           -- literals, all, none
        },
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },
}

local function jdtls_setup(_)
  require('jdtls').start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java', 'groovy' },
  callback = jdtls_setup,
})
