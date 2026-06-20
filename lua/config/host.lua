-- config/host.lua - Per-machine detection
--
-- This config is shared across two machines via one git branch (main):
--   * macOS laptop   -> is_mac = true
--   * ORCD cluster   -> is_mac = false  (Linux, over SSH)
--
-- Only a handful of settings differ per machine (python host program and
-- clipboard handling). Everything else is shared. Branch on these flags for
-- machine-specific values so `git pull` "just works" on both with no manual
-- per-machine setup. See CLUSTER_SETUP.md.

local M = {}

M.is_mac = vim.fn.has('mac') == 1
M.is_cluster = not M.is_mac

return M
