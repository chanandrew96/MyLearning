# Set the registry paths for the SSL/TLS settings
$sslProtocolsPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
$tls10Path = "$sslProtocolsPath\TLS 1.0"
$tls11Path = "$sslProtocolsPath\TLS 1.1"
$tls12Path = "$sslProtocolsPath\TLS 1.2"
$ssl2Path = "$sslProtocolsPath\SSL 2.0"
$ssl3Path = "$sslProtocolsPath\SSL 3.0"

# Define the function to check if a registry key exists
function Test-Key($keyPath) {
    if (Test-Path -Path $keyPath) {
        return $true
    } else {
        return $false
    }
}

# Define the function to enable or disable a registry key
function Toggle-Key($keyPath, $valueName, $valueData) {  
    Clear-Host
    Write-Host "Disable/Enable Menu"
    Write-Host "---------------------"
    Write-Host "1. Disable/Enable Server only"
    Write-Host "2. Disable/Enable Client only"
    Write-Host "3. Disable/Enable both Server and Client"
    Write-Host "4. Exit"
    do {
        $selection = Read-Host "Please enter a number (1-6) to select an option."
        switch ($selection) {
            1 {
                Toggle-Server-Key -keyPath $keyPath -valueName $valueName -valueData $valueData
                read-host "Press Enter to continue..."
            }
            2 {
                Toggle-Client-Key -keyPath $keyPath -valueName $valueName -valueData $valueData
                read-host "Press Enter to continue..."
            }
            3 {
                Toggle-Server-Key -keyPath $keyPath -valueName $valueName -valueData $valueData
                Toggle-Client-Key -keyPath $keyPath -valueName $valueName -valueData $valueData
                read-host "Press Enter to continue..."
            }
            4 {
                break
            }
            default {
                Write-Host "Invalid selection. Please enter a number (1-4) to select an option."
            }
        }  
        Clear-Host
        Write-Host "Disable/Enable Menu"
        Write-Host "---------------------"
        Write-Host "1. Disable/Enable Server only"
        Write-Host "2. Disable/Enable Client only"
        Write-Host "3. Disable/Enable both Server and Client"
        Write-Host "4. Exit"
    } while ($selection -ne 4)
}

function Toggle-Server-Key($keyPath, $valueName, $valueData) {
    if (Test-Key -keyPath ${keyPath}\Server) {
        $key = Get-Item -Path ${keyPath}\Server
        if ($key.GetValue("Enabled") -eq "1") {
            Remove-Item -Path ${keyPath}\Server -Recurse -Force
            Write-Host "${keyPath}\Server disabled"
            return
        } else {
            $key.SetValue($valueName, $valueData, "DWORD")
            Write-Host "$valueName has been set to $valueData."
            return
        }
    } else {
        New-Item -Path $keyPath\Server -Force | Out-Null
        New-ItemProperty -Path $keyPath\Server -Name "Enabled" -Value 1 -Type DWord -Force | Out-Null
        Write-Host "${keyPath}\Server has been enabled."
        return
    }
}

function Toggle-Client-Key($keyPath, $valueName, $valueData) {
    if (Test-Key -keyPath ${keyPath}\Client) {
        $key = Get-Item -Path ${keyPath}\Client
        if ($key.GetValue("Enabled") -eq "1") {
            Remove-Item -Path ${keyPath}\Client -Recurse -Force
            Write-Host "${keyPath}\Server disabled"
            return
        } else {
            $key.SetValue($valueName, $valueData, "DWORD")
            Write-Host "$valueName has been set to $valueData."
            return
        }
    } else {
        New-Item -Path $keyPath\Client -Force | Out-Null
        New-ItemProperty -Path $keyPath\Client -Name "Enabled" -Value 1 -Type DWord -Force | Out-Null
        Write-Host "${keyPath}\Client has been enabled."
        return
    }
}

# Define the function to display the menu options
function Show-Menu {
    Clear-Host
    Write-Host "SSL/TLS Settings Menu"
    Write-Host "---------------------"
    Write-Host "1. Check SSL & TLS enabled or disabled (For both Server/Client)"
    Write-Host "2. Enable/Disable TLS 1.0"
    Write-Host "3. Enable/Disable TLS 1.1"
    Write-Host "4. Enable/Disable TLS 1.2"
    Write-Host "5. Enable/Disable SSL 2.0"
    Write-Host "6. Enable/Disable SSL 3.0"
    Write-Host "7. Exit"
}

# Display the menu options
Show-Menu

# Get the user's selection and perform the corresponding action
do {
    $selection = Read-Host "Please enter a number (1-6) to select an option."
    switch ($selection) {
        1 {
            $protocols = Get-ChildItem -Path $sslProtocolsPath | Where-Object { $_.PSIsContainer }
            foreach ($protocol in $protocols) {                
                # Get the registry path for the protocol
                $path = "$sslProtocolsPath\$($protocol.PSChildName)\Client"

                # Check if the protocol is enabled
                $enabled = (Get-ItemProperty -Path $path -Name "Enabled" -ErrorAction SilentlyContinue).Enabled -eq "1"

                # Check the TLS/SSL cipher suites for the protocol
                $cipherSuites = (Get-ItemProperty -Path $path -Name "DisabledByDefault" -ErrorAction SilentlyContinue).DisabledByDefault -split ","

                # Print the protocol settings
                Write-Host "Protocol (Client): $($protocol.PSChildName)\Client"
                Write-Host "Enabled: $($enabled -as [bool])"
                Write-Host "Cipher suites:"

                foreach ($cipherSuite in $cipherSuites) {
                    $cipherSuite = $cipherSuite.Trim()

                    if ($cipherSuite) {
                        Write-Host "- $cipherSuite"
                    }
                }
                                
                # Get the registry path for the protocol
                $path = "$sslProtocolsPath\$($protocol.PSChildName)\Server"

                # Check if the protocol is enabled
                $enabled = (Get-ItemProperty -Path $path -Name "Enabled" -ErrorAction SilentlyContinue).Enabled -eq "1"

                # Check the TLS/SSL cipher suites for the protocol
                $cipherSuites = (Get-ItemProperty -Path $path -Name "DisabledByDefault" -ErrorAction SilentlyContinue).DisabledByDefault -split ","

                # Print the protocol settings
                Write-Host "Protocol (Server): $($protocol.PSChildName)\Server"
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
            read-host "Press Enter to continue..."
        }
        2 {
            Toggle-Key -keyPath $tls10Path -valueName "Enabled" -valueData 0
        }
        3 {
            Toggle-Key -keyPath $tls11Path -valueName "Enabled" -valueData 0
        }
        4 {
            Toggle-Key -keyPath $tls12Path -valueName "Enabled" -valueData 0
        }
        5 {
            Toggle-Key -keyPath $ssl2Path -valueName "Enabled" -valueData 0
        }
        6 {
            Toggle-Key -keyPath $ssl3Path -valueName "Enabled" -valueData 0
        }
        7 {
            break
        }
        default {
            Write-Host "Invalid selection. Please enter a number (1-7) to select an option."
        }
    }
    Show-Menu
} while ($selection -ne 7)