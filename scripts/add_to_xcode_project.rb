#!/usr/bin/env ruby

require 'xcodeproj'

# Get the relative path of the Swift file to be added and its difficulty level
project_name = ARGV[0]
target_name = ARGV[1]
swift_file_name = ARGV[2]
ps_platform = ARGV[3]
difficulty = ARGV[4] || 'Unknown'  # Use 'Unknown' as the default value if difficulty is not provided

# Relative path of the Xcode project file
project_path = "#{project_name}.xcodeproj"

# Open the Xcode project
project = Xcodeproj::Project.open(project_path)

# Find the "AlgorithmTests" target
target = project.targets.find { |t| t.name == target_name }

# If the target is not found, print an error message and exit
if target.nil?
  puts "Target '#{target_name}' not found in the project."
  exit 1
end

# Find the main group
main_group = project.main_group.find_subpath(target_name, true)

# Find the "Problem Solving Platform" group
ps_group = main_group.find_subpath(ps_platform, true)

# Find or create the group based on the difficulty level
if difficulty != 'Unknown'
    difficulty_group = ps_group.find_subpath(difficulty, true)
    file_group = difficulty_group
else
    file_group = ps_group
end

# Add the new file to the file group
file_ref = file_group.new_reference(swift_file_name)
target.add_file_references([file_ref])

# Save the project
project.save