
def readme_run
  remove_file "README.rdoc"
  create_file "README.md", read_file_and_gsub(__FILE__, "_README.md", {app_name: app_name})
end  