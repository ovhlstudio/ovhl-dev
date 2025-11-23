#!/bin/bash

# OMNIVERSE HIGHLAND STUDIO | LUNE INFRASTRUCTURE DEPLOYER
# Automated DevOps Setup

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}[OVHL] Starting Lune Infrastructure Deployment...${NC}"

# 1. CREATE DIRECTORIES
echo -e "${YELLOW}[1/5] Creating Directory Structure...${NC}"
mkdir -p .lune/lib
mkdir -p .lune/backups
echo -e "${GREEN}✓ Directories created (.lune, .lune/lib, .lune/backups)${NC}"

# 2. DEPLOY LIBRARY: ovhl_ops.luau
echo -e "${YELLOW}[2/5] Deploying Core Library (ovhl_ops.luau)...${NC}"
cat << 'EOF' > .lune/lib/ovhl_ops.luau
-- .lune/lib/ovhl_ops.luau
-- OVHL ENTERPRISE OPERATIONS LIBRARY
-- @Standard: v1.0.0

local fs = require("@lune/fs")
local stdio = require("@lune/stdio")
local process = require("@lune/process")
local datetime = require("@lune/datetime")

local Ops = {}

-- [[ 1. PATH CONFIGURATION ]]
Ops.Paths = {
	ServerServices = "src/ServerScriptService/OVHL/Services",
	ServerModules  = "src/ServerScriptService/OVHL/Modules",
	ClientControllers = "src/StarterPlayer/StarterPlayerScripts/OVHL/Controllers",
	ClientModules     = "src/StarterPlayer/StarterPlayerScripts/OVHL/Modules",
	SharedModules     = "src/ReplicatedStorage/OVHL/Modules",
	Backups           = ".lune/backups",
    Manifest          = "src/ReplicatedStorage/OVHL/Core/Manifest.luau"
}

-- [[ 2. LOGGING SYSTEM ]]
function Ops.Log(tag, msg, color)
	local c = color or "\27[36m" -- Cyan default
	print(string.format("%s[%s]\27[0m %s", c, tag, msg))
end

function Ops.Error(msg)
	Ops.Log("ERROR", msg, "\27[31m")
	process.exit(1)
end

-- [[ 3. FILE SYSTEM UTILS ]]
function Ops.EnsureDir(path)
	if fs.isDir(path) then return end
	local segments = path:split("/")
	local current = ""
	for _, seg in ipairs(segments) do
		current = current .. seg
		if not fs.isDir(current) and current ~= "" then
			fs.writeDir(current)
		end
		current = current .. "/"
	end
end

function Ops.Backup(path)
	if not fs.isFile(path) then return end
	Ops.EnsureDir(Ops.Paths.Backups)
	
	local fileName = path:match("(.+)/(.+)$") or path:gsub("/", "_")
	local ts = datetime.now():formatLocalTime("%Y%m%d_%H%M%S")
	local backupPath = string.format("%s/%s_%s.bak", Ops.Paths.Backups, fileName:gsub("/", "_"), ts)
	
	fs.writeFile(backupPath, fs.readFile(path))
	Ops.Log("BACKUP", "File diamankan: " .. backupPath, "\27[33m")
end

function Ops.WriteFile(path, content)
	Ops.Backup(path) -- Auto backup before write
	Ops.EnsureDir(path:match("(.+)/[^/]+$"))
	fs.writeFile(path, content)
	Ops.Log("WRITE", "Generated: " .. path, "\27[32m")
end

-- [[ 4. SURGICAL INJECTION ]]
function Ops.Inject(path, anchor, payload, mode)
	if not fs.isFile(path) then Ops.Error("Target inject tidak ditemukan: " .. path) end
	Ops.Backup(path)
	
	local content = fs.readFile(path)
	local lines = content:split("\n")
	local newLines = {}
	local injected = false
	
	for _, line in ipairs(lines) do
		if line:find(anchor, 1, true) then
			Ops.Log("MATCH", "Anchor ditemukan...", "\27[35m")
			if mode == "BEFORE" then
				table.insert(newLines, payload)
				table.insert(newLines, line)
			elseif mode == "AFTER" then
				table.insert(newLines, line)
				table.insert(newLines, payload)
			end
			injected = true
		else
			table.insert(newLines, line)
		end
	end
	
	if not injected then Ops.Error("Anchor text tidak ditemukan!") end
	
	fs.writeFile(path, table.concat(newLines, "\n"))
	Ops.Log("SURGICAL", "Injeksi kode berhasil pada " .. path, "\27[32m")
end

return Ops
EOF

# 3. DEPLOY SCRIPTS
echo -e "${YELLOW}[3/5] Deploying Automation Scripts...${NC}"

# gen_feature.luau
cat << 'EOF' > .lune/gen_feature.luau
local process = require("@lune/process")
local Ops = require("./lib/ovhl_ops")

local args = process.args
if #args < 1 then Ops.Error("Usage: lune run gen_feature <FeatureName>") end
local Name = args[1]:sub(1,1):upper() .. args[1]:sub(2)

