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
    install_gems
    run_migrations
    seed_data
    run_benchmarks
    cleanup
    
    puts "\n✅ Benchmark complete!"
  rescue => e
    puts "\n❌ Error: #{e.message}"
    puts e.backtrace.first(5)
    cleanup
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

    unless File.exist?(File.join(@method_path, 'gems.rb'))
      puts "❌ gems.rb not found in #{@method_path}"
      exit 1
    end
  end

  def setup_method
    puts "\n📦 Setting up #{@method_name}..."
    
    # Backup original Gemfile
    gemfile_path = File.join(BASE_APP_PATH, 'Gemfile')
    @backup_gemfile = File.read(gemfile_path)
    
    # Add method gems to Gemfile
    method_gems = File.read(File.join(@method_path, 'gems.rb'))
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
  end

  def install_gems
    puts "\n💎 Installing gems..."
    run_command("cd #{BASE_APP_PATH} && bundle install --quiet")
    puts "  ✓ Gems installed"
  end

  def run_migrations
    puts "\n🗄️  Running migrations..."
    run_command("cd #{BASE_APP_PATH} && bundle exec rake db:create db:migrate")
    puts "  ✓ Migrations complete"
  end

  def seed_data
    puts "\n🌱 Seeding data..."
    require_relative 'base_app/config/environment'
    
    # Clear existing data
    User.delete_all if defined?(User)
    
    # Create sample users with favorite colors
    colors = %w[red green blue yellow purple orange pink cyan magenta lime teal indigo]
    
    users_data = [
      { favorite_colors: %w[red blue green] },
      { favorite_colors: %w[yellow purple orange pink] },
      { favorite_colors: %w[cyan magenta lime teal indigo] },
      { favorite_colors: %w[red yellow] },
      { favorite_colors: %w[blue purple pink cyan] }
    ]
    
    users_data.each do |data|
      User.create!(data)
    end
    
    puts "  ✓ Created #{User.count} users"
  end

  def run_benchmarks
    puts "\n⚡ Running benchmarks..."
    require 'benchmark'
    
    n = 1000
    
    Benchmark.bm(20) do |x|
      x.report("Create user:") do
        n.times do |i|
          User.create!(favorite_colors: %w[red blue])
        end
      end
      
      x.report("Find by color:") do
        n.times do
          User.where(favorite_colors: 'red').to_a
        end
      end
      
      x.report("Update colors:") do
        User.limit(100).each do |user|
          user.update!(favorite_colors: %w[green yellow])
        end
      end
    end
    
    puts "\n📊 Database stats:"
    puts "  Total users: #{User.count}"
    puts "  Users liking 'red': #{User.where(favorite_colors: 'red').count}"
  end

  def cleanup
    puts "\n🧹 Cleaning up..."
    
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
    
    # Drop and recreate database for clean state
    run_command("cd #{BASE_APP_PATH} && bundle exec rake db:drop db:create", silent: true)
    puts "  ✓ Reset database"
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
