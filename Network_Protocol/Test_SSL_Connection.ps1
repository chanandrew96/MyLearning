# Set the server and port information
$server = "SERVER_NAME"
$port = 11433

# Test the SSL connection
$connection = Test-NetConnection -ComputerName $server -Port $port -InformationLevel "Detailed"
if ($connection.TcpTestSucceeded) {
    if ($connection.RemoteCertificate.Subject -ne $null) {
        Write-Host "SSL connection to $server on port $port is successful."
        Write-Host "Server certificate subject: $($connection.RemoteCertificate.Subject)"
    } else {
        Write-Host "SSL connection to $server on port $port is successful, but the server certificate is not valid."
    }
} else {
    Write-Host "SSL connection to $server on port $port failed. Error message: $($connection.Exception.Message)"
}