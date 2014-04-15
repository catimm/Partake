def dep(task, *args)
  Rake::Task[task].invoke(*args)
end

def deploy(app)
  sh 'git subtree split --prefix=web -b temp-split-branch'
  sh "git push -f #{app} temp-split-branch:master"
  sh 'git branch -D temp-split-branch' 
end

task :ensure_git do
  if (`git` rescue nil).nil?
    puts 'git not present.'
    exit!
  end
end

task :ensure_heroku do
  if (`heroku` rescue nil).nil?
    puts 'heroku not present.'
    exit!
  end
end

task :require_remote, [:name, :git_url] => :ensure_git do |t, args|
  unless `git remote` =~ /\b#{args.name}\b/
    sh "git remote add #{args.name} #{args.git_url}"
  end
end

task :require_partake_stage do
  dep :require_remote, 'partake-stage', 'git@heroku.com:partake-stage.git'
end

task :require_partake_prod do
  dep :require_remote, 'partake-prod', 'git@heroku.com:partake-prod.git'
end

desc 'Deploy staging environment (partake-stage)'
task :'stage:deploy' => [:ensure_git, :require_partake_stage] do
  deploy('partake-stage')
end

desc 'Deploy prod environment (partake-prod)'
task :'prod:deploy' => [:ensure_git, :require_partake_prod] do
  deploy('partake-prod')
end


