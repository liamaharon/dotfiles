return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = { enabled = false },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
              extraEnv = {
                ["CARGO_TARGET_DIR"] = "target/nvim-rust-analyzer",
                ["SKIP_WASM_BUILD"] = "1",
                ["CHALK_OVERFLOW_DEPTH"] = "100000000",
              },
            },
            check = {
              allTargets = true,
              command = "check",
            },
            checkOnSave = true,
            -- procMacro = {
            --   ignored = {
            --     -- disable these if we get weird errors compiling
            --     ["async-trait"] = { "async_trait" },
            --     ["napi-derive"] = { "napi" },
            --     ["async-recursion"] = { "async_recursion" },
            --     ["async-std"] = { "async_std" },
            --   },
            -- },
            rustfmt = {
              extraArgs = { "+nightly-2023-11-01" },
            },
          },
        },
      },
    },
  },
}
