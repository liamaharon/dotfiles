return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = { enabled = false },
      rust_analyzer = {
        -- disable ra-multiplex until it gets more stable
        -- cmd = { "/Users/liamaharon/grimoire/ra-multiplex/target/release/ra-multiplex", "client" },
        settings = {
          ["rust-analyzer"] = {
            rust = {
              analyzerTargetDir = "target/nvim-rust-analyzer",
            },
            server = {
              extraEnv = {
                ["CHALK_OVERFLOW_DEPTH"] = "100000000",
                ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
              },
            },
            cargo = {
              extraEnv = {
                ["SKIP_WASM_BUILD"] = "1",
              },
              features = "all",
            },
            check = {
              allTargets = true,
              command = "check",
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
              extraArgs = { "+nightly-2023-11-01" },
            },
          },
        },
      },
    },
  },
}
