function cmake_configure($build_type = 'Debug', $flags) {
    cmake -S . -B ./build -DBUILD_TYPE:STRING=$build_type $flags
}

function cmake_build($build_type = 'Debug', $flags) {
    cmake --build ./build --config $build_type $flags
}

Export-ModuleMember -Function cmake_configure
Export-ModuleMember -Function cmake_build

