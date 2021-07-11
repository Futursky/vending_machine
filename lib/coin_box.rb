# frozen_string_literal: true

# Service object to store information and methods related to coins
class CoinBox
  ### Constants
  ALL_COINS = [
    { value: 0.25, quantity: 0 },
    { value: 0.5, quantity: 12 },
    { value: 1, quantity: 3 },
    { value: 2, quantity: 1 },
    { value: 3, quantity: 1 },
    { value: 5, quantity: 2 }
  ].freeze

  ### Public Class Methods
  class << self
    def coins
      @coins ||= ALL_COINS
    end

    def supported_nominals
      ALL_COINS.map { |coin| coin[:value] }.sort
    end

    def payment
      @payment ||= []
    end

    def total
      payment.sum
    end

    def insert_coin(coin)
      return payment << coin if valid_coin?(coin)
      false
    end

    def enough_coins_to_buy?(product)
      enough_coins = total >= product[:price]
      add_payment_to_machine if enough_coins
      enough_coins
    end

    def enough_coins_for_change?(product)
      !!change(product) # rubocop:disable DoubleNegation
    end

    def return_coins_back
      payment.each { |payment_coin| remove_coin_from_machine(payment_coin) }
      clear_transaction_data
    end

    def return_change(product)
      change_coins = change(product)
      change_coins.each { |change_coin| remove_coin_from_machine(change_coin) }
      clear_transaction_data
      change_coins
    end

    ### Private Class Methods
    private

    def change(product)
      @change ||= begin
        change_sum = total - product[:price]
        change_in_coins(change_sum)
      end
    end

    def add_payment_to_machine
      payment.each { |payment_coin| add_coin_to_machine(payment_coin) }
    end

    def add_coin_to_machine(coin)
      find_coin_stack(coin)[:quantity] += 1
    end

    def remove_coin_from_machine(coin)
      find_coin_stack(coin)[:quantity] -= 1
    end

    def find_coin_stack(payment_coin)
      coins.find { |coin| coin[:value] == payment_coin }
    end

    def coins_for_change
      @coins_for_change ||= coins.flat_map { |coin| [coin[:value]] * coin[:quantity] }
    end

    def remove_change_coin(coin)
      @coins_for_change.slice!(coins_for_change.index(coin)) if coins_for_change.index(coin)
    end

    def coin_available?(coin)
      coins_for_change.include?(coin)
    end

    # greedy algorithm implemented here
    # please read more in README.md
    def change_in_coins(change)
      return [] if change.zero?
      supported_nominals.reverse_each do |coin|
        next if (change - coin).negative? || !coin_available?(coin)
        remove_change_coin(coin)
        next unless (sum = change_in_coins(change - coin))
        return sum + [coin]
      end
      nil
    end

    def valid_coin?(coin)
      supported_nominals.include?(coin)
    end

    def clear_transaction_data
      @payment = nil
      @change = nil
      @coins_for_change = nil
    end
  end
end
