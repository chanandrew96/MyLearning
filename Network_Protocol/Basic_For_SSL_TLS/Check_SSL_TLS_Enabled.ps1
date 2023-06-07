# Define the target computer name or IP address
$computer = "127.0.0.1"

# Define the protocol versions to check
$protocols = "Ssl2", "Ssl3", "Tls", "Tls11", "Tls12"

# Define the registry paths for the protocol settings
$registryPaths = @{
    "Ssl2"   = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    "Ssl3"   = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    "Tls"    = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    "Tls11"  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    "Tls12"  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
}

# Loop through the protocol versions and check their settings
foreach ($protocol in $protocols) {
    # Get the registry path for the protocol
    $path = $registryPaths[$protocol]

    # Check if the protocol is enabled
    $enabled = (Get-ItemProperty -Path $path -Name "Enabled" -ErrorAction SilentlyContinue).Enabled -eq "1"

    # Check the TLS/SSL cipher suites for the protocol
    $cipherSuites = (Get-ItemProperty -Path $path -Name "DisabledByDefault" -ErrorAction SilentlyContinue).DisabledByDefault -split ","

    # Print the protocol settings
    Write-Host "Protocol (Client): $protocol"
    Write-Host "Enabled: $($enabled -as [bool])"
    Write-Host "Cipher suites:"

    foreach ($cipherSuite in $cipherSuites) {
        $cipherSuite = $cipherSuite.Trim()

        if ($cipherSuite) {
            Write-Host "- $cipherSuite"
        }
    }

    Write-Host
}


# Define the registry paths for the protocol settings
$serverRegistryPaths = @{
    "Ssl2"   = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    "Ssl3"   = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    "Tls"    = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    "Tls11"  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    "Tls12"  = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
}

# Loop through the protocol versions and check their settings
foreach ($protocol in $protocols) {
    # Get the registry path for the protocol
    $path = $serverRegistryPaths[$protocol]

    # Check if the protocol is enabled
    $enabled = (Get-ItemProperty -Path $path -Name "Enabled" -ErrorAction SilentlyContinue).Enabled -eq "1"

    # Check the TLS/SSL cipher suites for the protocol
    $cipherSuites = (Get-ItemProperty -Path $path -Name "DisabledByDefault" -ErrorAction SilentlyContinue).DisabledByDefault -split ","

    # Print the protocol settings
    Write-Host "Protocol (Server): $protocol"
    Write-Host "Enabled: $($enabled -as [bool])"
    Write-Host "Cipher suites:"

    foreach ($cipherSuite in $cipherSuites) {
        $cipherSuite = $cipherSuite.Trim()

        if ($cipherSuite) {
            Write-Host "- $cipherSuite"
        }
    }

    Write-Host
}
read-host “Press ENTER to exit...”
