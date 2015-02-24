#
# Cookbook Name:: rails_secrets_databag
# Recipe:: default
#

# Keep the encrypted_data_bag_secret in the snapshot so it can be
# copied over when a new instance boots. This way it only has to
# be done once per environment, instead of on every boot.
if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app, data|
    l = link "/etc/chef/encrypted_data_bag_secret" do
      to "/data/encrypted_data_bag_secret"
    end

    template "/data/#{app}/shared/config/secrets.yml"do
      source 'secrets.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0600
      backup 0
      variables(app: app)
    end
  end
end
