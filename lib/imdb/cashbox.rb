require 'money'

module IMDB
  module Cashbox
    I18n.enforce_available_locales = false

    class NotEnoughMoney < RuntimeError; end
    class Unauthorized < RuntimeError; end

    def cash
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

    # private

    def withdraw(amount)
      amount = Money.from_amount(amount)
      raise NotEnoughMoney if @money < amount
      @money -= amount
    end

    def fill(amount)
      @money += Money.from_amount(amount)
    end

    def reset_cashbox(amount = 0)
      @money = Money.from_amount(amount)
    end
  end
end
