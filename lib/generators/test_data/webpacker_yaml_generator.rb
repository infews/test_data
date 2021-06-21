require "rails/generators"
require_relative "../../test_data/generator_support"

module TestData
  class WebpackerYamlGenerator < Rails::Generators::Base
    AFTER_DEVELOPMENT_WEBPACK_STANZA_REGEX = /^development:/

    def call
      if Configurators::WebpackerYaml.new.verify.looks_good?
        TestData.log.debug "'test_data' section not needed in config/webpacker.yml"
      else
        inject_into_file "config/webpacker.yml", after: AFTER_DEVELOPMENT_WEBPACK_STANZA_REGEX do
          " &development"
        end
        inject_into_file "config/webpacker.yml", before: BEFORE_TEST_STANZA_REGEX do
          <<~YAML

            # Used in conjunction with the test_data gem
            test_data:
              <<: *development
          YAML
        end
      end
    end
  end
end
