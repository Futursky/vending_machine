# frozen_string_literal: true

require_relative 'display'
require_relative 'product_box'
require_relative 'coin_box'
require 'active_support/core_ext/module/delegation'

# Base class for VendingMachine
class VendingMachine
  delegate :coins, :insert_coin, :payment, :total, :return_change, :return_coins_back,
           :enough_coins_to_buy?, :enough_coins_for_change?, to: CoinBox
  delegate :products, :selected_product, :selected_product=, :return_product,
           :available_products, to: ProductBox
  delegate :msg, :product_list, :coins_list, :hello, :bye, to: Display

  ### Public Instance Methods
  def initialize
    run
  end

  def run
    hello
    show_coins_list
    show_products_list
    select_product
    receive_payment
    vend_product
    bye
    run
  end

  # TODO: Just for beta testers and should not be visible for final user.
  def show_coins_list
    coins_list(coins)
  end

  def show_products_list
    product_list(available_products)
  end

  def select_product
    product_position_in_list = STDIN.gets.chomp
    self.selected_product = available_products[product_position_in_list.to_i - 1]
    return msg(:selected_product, selected_product[:name]) if selected_product
    msg(:product_not_available) || select_product
  end

  def receive_payment
    msg(:ask_for_coins)
    coin = STDIN.gets.chomp
    until coin.empty?
      insert_coin(coin.to_f) ? msg(:coin_inserted, total) : msg(:coin_invalid, coin)
      coin = STDIN.gets.chomp
    end
  end

  def vend_product
    return refusal(:not_enough_coins_to_buy) unless enough_coins_to_buy?(selected_product)
    return refusal(:not_enough_coins_for_change) unless enough_coins_for_change?(selected_product)
    msg(:take_change, return_change(selected_product))
    msg(:take_product, return_product)
  end

  def refusal(reason)
    msg(reason, payment.join(', '))
    return_coins_back
  end
end
