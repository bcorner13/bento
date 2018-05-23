require "yaml"
require "fileutils"

task :default, [:version] => [:do_all]

desc "clean, build, test, upload"
task :do_all, :version do |t,args|
  _version=args[:version]
  puts _version ? "version is #{_version}" : "no version passed"

  public_templates.each do |template|
    if config['public'].include?(box_name(template))
      sh build_cmd(template,_version)
      sh "bento test"
      short_providers=File.basename(providers,"-iso")
      sh "./art_upload art_key #{box_name(template)}-#{_version}.#{short_providers}.box"
    end
  end
end

desc "clean"
task :clean do
  FileUtils.rm_rf(['.kitchen.yml', Dir.glob('builds/*')])
end

def build_cmd(template,version)
  cmd = %W{bento build #{template}}
  cmd.insert(2, "--only #{providers}")
  cmd.insert(2, "--mirror #{ENV['PACKER_MIRROR']}") if ENV["PACKER_MIRROR"]
  cmd.insert(2, "--version #{version}")
  cmd.join(" ")
  a_to_s(cmd)
end

def version
  _version=args[:version]
  puts _version
end

def providers
  if config['providers']
    config['providers'].join(',')
  else
    puts "No Providers Specified."
    puts "Set `providers` in builds.yml"
    exit 1
  end
end

def a_to_s(*args)
  clean_array(*args).join(" ")
end

def config
  YAML.load(File.read("builds.yml"))
end

def clean_array(*args)
  args.flatten.reject { |i| i.nil? || i == "" }.map(&:to_s)
end

def box_name(template)
  bn = template.split('/')[1].gsub!(/\.json/,'')
  bn.match(/-x86_64|-amd64/) ? bn.gsub(/-x86_64|-amd64/,'') : bn
end

def public_templates
  templates = Dir.glob('**/*.json').reject{ |d| d['builds'] }
  templates.reject{ |f| f[/macos|rhel|sles|solaris|windows/] }
end
