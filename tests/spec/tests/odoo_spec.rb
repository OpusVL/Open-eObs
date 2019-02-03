require "spec_helper"

describe "OpusVL odoo 8.0 Docker image - open-eObs" do
  before(:all) do
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image
  end

  describe user('odoo') do
    it { should exist }
  end

  describe file('/etc/odoo/openerp-server.conf') do
    it { should exist }
  end

  describe file('/usr/bin/openerp-server') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/usr/bin/odoo.py') do
    it { should exist }
    it { should be_executable }
  end

  # describe virtualenv('/opt/nh/venv') do
  #   its(:pip_freeze) { should include('psycopg2' => '2.7.1') }
  # end
end
