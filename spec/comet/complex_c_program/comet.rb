software 'module_a', depends: ['default'] do
  source language: :c, headers: ['src', 'include'] do
    import 'src/module_a/**/*.c'
    define :FOO => 'BAR'
    option :std => 'c89'
  end
end

software 'module_b', depends: ['default'] do
  source language: :c, headers: ['src', 'include'] do
    import 'src/module_b/**/*.c'
    define :FOO => 'BAZ'
    option :std => 'c89'
  end
end

software 'main', depends: ['module_a', 'module_b'] do
  source language: :c, headers: ['src', 'include'] do
    import 'src/main.c'
    option :std => 'c89'
  end
end

hardware 'default', targets: :linux_x86 do
  linker 'x86-unknown-linux-gnu', isa: 'skylake', cpu: 'skylake', opt: :fast
end

hardware 'default', targets: :linux_x64 do
  linker 'x86_64-unknown-linux-gnu', isa: 'skylake', cpu: 'skylake', opt: 3
end

firmware 'test', imports: ['main'] do
  target :linux_x86 do
    elf 'bin/test_linux_x86.elf'
    bin 'bin/test_linux_x64.bin'
    map 'bin/test_linux_x86.map'
  end

  target :linux_x64 do
    elf 'bin/test_linux_x64.elf'
    map 'bin/test_linux_x64.map'
  end
end
