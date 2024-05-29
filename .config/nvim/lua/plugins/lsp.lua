return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust debuggables", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            semanticHighlighting = {
              doc = {
                comment = {
                  inject = { enable = true },
                },
              },
            },
            rust = {
              analyzerTargetDir = "target/rust-analyzer",
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
              extraEnv = {
                ["SKIP_WASM_BUILD"] = "1",
              },
              features = "all",

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
                  "--tests",
                  "--target-dir=target/rust-analyzer",
                },
              },
            },
            check = {
              -- Run RA locally
              allTargets = true,
              command = "check",

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
                "--tests",
                "--target-dir=target/rust-analyzer",
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
              extraArgs = { "+nightly-2024-04-09" },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
      servers = {
        taplo = { enabled = false },
      },
    },
  },
}
