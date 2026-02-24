#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'optparse'

class BenchmarkRunner
  BASE_APP_PATH = File.expand_path('base_app', __dir__)
  METHODS_PATH = File.expand_path('methods', __dir__)

  def initialize(method_name)
    @method_name = method_name
    @method_path = File.join(METHODS_PATH, method_name)
    @backup_gemfile = nil

    validate_method!
  end

  def run
    puts "=" * 60
    puts "Benchmarking: #{@method_name}"
    puts "=" * 60

    setup_method
    reset_and_migrate_database
    install_gems
    load_operations
    seed_data
    run_benchmarks
    restore_project_files

    puts "\n✅ Benchmark complete!"
  rescue => e
    puts "\n❌ Error: #{e.message}"
    puts e.backtrace.first(5)
    restore_project_files
    exit 1
  end

  private

  def validate_method!
    unless File.directory?(@method_path)
      puts "❌ Method '#{@method_name}' not found in methods/"
      puts "Available methods:"
      Dir.glob(File.join(METHODS_PATH, '*')).each do |dir|
        puts "  - #{File.basename(dir)}" if File.directory?(dir)
      end
      exit 1
    end

    unless File.exist?(File.join(@method_path, 'Gemfile'))
      puts "❌ Gemfile not found in #{@method_path}"
      exit 1
    end
  end

  def setup_method
    puts "\n📦 Setting up #{@method_name}..."

    # Backup original Gemfile
    gemfile_path = File.join(BASE_APP_PATH, 'Gemfile')
    @backup_gemfile = File.read(gemfile_path)

    # Add method gems to Gemfile
    method_gems = File.read(File.join(@method_path, 'Gemfile'))
    File.open(gemfile_path, 'a') do |f|
      f.puts "\n# #{@method_name} method gems"
      f.puts method_gems
    end
    puts "  ✓ Added gems to Gemfile"

    # Copy migrations
    migrations_src = File.join(@method_path, 'migrations')
    migrations_dst = File.join(BASE_APP_PATH, 'db', 'migrate')
    FileUtils.mkdir_p(migrations_dst)

    Dir.glob(File.join(migrations_src, '*.rb')).each do |migration|
      dst_file = File.join(migrations_dst, File.basename(migration))
      FileUtils.cp(migration, dst_file)
      puts "  ✓ Copied migration: #{File.basename(migration)}"
    end

    # Copy models
    models_src = File.join(@method_path, 'models')
    models_dst = File.join(BASE_APP_PATH, 'app', 'models')
    FileUtils.mkdir_p(models_dst)

    Dir.glob(File.join(models_src, '*.rb')).each do |model|
      dst_file = File.join(models_dst, File.basename(model))
      FileUtils.cp(model, dst_file)
      puts "  ✓ Copied model: #{File.basename(model)}"
    end

    # Copy operations
    copy_operations
  end

  def copy_operations
    operations_file = File.join(@method_path, 'operations.rb')
    return unless File.exist?(operations_file)

    operations_dst = File.join(BASE_APP_PATH, 'lib', 'operations')
    FileUtils.mkdir_p(operations_dst)

    dst_file = File.join(operations_dst, "#{@method_name}.rb")
    FileUtils.cp(operations_file, dst_file)
    puts "  ✓ Copied operations: #{@method_name}.rb"
  end

  def install_gems
    puts "\n💎 Installing gems..."
    run_command("cd #{BASE_APP_PATH} && bundle install --quiet")
    puts "  ✓ Gems installed"
  end

  def reset_and_migrate_database
    puts "\n🗄️  Resetting database..."
    run_command("cd #{BASE_APP_PATH} && bundle exec rake db:drop db:create", silent: true)
    puts "  ✓ Database reset"

    puts "\n📋 Running migrations..."
    run_command("cd #{BASE_APP_PATH} && bundle exec rake db:migrate")
    puts "  ✓ Migrations complete"
  end

  def load_operations
    operations_file = File.join(BASE_APP_PATH, 'lib', 'operations', "#{@method_name}.rb")
    require operations_file if File.exist?(operations_file)
  end

  def seed_data
    puts "\n🌱 Seeding data..."
    require_relative 'base_app/config/environment'

    # Clear existing data
    User.delete_all if defined?(User)

    # Create sample users with favorite colors using Operations module
    users_data = [
      { colors: %w[red blue green] },
      { colors: %w[yellow purple orange pink] },
      { colors: %w[cyan magenta lime teal indigo] },
      { colors: %w[red yellow] },
      { colors: %w[blue purple pink cyan] }
    ]

    users_data.each do |data|
      Operations.create_user(data[:colors])
    end

    puts "  ✓ Created #{User.count} users"
  end

  def run_benchmarks
    puts "\n⚡ Running benchmarks..."
    require 'benchmark'

    n = 1000

    Benchmark.bm(20) do |x|
      x.report("Create user:") do
        n.times do
          Operations.create_user(%w[red blue])
        end
      end

      x.report("Find by color:") do
        n.times do
          Operations.find_by_color('red')
        end
      end

      x.report("Update colors:") do
        User.limit(100).each do |user|
          Operations.update_user_colors(user, %w[green yellow])
        end
      end
    end

    puts "\n📊 Database stats:"
    puts "  Total users: #{User.count}"
    puts "  Users liking 'red': #{Operations.count_by_color('red')}"
  end

  def restore_project_files
    puts "\n🧹 Restoring project files..."

    # Restore original Gemfile
    if @backup_gemfile
      gemfile_path = File.join(BASE_APP_PATH, 'Gemfile')
      File.write(gemfile_path, @backup_gemfile)
      puts "  ✓ Restored Gemfile"
    end

    # Remove copied migrations
    migrations_src = File.join(@method_path, 'migrations')
    migrations_dst = File.join(BASE_APP_PATH, 'db', 'migrate')

    Dir.glob(File.join(migrations_src, '*.rb')).each do |migration|
      dst_file = File.join(migrations_dst, File.basename(migration))
      FileUtils.rm_f(dst_file)
      puts "  ✓ Removed migration: #{File.basename(migration)}"
    end

    # Remove copied models
    models_src = File.join(@method_path, 'models')
    models_dst = File.join(BASE_APP_PATH, 'app', 'models')

    Dir.glob(File.join(models_src, '*.rb')).each do |model|
      dst_file = File.join(models_dst, File.basename(model))
      FileUtils.rm_f(dst_file)
      puts "  ✓ Removed model: #{File.basename(model)}"
    end

    # Remove copied operations
    remove_operations

    # Note: Database cleanup happens at the start of the next run
  end

  def remove_operations
    operations_dst = File.join(BASE_APP_PATH, 'lib', 'operations', "#{@method_name}.rb")
    if File.exist?(operations_dst)
      FileUtils.rm_f(operations_dst)
      puts "  ✓ Removed operations: #{@method_name}.rb"
    end
  end

  def run_command(cmd, silent: false)
    output = silent ? ' > /dev/null 2>&1' : ''
    system("#{cmd}#{output}") || raise("Command failed: #{cmd}")
  end
end

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby benchmark.rb [options] METHOD"
  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

method_name = ARGV[0]

if method_name.nil?
  puts "❌ Please provide a method name"
  puts "Usage: ruby benchmark.rb METHOD"
  puts "\nExample:"
  puts "  ruby benchmark.rb array_enum"
  exit 1
end

runner = BenchmarkRunner.new(method_name)
runner.run
