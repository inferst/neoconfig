return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              targetDir = 'target/analyzer',
              allFeatures = true,
              extraEnv = {
                MACOSX_DEPLOYMENT_TARGET = '10.13',
              },
            },
          },
        },
      },
    }
  end,
}
