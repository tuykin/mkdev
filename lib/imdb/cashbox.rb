require 'money'

module IMDB
  module Cashbox
    I18n.enforce_available_locales = false

    class Unauthorized < RuntimeError; end

    def cash
      init_money
      @money
    end

    def take(who)
      unless who == 'Bank'
        puts 'Полиция уже едет'
        raise Unauthorized
      end

      puts 'Проведена инкассация'
      reset_cashbox(0)
    end

    def fill(amount)
      init_money
      return @money unless amount > 0
      @money += Money.from_amount(amount)
    end

    private

    def reset_cashbox(amount = 0)
      @money = Money.from_amount(amount)
    end

    def init_money
      @money ||= Money.from_amount(0)
    end
  end
end
