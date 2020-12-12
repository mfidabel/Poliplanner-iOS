# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Poliplanner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Poliplanner
  # Linter para analizar el código
  pod 'SwiftLint'
  # Tipeado fuerte de recursos
  pod 'R.swift'
  # Base de datos
  pod 'RealmSwift'
  # Lector de XLSX
  pod 'CoreXLSX', '~> 0.13.0'
  # Paging de las clases
  pod 'Parchment', '~> 3.0'

  target 'PoliplannerTests' do
    inherit! :search_paths
    # Pods for testing
    
  end

  target 'PoliplannerUITests' do
    # Pods for testing
    
  end

  post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Poliplanner/Pods-Poliplanner-acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    fix_deployment_target(installer)
  end
  
end


def fix_deployment_target(installer)
  return if !installer
  project = installer.pods_project
  project_deployment_target = project.build_configurations.first.build_settings['IPHONEOS_DEPLOYMENT_TARGET']

  puts "Cambiando el deployment target de los pods #{project_deployment_target.green}"
  project.targets.each do |target|
    puts "  #{target.name}".blue
    target.build_configurations.each do |config|
      old_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      new_target = project_deployment_target
      next if old_target == new_target
      puts "    #{config.name}: #{old_target.yellow} -> #{new_target.green}"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = new_target
    end
  end
end
