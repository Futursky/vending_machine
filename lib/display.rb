# frozen_string_literal: true

require_relative 'coin_box'

# Service object for showing messages
class Display
  ### Constants
  DIVIDER_SIZE = 100
  CODE_MSG_MAP = {
    select_product: 'Please, select the product',
    selected_product: 'You selected',
    product_not_available: 'Product with this index does not available, please select another product',
    ask_for_coins: 'Enter a coin and press enter. When finished, hit enter twice. Supported coin nominals ' \
      "are: #{CoinBox.supported_nominals.join(', ')}",
    coin_inserted: 'Coin inserted you total is:',
    coin_invalid: 'This coin nominal does not supported, please take back you',
    not_enough_coins_to_buy: 'Not enough money inserted, please take you coins back:',
    not_enough_coins_for_change: 'Sorry, it is not enough coin to return change, try to insert coins with ' \
      'lesser nominals, please take you coins back:',
    take_product: 'Please take your',
    take_change: 'Please take your change',
    empty_machine: 'Sorry, there are no product for vending now',
    coins_list: 'Available coins',
    divider: '=' * DIVIDER_SIZE
  }.freeze

  ### Public Class Methods
  class << self
    def msg(code, value = nil)
      msg = CODE_MSG_MAP[code].to_s
      msg += " #{value}" if value
      puts(msg)
    end

    def hello
      5.times { puts }
      msg(:divider)
    end

    def bye
      msg(:divider)
      5.times { puts }
    end

    def coins_list(coins)
      msg(:coins_list)
      coins.each do |coin|
        puts "#{coin[:value]} -> #{coin[:quantity]}"
      end
      puts
    end

    def product_list(products)
      return msg(:empty_machine) if products.empty?
      msg(:select_product)
      products.each_with_index do |product, index|
        puts "#{index + 1}) #{product[:name]} : #{product[:price]}$ : #{product[:quantity]}"
      end
      puts
    end
  end
end
