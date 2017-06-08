require 'theatre'
require 'movie'

RSpec.describe Theatre do
  let(:theatre) { Theatre.new('movies.txt') }

  describe '#initialize' do
    subject { theatre.all }

    it { is_expected.to have_attributes(count: 250) }
  end

  describe '#show' do
    before { allow(STDOUT).to receive(:puts) }
    subject { theatre.show(time) }

    context 'morning' do
      let(:time) { '8:00' }
      it { is_expected.to have_attributes(period: :ancient)}
    end

    context 'afternoon' do
      let(:time) { '12:00' }
      it { is_expected.to have_attributes(genres: include('Comedy'))
                      .or have_attributes(genres: include('Adventure')) }
    end

    context 'evening' do
      let(:time) { '18:00' }
      it { is_expected.to have_attributes(genres: include('Drama'))
                      .or have_attributes(genres: include('Horror')) } # not reliable
    end

    context 'night' do
      let(:time) { '3:00' }
      it { is_expected.to be_nil}
    end
  end

  describe '#when?' do
    subject { theatre.when?(title) }

    context 'never' do
      let(:title) { 'The Terminator' }
      it { is_expected.to match_array([:never]) }
    end

    context 'morning' do
      let(:title) { 'M' }
      it { is_expected.to match_array([:morning]) }
    end
  end
end