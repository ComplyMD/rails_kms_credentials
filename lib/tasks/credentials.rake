namespace :kms_creds do
  task :show, [:environment] do |_, args|
  end

  task :edit, [:environment] do |_, args|
    ENV['EDITOR'] += ' --wait' if ENV['EDITOR'].present? && (ENV['EDITOR'] == 'code' || ENV['EDITOR'].ends_with?('/code')) # Stupid fix for vscode exiting too quickly
  end
end
