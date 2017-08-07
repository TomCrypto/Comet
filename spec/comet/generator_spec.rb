require 'pathname'
require 'comet'

class TestCase
  def initialize(rootpath,
                 makefile: 'Makefile',
                 workpath: '.',
                 location: 'comet.rb',
                 filename: 'comet.rb')
    @rootpath = File.join __dir__, rootpath
    @makefile = File.join @rootpath, makefile
    @workpath = File.join @rootpath, workpath
    @location = File.join @rootpath, location
    @filename = filename
  end

  attr_reader :makefile
  attr_reader :workpath
  attr_reader :location
  attr_reader :filename

  def summary
    rootpath = Pathname.new(@rootpath)
    testname = rootpath.relative_path_from(Pathname.new(__dir__))
    makefile = Pathname.new(@makefile).relative_path_from rootpath
    location = Pathname.new(@location).relative_path_from rootpath
    workpath = Pathname.new(@workpath).relative_path_from rootpath
    "#{testname}/#{workpath} :: #{location} => #{makefile}"
  end
end

TESTS = [
  TestCase.new('empty_build_file'),
  TestCase.new('simple_c_program'),
  TestCase.new('no_build_file'),
  TestCase.new('self_referential'),
  TestCase.new('nested_circular_reference'),
  TestCase.new('empty_build_file', workpath: 'folder'),
  TestCase.new('complex_c_program'),
  TestCase.new('complex_c_program', workpath: 'src'),
  TestCase.new('complex_c_program', workpath: 'src/module_a')
].freeze

describe Comet::Generator do
  TESTS.each do |test|
    context test.summary do
      subject(:generator) { described_class.new test.filename }

      before { Dir.chdir test.workpath }

      it 'generates the expected makefile' do
        contents = File.read test.makefile # just compare
        expect(generator.makefile.contents).to eq(contents)
      end

      if File.exist? test.location
        it 'locates the expected build file' do
          expect(generator.build_file).to eq(test.location)
        end
      else
        it 'detects no build file exists' do
          expect(generator.build_file).to be_nil
        end
      end
    end
  end
end
