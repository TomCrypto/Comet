software 'main', depends: ['linux-x64'] do
  source language: :c, headers: ['.'] do
    import 'main.c'
  end
end

hardware 'linux-x64', targets: :linux_x64 do
  linker 'x86_64-unknown-linux-gnu', isa: 'skylake', cpu: 'skylake', opt: 1
end

firmware 'main', imports: ['main'] do
  target :linux_x64 do
    elf 'main'
  end
end
