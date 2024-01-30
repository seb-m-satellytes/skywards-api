
require 'yaml'

consts_file = Rails.root.join('config', 'consts', 'activities.yml')
CONSTS = YAML.load_file(consts_file).with_indifferent_access if File.exist?(consts_file)
