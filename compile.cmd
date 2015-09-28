rem set DIR_COMPILER=C:\Windows\Microsoft.NET\Framework64\v4.0.30319
set DIR_COMPILER=C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319

%DIR_COMPILER%\csc /define:DEBUG /optimize /out:pumpdata.exe *.cs
