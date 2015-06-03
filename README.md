# BackupRepos

A small Ruby CLI tool for backing up a GitHub organization's repositories.

## Usage

`$ backup_repos -n ${ORGANIZATION_NAME} -t #{GITHUB_ACCESS_TOKEN}`

This will create a tarbar for every repo in the given organization in the local tmp directory. You can then upload these to S3 and you're all backed up.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/backup_repos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
