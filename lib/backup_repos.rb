require "backup_repos/version"
require 'rest-client'
require 'json'

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
end
