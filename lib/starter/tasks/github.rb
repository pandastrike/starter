require "starter/tasks/starter"

task "github_password" => "github_settings" do
  require "starter/password"
  if $STARTER[:settings][:github][:password] == nil
    password = Starter::Password.request("GitHub")
    $STARTER[:settings][:github][:password] = password
  end
end

task "read_settings" do
  require "yaml"
  begin
    $STARTER[:settings] = YAML.load_file("settings.yml")
  rescue Errno::ENOENT
    $stderr.puts "You do not appear to have a settings.yml file."
    if Starter::Prompt.confirm("Create a stubbed settings file?")
      File.open("settings.yml", "w") do |f|
        settings = {
          :github => {
            :user => "YOURUSERNAME", :repo => {:owner => "OWNERNAME", :name => $STARTER[:directory]}
          }
        }
        YAML.dump(settings, f)
        puts "Created settings.yml. Now go edit it and add it to .gitignore."
      end
    end
    exit
  end
end


task "github_settings" => "read_settings" do
  if $STARTER[:settings][:github] == nil
    $stderr.puts "Looks like your settings.yml file isn't set up with a github stanza."
    exit
  end
end

task "github_repo" => %w[ github_settings github_password ] do
  require 'ghee'

  settings = $STARTER[:settings][:github]
  user, password, repo = settings.values_at(:user, :password, :repo)
  ghee = Ghee.basic_auth(user,password)

  repo = ghee.repos(repo[:owner], repo[:name])
  if repo["message"]
    puts repo["message"]
    exit
  else
    $STARTER[:github_repo] = repo
  end

end

desc "Create an issue on GitHub"
task "github:issue" => "github_repo" do

  repo = $STARTER[:github_repo]
  options = {}
  $stdout.print "Title: "; $stdout.flush
  options[:title] = $stdin.readline.strip
  $stdout.print "Description: "; $stdout.flush
  options[:description] = $stdin.readline.strip
  labels = repo.labels.map { |label| label["name"] }.join(" ")
  $stdout.print "Labels (separate with spaces: [#{labels}]): "; $stdout.flush
  options[:labels] = $stdin.readline.strip.split(" ")
  $stdout.puts "Milestone:"
  repo.milestones.each do |milestone|
    $stdout.puts "#{milestone['number']} - #{milestone['title']}"
  end
  milestone = $stdin.readline.strip
  options[:milestone] = milestone unless milestone.empty?

  print "Issue details: "
  if Starter::Prompt.confirm("Create this issue?")
    result = repo.issues.create(options)
    if result["errors"]
      result["errors"].each do |error|
        $stderr.puts "#{error['resource']}: #{error['message']}"
      end
    else
      $stdout.puts "Issue ##{result['number']} created."
    end
  end
end

