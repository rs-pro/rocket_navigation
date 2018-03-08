RSpec::Matchers.define :have_css do |expected, times|
  match do |actual|
    selector = actual.css(expected)
    if times
      expect(selector.size).to eq times
    else
      expect(selector.size).to be >= 1
    end
  end

  failure_message do |actual|
    "expected #{actual.to_s} to have #{times || 1} elements matching '#{expected}'"
  end

  failure_message_when_negated do |actual|
    "expected #{actual.to_s} not to have #{times || 1} elements matching '#{expected}'"
  end
end
