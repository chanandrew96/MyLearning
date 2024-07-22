# Reason why you should use `SocketsHttpHandler` than `HttpClientHandler`
If you are using .NET 6 or above, and your working on the HTTP Client that required to send request with SSL certificate from Certificate Manager (`certmgr`).  
You may properly faced issue that the client certificate is rejected by the IIS server.  
After lots of logging and debugging, found that the `HttpClientHandler` ran into issue of handling the certificate with .NET 6 or above.  
According to [Microsoft Document](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.socketshttphandler?view=net-8.0#remarks), SocketsHttpHandler can be a replacement for `SocketsHttpHandler`.  
> Starting with .NET Core 2.1, the SocketsHttpHandler class provides the implementation used by higher-level HTTP networking classes such as HttpClient. 

## Sample Code for using SocketHttpHandler
``` C#
SocketsHttpHandler handler = new SocketsHttpHandler();
# Enable the SSL Protocols
# Below enabled TLS 1.2
handler.SslOptions.EnabledSslProtocols = SslProtocols.Tls12;
# Get the certificate from certmgr
X509Store store = new X509Store(storeName: 5, StoreLocation.LocalMachine);
store.Open(OpenFlags.ReadOnly);
# Add the certificate to the handler
handler.SslOptions.ClientCertificates = new X509CertificateCollection { store.Certificates.FirstOrDefault() };
HttpClient _httpClient = new HttpClient(handler);
```
