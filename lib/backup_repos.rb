require "backup_repos/version"
require 'rest-client'
require 'json'
require 'highline/import'

module BackupRepos

  class BackupRepos
    REPOS_TMP_DIR = "/tmp/backup_repos/"

    Struct.new("Repo", :url, :name)

    def run(org_name, access_token)
      @org_name = org_name
      @access_token = access_token

      fetch_repos
      clone_repos
      zip_repos
    end
  
    private
  
    def fetch_repos
      @repos = []
      page = 1
      begin
        loop do
          response = RestClient.get("https://api.github.com/orgs/#{@org_name}/repos?access_token=#{@access_token}&page=#{page}")
          repo_objs = JSON.parse(response)
          repo_objs.each { |repo| @repos.push(Struct::Repo.new(repo['ssh_url'], repo['name'])) }
          page = page + 1
          break if repo_objs.count == 0
        end
      end
    end
  
    def clone_repos
      @repos.each { |repo| `git clone #{repo.url} ./tmp/#{repo.name}` }
    end
  
    def zip_repos
      @repos.each do |repo|
        `tar -czpf ./tmp/#{repo.name}.tar.gz ./tmp/#{repo.name}`
        `rm -rf ./tmp/#{repo.name}`
      end
    end
  end


  class DeleteRepos
    def run(org_name, auth_token, repos)
      repos = repos.split(',')
      repos.each do |repo_name|
        url = "https://api.github.com/repos/#{org_name}/#{repo_name}?access_token=#{auth_token}"

        if (confirm("Delete Repo: #{repo_name}?")) 
          RestClient.delete(url)
        else
          puts "Skipped deleting Repo: #{repo_name}"
        end
      end
    end

    private

    # https://gist.github.com/botimer/2891186
    def confirm(prompt, default = false)
      a = ''
      s = default ? '[Y/n]' : '[y/N]'
      d = default ? 'y' : 'n'
      until %w[y n].include? a
        a = ask("#{prompt} #{s} ") { |q| q.limit = 1; q.case = :downcase }
        a = d if a.length == 0
      end
      a == 'y'
    end
  end
end
