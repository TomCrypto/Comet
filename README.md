Comet
=====

Comet is a no-nonsense build tool primarily oriented towards embedded or cross-compiled applications written in languages that can compile to LLVM bitcode, such as C, C++, D, etc. It adheres to four core principles:

 * **Simplicity**: Your build tool should be your friend, not your enemy. Comet does not force you to learn crazy languages and use strange idiosyncracies to build your program, instead exposing a simple and pleasant DSL to describe how you want your program built.

 * **Predictability**: Good software should be predictable, so Comet requires you to specify every aspect of your build configuration, leaving no opportunity for hazardous defaults to sneak in. Comet also steers you away from bad practices by enforcing sane conventions.

* **Focus**: Comet does not try to deal with the rest of your release process, such as generating documentation, preparing artifacts, running tests, and so on. Comet is concerned solely with the process of building your source files into executables, and is easily integrated into other scripts.

 * **Performance**: Due to Comet's design and LLVM integration, you get many features for free such as whole-program optimization, cross-compilation and multi-language support. Comet itself is also efficient and does not slow down your builds.

Functionally, Comet is a Makefile generator which accepts a domain-specific language from a build file, produces a Makefile, and executes it, placing all intermediate files inside a hidden `.comet` temporary directory. The only thing you need to do as a developer is write your `comet.rb` build file and add `.comet` to your gitignore file.

**WARNING**: this software is still in the testing phase, use in production at your own risk. Improvement suggestions and pull requests are welcome and appreciated. Currently only C and C++ language support is implemented through Clang and the tool probably only works on Linux as of now, but just a couple parts of the code are OS-dependent.

Installation
------------

    gem install comet-build

Comet wraps Make, consuming only two command line arguments and forwarding the rest.

  - `-f PATH`: search for the build file at the specified path instead of `comet.rb`
  - `-s`: don't execute the generated Makefile, print it to standard output instead

Comet generates the following convenience Make targets:

 - `all`: build absolutely everything (this is also the default target)
 - `clean`: delete the `.comet` folder (there is no invididual clean)

It doesn't matter where in your source tree you invoke Comet, as it will walk its way back up the filesystem looking for your build file until it hits a filesystem boundary, similar to Git. Furthermore, the `.comet` folder is always next to the build file Comet is operating on.

No external (non-Ruby) dependencies are required for *generating* the Makefile. However, the Makefile itself expects the Clang and LLVM tools to be installed in the user's path. If cross-compiling, it also requires the appropriate binutils toolchains to be installed, e.g. `arm-none-eabi` for embedded ARM software. When executing the Makefile, Comet will call out to the system's Make implementation, which can be overridden with the `MAKE` environment variable.

Supported Languages
-------------------

Language support for compiling source files is shown below. Adding support for a language consists of supplying a suitable DSL object for it, and implementing a Make rule to compile source files of this language into a single LLVM bitcode file. This Make rule will need to call out to language-specific compilers and other tools, which should be documented in the table below.

| Language | DSL keyword | Required compilers |
| -------- | ----------- | ------------------ |
| *Native* | `:native`   | None (link-only)   |
| C        | `:c`        | Clang              |
| C++      | `:cpp`      | Clang              |

Native languages are those for which the source code is either already LLVM bitcode, or is already in a lower representation than LLVM IR, such as assembly. These will be passed directly to the linker after compiled LLVM bitcode, therefore:

 * they cannot reference symbols from non-native source files
 * they must be given in the usual "reverse dependency" order
 * they must actually be accepted by the linker as input files

Planned features
----------------

 - Windows support
 - Clarification of linker parameters (triple, isa, cpu)
 - Ability to import other build files recursively
 - Integration with other build systems when linking vendored libraries

Build File Syntax
-----------------

The Ruby DSL used for describing your program is very straightforward. You begin by defining three high-level structures:

 - `software`, describing hardware-agnostic source code
 - `hardware`, describing source code tied to a specific device
 - `firmware`, describing software/hardware combinations of interest

All paths in the build file are relative to the build file's location. Spaces in filenames are **not** supported. The ordering of distinct directives is unimportant, i.e. you do not have to specify them in this order. The relative ordering of some directives, however, is meaningful, such as library imports which are passed to the linker in order of appearance.

Note that Ruby allows you to write blocks with either `do` and `end` or curly braces. Curly brace blocks are not always usable syntactically in some cases, but the DSL does not hit any of them, so just use whichever style you prefer - `do` and `end` will be used throughout this section.

### Software Directive

A `software` directive must be uniquely named, and may include any number of `source` directives (but at least one) describing the source code contained under it. It may also include any number of dependencies, which can be either software or hardware directives, referenced by name. Software directives cannot include *native* source directives.

#### Grammar

```ruby
software 'name', depends: ['dep1', 'dep2', ...] do
  # source directives
end
```

#### Examples

```ruby
software 'i2c', depends: ['i2c-hal'] do
  source language: :c, headers: 'include' do
    import 'src/drivers/i2c.c'
  end
end
```

### Hardware Directive

A `hardware` directive need not be uniquely named (it is namespaced by the device it targets) and may include any number of `source` directives, including none at all. It must specify a single `targets:` parameter, indicating which device is being targeted; the device name itself is arbitrary and is referenced in subsequent `firmware` directives. If native source directives are included, they must be compatible with the targeted device.

#### Grammar

```ruby
hardware 'name', targets: :device do
  # source directives
  # import directives
  # linker directive
end
```

#### Examples

