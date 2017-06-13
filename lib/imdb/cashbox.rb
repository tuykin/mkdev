module IMDB
  module Cashbox
    class NotEnoughMoney < RuntimeError; end
    class Unauthorized < RuntimeError; end

    def cash
      @money
    end

    def take(who)
      if who == 'Bank'
        puts 'Проведена инкассация'
        reset_cashbox(0)
      else
        puts 'Полиция уже едет'
        raise Unauthorized
      end
    end

    private

    def withdraw(amount)
      raise NotEnoughMoney if @money < amount
      @money -= amount
    end

    def fill(amount)
      @money += amount
    end

    def reset_cashbox(amount = 0)
      @money = amount
    end
  end
end
