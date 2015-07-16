# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Not sure if evaluation uses this so leaving commented out
# guard 'rspec' do
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
#   watch('spec/spec_helper.rb')  { "spec" }
# end

guard 'rake', :task => 'test' do
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('test/test_helper.rb')  { "test" }
end