local ServerTpl = string.format([[
-- @Service: %sService
-- @Standard: OVHL v1.0
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)
local Cfg = Loader.Module("%s", "SharedConfig")

local Hub = {}

function Hub:Init(ctx)
	self.Logger = ctx:CreateLogger("%s")
	self.Network = ctx.Network
	self.Handler = self.Network:Register("%s", Cfg.Network)
	self.Logger:Info("System", "Service Ready")
end

function Hub:Start()
end

return Hub
]], Name, Name, Name:upper(), Name)

local ClientTpl = string.format([[
-- @Controller: %sController
-- @Standard: OVHL v1.0
local Loader = require(game.ReplicatedStorage.OVHL.Core.Loader)
local Fusion = Loader.Pkg("Fusion")
local Trove = Loader.Pkg("Trove")
local Bridge = Loader.Core("Networking/Bridge").New()
local Cfg = Loader.Module("%s", "SharedConfig")

local Ctrl = {}

function Ctrl:Init(ctx)
	self.Logger = ctx:CreateLogger("%s")
	self._trove = Trove.new()
	self.Logger:Info("System", "Controller Ready")
end

function Ctrl:Start()
end

return Ctrl
]], Name, Name, Name:upper())

local ConfigTpl = string.format([[
-- @Config: %s
return {
	Meta = { Name = "%s", Version = "1.0.0" },
	Network = { Route = "%s", Requests = {}, Events = {} }
}
]], Name, Name, Name)

Ops.Log("GENESIS", "Creating Feature Bundle: " .. Name)
Ops.WriteFile(Ops.Paths.ServerModules .. "/" .. Name .. "/" .. Name .. "Service.luau", ServerTpl)
Ops.WriteFile(Ops.Paths.ClientModules .. "/" .. Name .. "/" .. Name .. "Controller.luau", ClientTpl)
Ops.WriteFile(Ops.Paths.SharedModules .. "/" .. Name .. "/SharedConfig.luau", ConfigTpl)
Ops.Log("SUCCESS", "Feature Bundle Complete.")
EOF

# gen_service.luau
cat << 'EOF' > .lune/gen_service.luau
local process = require("@lune/process")
local Ops = require("./lib/ovhl_ops")

local args = process.args
if #args < 1 then Ops.Error("Usage: lune run gen_service <ServiceName>") end
local Name = args[1]:sub(1,1):upper() .. args[1]:sub(2)

local Tpl = string.format([[
-- @Service: %sService
-- @Standard: OVHL Core
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local Service = {}

function Service:Init(ctx)
	self.Logger = ctx:CreateLogger("%s")
	self.Network = ctx.Network
	self.Logger:Info("System", "Init")
end

function Service:Start()
	self.Logger:Info("System", "Start")
end

return Service
]], Name, Name:upper())

Ops.WriteFile(Ops.Paths.ServerServices .. "/" .. Name .. "Service.luau", Tpl)
EOF

# hotfix.luau
cat << 'EOF' > .lune/hotfix.luau
local process = require("@lune/process")
local Ops = require("./lib/ovhl_ops")
local args = process.args

if #args < 4 then 
	Ops.Log("INFO", "Usage: lune run hotfix 'path' 'anchor' 'payload' 'AFTER'")
	process.exit(1) 
end

local path, anchor, payload, mode = args[1], args[2], args[3], args[4]:upper()
Ops.Inject(path, anchor, payload, mode)
EOF

echo -e "${GREEN}✓ Scripts deployed (gen_feature, gen_service, hotfix)${NC}"

# 4. DEPLOY PROTOCOLS
echo -e "${YELLOW}[4/5] Deploying AI Protocols...${NC}"
cat << 'EOF' > .lune/AI_PROTOCOLS.md
# OVHL AI DEVELOPMENT PROTOCOLS
**User:** Geu (Omniverse Highland Studio)
**Role:** Principal AI Consultant

## 🛑 CRITICAL RULES
1.  **NO MANUAL FILE CREATION:** Use `.lune` scripts.
2.  **STRICT TYPING:** All code must be `--!strict`.
3.  **NO GUESSING:** Verify paths.
4.  **SURGICAL EDITS:** Use hotfix for small changes.

## 🛠️ TOOLCHAIN COMMANDS
1.  `lune run gen_feature <Name>` (Full Feature)
2.  `lune run gen_service <Name>` (Core Service)
3.  `lune run hotfix ...` (Injection)
EOF
echo -e "${GREEN}✓ AI_PROTOCOLS.md created${NC}"

# 5. UPDATE GITIGNORE
echo -e "${YELLOW}[5/5] Updating .gitignore...${NC}"
if grep -q ".lune/backups" .gitignore; then
    echo -e "${CYAN}.gitignore already contains backups.${NC}"
else
    echo "" >> .gitignore
    echo "# Lune Automation" >> .gitignore
    echo ".lune/backups/" >> .gitignore
    echo -e "${GREEN}✓ Added .lune/backups/ to .gitignore${NC}"
fi

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}   OVHL LUNE INFRASTRUCTURE: DEPLOYED   ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "You can now run: ${CYAN}lune run gen_service Analytics${NC} to test."