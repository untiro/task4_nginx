resource_name :lb
property :role, String, required: true

action :attach do
#  nodes = search(:node, 'role:#{new_resource.role}')
#  puts nodes
  template '/etc/nginx/nginx.conf' do
    source 'nginx.conf.erb'
    owner 'root'
    group 'root'
    mode '0755'
  end

  directory '/etc/nginx/proxy' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
  
  search(:node, "role:#{new_resource.role}").each do |node|
    file "/etc/nginx/proxy/#{node['network']['interfaces']['enp0s8']['routes'][0]['src']}.conf" do
      content "server #{node['network']['interfaces']['enp0s8']['routes'][0]['src']};"
      action :create
    end
  end

  service 'nginx' do
    action :restart  
  end

end

action :detach do
  search(:node, "role:#{new_resource.role}").each do |node|
    file "/etc/nginx/proxy/#{node['network']['interfaces']['enp0s8']['routes'][0]['src']}.conf" do
      action :delete
    end
  end

  service 'nginx' do
    action :restart  
  end
end

