-- @Core: FrameworkTypes
-- Definisi Kontrak untuk Type Checking Luau
local FrameworkTypes = {}

export type Logger = {
    Info: (self: Logger, msg: string, data: any?) -> (),
    Warn: (self: Logger, msg: string, data: any?) -> (),
    Error: (self: Logger, msg: string, data: any?) -> (),
    Debug: (self: Logger, msg: string, data: any?) -> (),
}

export type Manifest = {
    Identity: { Name: string, Namespace: string },
    Version: { Major: number, Minor: number, Patch: number, Full: string },
    Metadata: { BuildType: string }
}

export type Context = {
    Manifest: Manifest,
    Services: { [string]: any },
    CreateLogger: (self: Context, domain: string) -> Logger,
    [string]: any -- Allow dynamic injection
}

export type Service = {
    Init: (self: Service, ctx: Context) -> ()?,
    Start: (self: Service) -> ()?,
    Shutdown: (self: Service) -> ()?,
    [any]: any
}

return FrameworkTypes
