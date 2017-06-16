require 'money'

require 'imdb/cashbox'

module IMDB
  describe Cashbox do
    let(:test_class) { Class.new { include Cashbox } }
    let(:test_obj) { test_class.new }

    describe '#included_modules' do
      subject { test_class.included_modules }
      it { is_expected.to include(IMDB::Cashbox) }
    end

    describe '#cash' do
      subject { test_obj.cash }
      it { is_expected.to be_a(Money).and eq(0) }
    end

    describe '#take' do
      subject { test_obj.take(who) }
      before { test_obj.fill(10) }

      context 'Bank' do
        let(:who) { 'Bank' }
        it do
          expect { subject }.to change { test_obj.cash }
            .from(Money.from_amount(10))
            .to(0)
            .and output("Проведена инкассация\n").to_stdout
        end
      end

      context 'someone else' do
        let(:who) { 'someone else' }
        it { expect { subject }.to raise_error(Cashbox::Unauthorized).and output("Полиция уже едет\n").to_stdout }
      end
    end

    describe '#fill' do
      subject { test_obj.fill(amount) }

      context 'add 0' do
        let(:amount) { 0 }
        it { expect { subject }.to_not change { test_obj.cash } }
      end

      context 'add positive' do
        let(:amount) { 10 }
        it { expect { subject }.to change { test_obj.cash }.from(0).to(Money.from_amount(10)) }
      end

      context 'add negative' do
        let(:amount) { -10 }
        it { expect { subject }.to_not change { test_obj.cash } }
      end
    end

    describe '#reset_cashbox' do

    end
  end
end
