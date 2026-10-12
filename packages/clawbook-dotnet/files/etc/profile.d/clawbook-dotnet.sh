# clawbook-dotnet: .NET SDK in /usr/lib/dotnet, CLI telemetry off.
# The same variables are in /etc/environment (managed by clawbook-dotnet),
# so they also apply to SSH sessions that start no login shell.
# The workload integrity check on first use would try to write below the
# root-owned /usr/lib/dotnet and only print a confusing warning.
export DOTNET_ROOT=/usr/lib/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export DOTNET_SKIP_WORKLOAD_INTEGRITY_CHECK=1
