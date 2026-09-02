# Cached output of Enter-VsDevShell -Arch amd64 -HostArch amd64 for the
# Visual Studio 2022 Community installation on this machine.
function enable_msvc_2022_cached() {
    $cachedEnvironment = [ordered]@{
        COMMANDPROMPTTYPE = 'Native'
        DEVENVDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\'
        EXTENSIONSDKDIR = 'C:\Program Files (x86)\Microsoft SDKs\Windows Kits\10\ExtensionSDKs'
        EXTERNAL_INCLUDE = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\ATLMFC\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\include;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\ucrt;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\um;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\shared;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\winrt;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\cppwinrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um'
        FRAMEWORK40VERSION = 'v4.0'
        FRAMEWORKDIR = 'C:\Windows\Microsoft.NET\Framework64\'
        FRAMEWORKDIR64 = 'C:\Windows\Microsoft.NET\Framework64\'
        FRAMEWORKVERSION = 'v4.0.30319'
        FRAMEWORKVERSION64 = 'v4.0.30319'
        FSHARPINSTALLDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools'
        HTMLHELPDIR = 'C:\Program Files (x86)\HTML Help Workshop'
        INCLUDE = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\ATLMFC\include;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\VS\include;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\ucrt;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\um;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\shared;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\winrt;C:\Program Files (x86)\Windows Kits\10\include\10.0.28000.0\cppwinrt;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um'
        LIB = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\ATLMFC\lib\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\lib\x64;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\lib\um\x64;C:\Program Files (x86)\Windows Kits\10\lib\10.0.28000.0\ucrt\x64;C:\Program Files (x86)\Windows Kits\10\lib\10.0.28000.0\um\x64'
        LIBPATH = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\ATLMFC\lib\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\lib\x64;C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\lib\x86\store\references;C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.28000.0;C:\Program Files (x86)\Windows Kits\10\References\10.0.28000.0;C:\Windows\Microsoft.NET\Framework64\v4.0.30319'
        NETFXSDKDIR = 'C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\'
        UCRTVERSION = '10.0.28000.0'
        UNIVERSALCRTSDKDIR = 'C:\Program Files (x86)\Windows Kits\10\'
        VCIDEINSTALLDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\'
        VCINSTALLDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\'
        VCPKG_ROOT = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\vcpkg'
        VCTOOLSINSTALLDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\'
        VCTOOLSREDISTDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\14.44.35112\'
        VCTOOLSVERSION = '14.44.35207'
        VISUALSTUDIOVERSION = '17.0'
        VS170COMNTOOLS = 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\'
        VSCMD_ARG_APP_PLAT = 'Desktop'
        VSCMD_ARG_HOST_ARCH = 'x64'
        VSCMD_ARG_TGT_ARCH = 'x64'
        VSCMD_VER = '17.14.39'
        VSINSTALLDIR = 'C:\Program Files\Microsoft Visual Studio\2022\Community\'
        WINDOWSLIBPATH = 'C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.28000.0;C:\Program Files (x86)\Windows Kits\10\References\10.0.28000.0'
        WINDOWSSDKBINPATH = 'C:\Program Files (x86)\Windows Kits\10\bin\'
        WINDOWSSDKDIR = 'C:\Program Files (x86)\Windows Kits\10\'
        WINDOWSSDKLIBVERSION = '10.0.28000.0\'
        WINDOWSSDKVERBINPATH = 'C:\Program Files (x86)\Windows Kits\10\bin\10.0.28000.0\'
        WINDOWSSDKVERSION = '10.0.28000.0\'
        WINDOWSSDK_EXECUTABLEPATH_X64 = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\'
        WINDOWSSDK_EXECUTABLEPATH_X86 = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\'
        __DOTNET_ADD_64BIT = '1'
        __DOTNET_PREFERRED_BITNESS = '64'
    }

    $cachedPathPrefix = @(
        'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\HostX64\x64'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\VCPackages'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn'
        'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64'
        'C:\Program Files (x86)\HTML Help Workshop'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Team Tools\DiagnosticsHub\Collector'
        'C:\Program Files (x86)\Windows Kits\10\bin\10.0.28000.0\x64'
        'C:\Program Files (x86)\Windows Kits\10\bin\x64'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\amd64'
        'C:\Windows\Microsoft.NET\Framework64\v4.0.30319'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools'
    )

    $cachedPathSuffix = @(
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\VC\Linux\bin\ConnectionManagerExe'
        'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\vcpkg'
    )

    $compilerPath = Join-Path $cachedEnvironment.VCTOOLSINSTALLDIR 'bin\HostX64\x64\cl.exe'
    if (-not (Test-Path -LiteralPath $compilerPath -PathType Leaf)) {
        throw "Cached MSVC environment is stale; compiler not found at '$compilerPath'."
    }

    $seenPathEntries = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $pathEntries = [System.Collections.Generic.List[string]]::new()
    $allPathEntries = @(
        $cachedPathPrefix
        $env:PATH -split ';'
        $cachedPathSuffix
    )

    foreach ($entry in $allPathEntries) {
        if ([string]::IsNullOrWhiteSpace($entry)) {
            continue
        }

        $pathEntry = $entry.Trim()
        $pathKey = $pathEntry.TrimEnd([char]'\')
        if ($seenPathEntries.Add($pathKey)) {
            $pathEntries.Add($pathEntry)
        }
    }

    $env:PATH = $pathEntries -join ';'
    foreach ($entry in $cachedEnvironment.GetEnumerator()) {
        [System.Environment]::SetEnvironmentVariable($entry.Key, $entry.Value, 'Process')
    }
}
Export-ModuleMember -Function enable_msvc_2022_cached
