require 'json'

module Chicago
  module Protest
    module Macros
      def asserts_response_status(expected)
        asserts("response status is #{expected}").equals(expected) { last_response.status }
      end
      
      def asserts_content_type(expected)
        asserts("content type is #{expected}").equals(expected) { last_response.headers['Content-type'] }
      end

      def asserts_response_body(expected)
        asserts("response body matches #{expected.inspect}").matches(expected) { last_response.body }
      end

      def asserts_location(expected_path)
        asserts("location matches #{expected_path}").matches(expected_path) do
          last_response.headers["Location"]
        end
      end

      def asserts_json_response(json, &block)
        asserts_content_type 'application/json'
        asserts("response body has JSON").equals(last_response.body) do
          json = json.to_json unless json.instance_of?(String)
          json
        end
      end

      # Usage:
      #   assert_redirected_to '/foo/bar'
      #   assert_redirected_to %r[foo/bar]
      def asserts_redirected_to(expected_path)
        asserts_response_status 302
        asserts_location expected_path
      end
    end # Macros
  end # Protest
end # Chicago

Protest::Context.instance_eval { include Chicago::Protest::Macros }