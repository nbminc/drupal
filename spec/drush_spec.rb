# encoding: utf-8
require 'spec_helper'

describe 'drupal::drush' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['drupal'] = {
        'sites' => {
          'example' => {
            'active' => 1,
            'deploy' => {
              'action' => ['deploy']
            }
          }
        }
      }
    end.converge(described_recipe)
  end

  it 'creates the /opt/drush directory' do
    expect(chef_run).to create_directory('/opt/drush').with(
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
  end

  it 'creates the /opt/drush/shared directory' do
    expect(chef_run).to create_directory('/opt/drush/shared').with(
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
  end

  it 'deploys the drush' do
    expect(chef_run).to deploy_deploy('/opt/drush').with(
      repository: 'https://github.com/drush-ops/drush.git',
      revision: '6.2.0',
      keep_releases: 1
    )
  end

  it 'creates a link from /usr/bin/drush to /opt/drush/current/drush' do
    expect(chef_run).to create_link('/usr/bin/drush').with(
      to: '/opt/drush/current/drush',
      link_type: :symbolic
    )
  end
end