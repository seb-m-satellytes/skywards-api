require 'yaml'

# Directory containing constants files
consts_dir = Rails.root.join('config', 'consts')

# Initialize an empty hash for CONSTS
CONSTS = {}

# Check if the directory exists and load all YAML files from it
if Dir.exist?(consts_dir)
  Dir[consts_dir.join('*.yml')].each do |file_path|
    # Extract the basename without extension to use as the key
    key = File.basename(file_path, '.yml')
    # Load the YAML file and assign its contents to the CONSTS hash
    CONSTS[key] = YAML.load_file(file_path).with_indifferent_access
  end
end
