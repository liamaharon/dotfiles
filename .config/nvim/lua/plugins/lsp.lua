return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            diagnostics = { disabled = { "unresolved-macro-call" } },
            check = {
              -- Run RA on remote
              overrideCommand = {
                "crunch",
                "-e",
                "SKIP_WASM_BUILD=1",
                "c",
                "--message-format=json",
                "--all-features",
                "--all-targets",
                "--target-dir=target/ra",
              },
            },
            cargo = {
              targetDir = "target/ra",
              extraEnv = {
                ["SKIP_WASM_BUILD"] = "1",
              },
              features = "all",
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
                ["async-std"] = { "async_std" },
              },
            },
            rustfmt = {
              extraArgs = { "+nightly" },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- setup = {
      --   rust_analyzer = function()
      --     return true
      --   end,
      -- },
      servers = {
        taplo = { enabled = false },
        rust_analyzer = { enabled = false },
      },
    },
  },
}
