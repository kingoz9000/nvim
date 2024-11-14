return {
  {
    "mfussenegger/nvim-dap",
    lazy = true, -- Optional, to load it on demand
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Start/Continue debugging" },
      { "<F6>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F7>", function() require("dap").step_into() end, desc = "Step into" },
      { "<F8>", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Set conditional breakpoint" },
    },
    config = function()
      local dap = require("dap")
      
      -- Setup the Python adapter
dap.adapters.python = {
  type = 'executable',
  command = 'python',  -- System Python interpreter with debugpy installed
  args = { '-m', 'debugpy.adapter' },
}
     
      -- Python launch configuration
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = "${file}",  -- Debug the current file
          pythonPath = function()
            -- Automatically use the virtual environment if available
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
              return venv_path .. "/bin/python"
            else
              return "python"  -- Fall back to system Python
            end
          end,
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    config = function()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python") -- Update the path if needed
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Automatically open/close DAP UI on debug start/end
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}

