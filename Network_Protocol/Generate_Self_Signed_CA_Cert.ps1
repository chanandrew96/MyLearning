# Set the certificate parameters
$certName = "MySelfSignedCA"
$certFriendlyName = "My Self-Signed CA Certificate"
$certPassword = "Unisys2008"
$certDays = 3650
$certPath = "C:\temp\Self_SignedCA_Cert"
$exportCertpfxPath = "C:\temp\Self_SignedCA_Cert\${certName}.pfx"

# Create a new self-signed certificate
$cert = New-SelfSignedCertificate -Subject $certName -CertStoreLocation $certPath -FriendlyName $certFriendlyName -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddDays($certDays) -HashAlgorithm SHA256 -KeyUsage CertSign,CRLSign,DigitalSignature

# Export the certificate to a PFX file
$certExport = Export-PfxCertificate -Cert $cert -FilePath "${exportCertpfxPath}" -Password (ConvertTo-SecureString -String $certPassword -Force -AsPlainText)

# Display the thumbprint of the new certificate
Write-Host "Certificate thumbprint: $($cert.Thumbprint)"
