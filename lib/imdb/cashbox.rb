require 'money'

module IMDB
  module Cashbox
    I18n.enforce_available_locales = false

    Unauthorized = Class.new(RuntimeError)
    ShouldBePositive = Class.new(ArgumentError)

    def cash
      @money ||= Money.from_amount(0)
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
      raise ShouldBePositive if amount < 0
      @money = cash + Money.from_amount(amount)
    end

    private

    def reset_cashbox(amount = 0)
      @money = Money.from_amount(amount)
    end
  end
end
