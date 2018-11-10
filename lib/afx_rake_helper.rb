require "colorize"

module AfxRakeHelper
  class Task
    attr_reader :args

    def initialize(name)
      @name = name
      @description = nil
      @assertions = []
      @arg_names = []
      @commands = []
    end

    # Describe

    def describe(description)
      @description = description
    end

    def require_arg(arg_name)
      arg_name = arg_name.to_s
      @arg_names << arg_name
      return ENV[arg_name]
    end

    # Adding assertions

    def assert(error_message, &condition)
      @assertions << {
        error_message: error_message,
        condition: condition,
      }
    end

    # Adding commands

    def ruby(message, &block)
      @commands << {
        message: message,
        block: block,
      }
    end

    def verbose_command(message, &block)
      ruby("#{"$".bold} #{message.green}", &block)
    end

    def step(message, &block)
      ruby("#{"-".bold} #{message.green}", &block)
    end

    def shell(command)
      verbose_command command do
        success = system command

        if !success
          puts "#{"ERROR".red}: The above command exited with an error."
          exit 1
        end
      end
    end

    def rake(task_name)
      verbose_command "rake #{task_name}" do
        Rake::Task[task_name].invoke
      end
    end

    # Printing commands

    def print_command_message(command, colorized:)
      if colorized
        puts command[:message]
      else
        puts command[:message].uncolorize
      end
    end

    def print_command_summary
      puts "These steps will be run:".green
      for command in @commands
        print_command_message(command, colorized: false)
      end
      puts
    end

    def print_description
      return unless @description

      puts "This command will do the following:".green
      puts @description.gsub("WARNING", "WARNING".red)
      puts
    end

    def print_arg_summary
      return unless @arg_names.any?

      errors = 0
      puts "This task takes in the following arguments:"
      @arg_names.each do |arg_name|
        value = ENV[arg_name]
        errors += 1 if value.nil?
        puts " #{arg_name}=#{value || "<missing>"}"
      end
      puts

      return if errors == 0

      puts "#{"ERROR".red}: Some arguments are missing. Specify them this way:"
      puts "$ rails #{@name}" + @arg_names.map { |arg_name| " #{arg_name}=..." }.join
      exit 1
    end

    def check_assertions
      for assertion in @assertions
        return if assertion[:condition].call

        puts "#{"ERROR".red}: #{assertion[:error_message]}"
        exit 1
      end
    end

    def print_confirmation
      printf "Press enter to continue; ^C to cancel. "
      begin
        $stdin.gets
      rescue Interrupt
        puts
        exit 1
      end
      puts
    end

    # Run phases

    def before_run
      is_interactive = ENV["CI"] != "true"

      print_description
      print_arg_summary
      if is_interactive
        print_command_summary
      end
      check_assertions
      if is_interactive
        print_confirmation
      end
      return
    end

    def run
      check_assertions
      for command in @commands
        print_command_message(command, colorized: $stdout.isatty)
        command[:block].call
        puts
      end
    end

    def after_run; end
  end

  def define_task(*task_definition_args)
    task(*task_definition_args) do |task_, args|
      t = Task.new(task_.name)
      yield(t, args)

      t.before_run
      t.run
      t.after_run
    end
  end

  def define_alias(task_name, target_task_name)
    task task_name do |_, args|
      puts "Note: This is an alias for: rails #{target_task_name}"
      puts
      Rake::Task[target_task_name].invoke(*args.extras)
    end
  end
end
