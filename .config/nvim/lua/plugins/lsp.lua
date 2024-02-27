return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = { enabled = false },
      rust_analyzer = {
        -- disable ra-multiplex until it gets more stable
        -- cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
        -- init_options = {
        --   lspMux = {
        --     version = "1",
        --     method = "connect",
        --     server = "rust-analyzer",
        --   },
        -- },
        settings = {
          ["rust-analyzer"] = {
            rust = {
              analyzerTargetDir = "target/nvim-rust-analyzer",
            },
            diagnostics = { disabled = { "unresolved-proc-macro" } },
            server = {
              extraEnv = {
                ["CHALK_OVERFLOW_DEPTH"] = "100000000",
                ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
              },
            },
            cargo = {
              -- Sets env and --all-features when running locally
              -- extraEnv = {
              --   ["SKIP_WASM_BUILD"] = "1",
              -- },
              -- features = "all",

              -- Run RA on remote
              buildScripts = {
                overrideCommand = {
                  "cargo",
                  "remote",
                  "--build-env",
                  "SKIP_WASM_BUILD=1",
                  "--",
                  "check",
                  "--workspace",
                  "--message-format=json",
                  "--all-targets",
                  "--all-features",
                },
              },
            },
            check = {
              -- Run RA locally
              -- allTargets = true,
              -- command = "check",

              -- Run RA on remote
              overrideCommand = {
                "cargo",
                "remote",
                "--build-env",
                "SKIP_WASM_BUILD=1",
                "--",
                "check",
                "--workspace",
                "--message-format=json",
                "--all-targets",
                "--all-features",
              },
            },
            checkOnSave = true,
            procMacro = {
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
                ["async-std"] = { "async_std" },
              },
            },
            rustfmt = {
              extraArgs = { "+nightly-2024-01-22" },
            },
          },
        },
      },
    },
  },
}
