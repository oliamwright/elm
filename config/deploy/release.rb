namespace :release do
  task :count, :roles => :web do
    run "cd #{deploy_to}/releases && ls -1 | wc -l"
  end

  task :clean, :roles => :web do
    keep = variables[:keep] ? variables[:keep] + 1 : 6
    run "cd #{deploy_to}/releases && for i in `ls -1 | sort -rk1 | tail -n +#{keep}`; do echo sudo rm -rf #{deploy_to}/releases/$i; sudo rm -rf #{deploy_to}/releases/$i; done"
  end
end

#after 'deploy', 'release:clean'

