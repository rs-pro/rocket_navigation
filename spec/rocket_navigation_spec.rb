RSpec.describe RocketNavigation do
  it "has a version number" do
    expect(RocketNavigation::VERSION).not_to be nil
  end

  describe 'Regarding renderers' do
    it 'registers the builtin renderers by default' do
      expect(subject.registered_renderers).not_to be_empty
    end

    describe '.register_renderer' do
      let(:renderer) { double(:renderer) }

      it 'adds the specified renderer to the list of renderers' do
        subject.register_renderer(my_renderer: renderer)
        expect(subject.registered_renderers[:my_renderer]).to be renderer
      end
    end
  end
end
