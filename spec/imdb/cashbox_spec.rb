require 'money'

require 'imdb/cashbox'

module IMDB
  describe Cashbox do
    let(:test_class) { Class.new { include Cashbox } }
    let(:test_obj) { test_class.new }

    before { test_obj.reset_cashbox }

    describe '#included_modules' do
      subject { test_class.included_modules }
      it { is_expected.to include(IMDB::Cashbox) }
    end

    describe '#cash' do
      subject { test_obj.cash }
      let(:amount) { Money.new(0) }
      it { is_expected.to be_a(Money).and eq(amount) }
    end

    describe '#take' do
      subject { test_obj.take(who) }
      before { test_obj.fill(10) }

      context 'Bank' do
        let(:who) { 'Bank' }
        let(:was) { Money.from_amount(10) }
        let(:become) { Money.from_amount(0) }
        it { expect { subject }.to change { test_obj.cash }.from(was).to(become).and output("Проведена инкассация\n").to_stdout }
      end

      context 'someone else' do
        let(:who) { 'someone else' }
        it { expect { subject }.to raise_error(Cashbox::Unauthorized).and output("Полиция уже едет\n").to_stdout }
      end
    end

    # describe 'money' do
    #   it { puts .format }
    # end
  end
end
