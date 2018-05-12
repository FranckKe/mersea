RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    schema_directory = "#{Rails.root}/spec/support/api/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true)
  end
end
