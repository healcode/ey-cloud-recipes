#
# Cookbook Name:: rails_secrets_databag
# Recipe:: default
#

# Keep the encrypted_data_bag_secret in the snapshot so it can be
# copied over when a new instance boots. This way it only has to
# be done once per environment, instead of on every boot.

# NOTE: to encrypt the databag, install the following gems
#   $> gem install chef
#   $> gem install knife-solo_data_bag
#   $> gem install engineyard
#
# Then use knife (https://github.com/thbishop/knife-solo_data_bag):
#   $> knife solo data bag create secrets <databag name> --json-file <location of unencrypted file> --secret-file <location of key>
#
# Then to upload and apply custom recipes to EY, use engineyard gem (https://github.com/engineyard/engineyard):
#   $> ey recipes upload --apply -e <environment> --account <account name>

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