```ruby
hardware 'startup', targets: :lpc1114 do
  linker 'arm-none-eabi', isa: 'armv6', cpu: 'cortex-m0' do
    script 'src/LPC1114.ld'
    option :nostdlib
  end
end
```

### Firmware Directive

A `firmware` directive must be uniquely named, and takes an `imports` parameter referencing `software` directives by name. It may include any number of `target` directives, enumerating which devices to build the imported software for. A firmware directive becomes a Make target of the same name, which will build the firmware against *all* the specified devices. Additional Make targets of the form `firmware/device` will build it for individual devices.

#### Grammar

```ruby
firmware 'name', imports: ['software1', 'software2', ...] do
  # target directives
end
```

#### Examples

```ruby
firmare 'hello_world', imports: ['hello_world_main'] do
  target :linux_x64 do
    elf 'bin/hello_world'
  end
end
```

### Linker Directive

Exactly one hardware directive per firmware per device must have a linker directive, which describes how the source code is to be linked together into an executable. The optimization parameter is used for whole-program link time optimization, and can be either a symbol or an integer passed to the linker via `-O`, e.g. `2` for `-O2` or `:fast` for `-Ofast`. Options are passed as-is to the linker, and a linker script can be provided.

#### Grammar

```ruby
linker 'triple', isa: 'isa', cpu: 'cpu', opt: :opt do
  # option directives
  # script directive
end
```

#### Example

```ruby
linker 'arm-none-eabi', isa: 'armv6-m', cpu: 'cortex-m0', opt: :fast do
  script 'src/cortex-m0.ld'
  option :nostdlib
end
```

### Target Directive

A `target` directive takes a single device name as a parameter, and includes any number of output directives such as `elf` or `bin`. These directives control whether to generate a given build artifact, and where to place it.

The following output directives are available:

 - `elf`: links the software for the device into an ELF file
 - `bin`: runs the ELF file through `objcopy -O binary`
 - `hex`: runs the ELF file through `objcopy -O ihex`
 - `map`: generates a map file while linking

#### Grammar

```ruby
target :device do
  # elf directive
  # bin directive
  # hex directive
  # map directive
end
```

#### Examples

```ruby
target :cortex_m4 do
  elf 'bin/program.elf'
  map 'bin/program_layout.map'
end
```

### Source Directive

A source directive represents a collection of source files of the same language and configuration. All parameters and nested directives depend on the language selected, which the exception of `language:` which specifies said language.

```ruby
source language: :language, ... do
  # language-specific directives
end
```

### Native Source Directive

Native source directives have no options besides importing files. The source files provided will be passed directly to the linker, in the order given, with no processing performed on them. They can be whatever format the linker understands, such as assembly files or object files for the correct architecture.

#### Grammar

```ruby
source language: :native do
  # import directives
end
```

#### Examples

```ruby
source language: :native do
  import 'src/main.S'
  import 'lib/startup-armv6.o'
end
```

### C/C++ Source Directive

C/C++ source directives take an array of header include paths as a parameter, and accept source file import directives, option directives (to pass in compiler flags) and define directives (to pass in preprocessor macros).

#### Grammar

```ruby
source language: :c|:cpp, headers: ['dir1', 'dir2', ...] do
  # import directives
  # option directives
  # define directives
end
```

#### Examples

```ruby
source language: :c, headers: ['include'] do
  import 'src/main.c'
  option :ffreestanding
  define :NDEBUG
  define :_POSIX_C_SOURCE => '200809L'
end
```

You can unset a previously defined option by using the special symbol `:remove` as a value. For instance:

```ruby
option :Werror => :remove
```

Advanced Usage
--------------

### Mixins and Ruby Procs

You can use Ruby procs together with the `inject` shorthand, which will effectively run your proc in the context of a directive, like so:

```ruby
cflags = proc do
  option :myflag => 'myvalue'
end

# later...

source language: :c do
  inject &cflags
end
```

### Using Ruby in the build file

The build file is otherwise ordinary Ruby code extended with a custom DSL, therefore you can write any Ruby code inside it, although it is encouraged to keep the build file free of undocumented dependencies such as gems or external commands. For instance, you can do this:

```ruby
source language: :c, headers: 'include' do
  define :VERSION => quote(`git rev-parse HEAD`)
end
```

### Hardware Abstraction Layers

Because hardware directive names are namespaced by the device they target, HALs are supported by default, as shown below. When built for a given device, this `hal` software directive will resolve to the appropriate hardware directive for that device, assuming one is present:

```ruby
software 'module', depends: ['hal'] do
  # ...
end

hardware 'hal', targets: :device1 do
  # ...
end

hardware 'hal', targets: :device2 do
  # ...
end
```

### Overriding external programs

Any external tool called by a Comet-generated Makefile can be overridden through environment variables of the form `COMET_TOOLNAME`. For instance, `cp` is invoked through `COMET_CP`, `clang` is invoked through `COMET_CLANG`, and so on. You can see the list of tools by inspecting the generated Makefile with `comet -s`, they will be at the top.

### Some helper Ruby methods

In the spirit of its DSL, Comet defines some convenience methods to make your build file more expressive.

#### quote

The **quote** method will take a string, strip any surrounding whitespace, and surround the result in double quotes. This is useful for passing strings to the C preprocessor through macros. For instance, `define :FOO => quote('bar')` translates to `-DFOO=\"bar\"` which is equivalent to `#define FOO "bar"`.

License
-------

This software is released under the MIT license. See the LICENSE file for details.
