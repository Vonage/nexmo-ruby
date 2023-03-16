# typed: false
require_relative './test'

class Vonage::Verify2Test < Vonage::Test
  def verify2
    Vonage::Verify2.new(config)
  end

  def request_id
    'c11236f4-00bf-4b89-84ba-88b25df97315'
  end

  def response
    {
      headers: response_headers,
      body: '{"request_id":"c11236f4-00bf-4b89-84ba-88b25df97315"}'
    }
  end

  def uri
    'https://api.nexmo.com/v2/verify/'
  end

  def check_request_uri
    uri + request_id
  end

  def to_number
    '447700900000'
  end

  def test_start_verfication_method
    workflow = [{channel: 'sms', to: to_number}]

    stub_request(:post, uri).with(body: {workflow: workflow}).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verfication(workflow: workflow)
  end

  def test_start_verfication_method_with_opts
    workflow = [{channel: 'sms', to: to_number}]
    params = {workflow: workflow, brand: 'Example Brand'}

    stub_request(:post, uri).with(body: params).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verfication(workflow: workflow, brand: 'Example Brand')
  end

  def test_start_verfication_method_without_workflow
    assert_raises ArgumentError do
      verify2.start_verfication
    end
  end

  def test_start_verfication_method_with_workflow_that_isnt_array
    workflow = {channel: 'sms', to: to_number}

    assert_raises ArgumentError do
      verify2.start_verfication(workflow: workflow)
    end
  end

  def test_start_verfication_method_with_empty_workflow
    assert_raises ArgumentError do
      verify2.start_verfication(workflow: [])
    end
  end

  def test_start_verfication_method_with_multiple_workflows
    workflow = [{channel: 'sms', to: to_number}, {channel: 'voice', to: to_number}]

    stub_request(:post, uri).with(body: {workflow: workflow}).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verfication(workflow: workflow)
  end

  def test_check_code_method
    code = '1234'

    stub_request(:post, check_request_uri).with(body: {code: code}).to_return(status: 200, headers: {})

    assert_kind_of Vonage::Response, verify2.check_code(request_id: request_id, code: code)
  end

  def test_check_code_method_without_request_id
    assert_raises ArgumentError do
      verify2.check_code(code: '1234')
    end
  end

  def test_check_code_method_without_code
    assert_raises ArgumentError do
      verify2.check_code(request_id: request_id)
    end
  end
end
