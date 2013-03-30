require "starter/tasks/starter"

desc "Create an issue on GitHub"
task "github:issues:create" => "github_repo" do

  repo = $STARTER[:github_repo]
  labels = repo.labels.map { |label| label["name"] }.join(" ")
  milestones = repo.milestones

  loop do
    options = {}
    $stdout.print "Title: "; $stdout.flush
    options[:title] = $stdin.readline.strip
    $stdout.print "Description: "; $stdout.flush
    options[:body] = $stdin.readline.strip
    $stdout.print "Labels (separate with spaces: [#{labels}]): "; $stdout.flush
    options[:labels] = $stdin.readline.strip.split(" ")
    if milestones.size > 0
      $stdout.puts "Milestone:"
      repo.milestones.each do |milestone|
        $stdout.puts "#{milestone['number']} - #{milestone['title']}"
      end
      milestone = $stdin.readline.strip
      options[:milestone] = milestone unless milestone.empty?
    end

    print "Issue details: "
    Starter::Prompt.confirm("Create this issue?") do
      result = repo.issues.create(options)
      if result["errors"]
        result["errors"].each do |error|
          $stderr.puts "#{error['resource']}: #{error['message']}"
        end
        exit
      elsif result["message"]
        $stderr.puts "Problem creating issue:", result["message"]
        exit
      else
        $stdout.puts "Issue ##{result['number']} created."
      end
    end

    break unless Starter::Prompt.confirm("Create another?")

  end
end


def format_issue(issue, format="plain")
  if issue["assignee"]
    login = issue["assignee"]["login"]
  else
    login = nil
  end
  case format
  when "markdown"
    "* #{login || "<unassigned>"} - [#{issue.number}](#{issue.html_url}) - #{issue.title}"
  when "plain"
    "* %-16s - %-4s - %s" % [login, "##{issue.number}", issue.title]
  else
    raise "Unknown format for issue printing: '#{format}'"
  end
end

desc "show GitHub issues. Optional labels= and format="
task "github:issues" => "github_repo" do
  repo = $STARTER[:github_repo]
  options = {}
  require "pp"
  if labels = ENV["labels"] || ENV["label"]
    options[:labels] = labels
  end
  format = ENV["format"] || "plain"

  issues = []
  repo.issues(options).each do |issue|
    issues << format_issue(issue, format)
  end
  if issues.size > 0
    puts
    puts issues
    puts
  end
end

desc "show issues for current milestone on GitHub"
task "github:milestones:current" => "github_repo" do
  repo = $STARTER[:github_repo]
  milestones = repo.milestones
  sorted = milestones.sort_by {|m| m["due_on"] || "0" }
  current = sorted.last

  issues =  repo.issues(:milestone => current.number).select do |issue|
    issue["assignee"]
  end.sort_by do |issue|
    issue["assignee"]["login"]
  end

  issues.each do |issue|
    login = issue["assignee"]["login"]
    puts "* #{login} - [#{issue.number}](#{issue.html_url}) - #{issue.title}"
  end
end


task "github_repo" => %w[ github_settings github_auth ] do
  require 'ghee'

  settings = $STARTER[:settings][:github]
  repo = settings[:repo]
  ghee = Ghee.access_token(settings[:auth])

  repo = ghee.repos(repo[:owner], repo[:name])
  if repo["message"]
    puts repo["message"]
    exit
  else
    $STARTER[:github_repo] = repo
  end

end

task "github_auth" => %w[ github_settings .starter ] do
  require "starter/password"
  require 'ghee'
  settings = $STARTER[:settings][:github]
  if File.exists?(".starter/gh_auth") && auth = File.read(".starter/gh_auth")
    settings[:auth] = auth.chomp
  else
    password = Starter::Password.request("GitHub")
    user = $STARTER[:settings][:github][:user]
    auth = Ghee.create_token(user, password, ["user", "repo"])
    if auth
      settings[:auth] = auth
      Starter::Prompt.confirm("Write auth token to .starter?") do
        File.open(".starter/gh_auth", "w") { |f| f.print(auth) }
      end
    else
      puts "Authentication failure"
      exit
    end
  end
end


task "read_settings" => ".starter" do
  require "yaml"
  begin
    $STARTER[:settings] = YAML.load_file(".starter/settings.yml")
  rescue Errno::ENOENT
    $stderr.puts "You do not appear to have a .starter/settings.yml file."
    if Starter::Prompt.confirm("Create a stubbed settings file?")
      File.open(".starter/settings.yml", "w") do |f|
        settings = {
          :github => {
            :user => "YOURUSERNAME",
            :repo => {:owner => "OWNERNAME", :name => $STARTER[:directory]}
          }
        }
        YAML.dump(settings, f)
        puts "Created .starter/settings.yml. Now go edit it."
      end
    end
    exit
  end
end


task "github_settings" => "read_settings" do
  if $STARTER[:settings][:github] == nil
    $stderr.puts "Looks like your .starter/settings.yml file isn't set up with a github stanza."
    exit
  end
end


