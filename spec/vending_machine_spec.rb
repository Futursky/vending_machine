require 'vending_machine'

describe VendingMachine do
  # Do not run machine on start
  class VendingMachine
    def initialize; end

    # run machine only once
    def run
      hello
      show_coins_list
      show_products_list
      select_product
      receive_payment
      vend_product
      bye
      #run 
    end
  end

  subject { VendingMachine.new }

  before do
    # remove console output from spec output
    allow($stdout).to receive(:write)
  end

  # spec below is more like integrations rather unit test

  it "should return Fanta and 0.5 coin of change" do
    expect($stdin).to receive(:gets).and_return("2", "2", "")
    expect(subject).to receive(:msg).with(:selected_product, "Fanta")
    expect(subject).to receive(:msg).with(:ask_for_coins)
    expect(subject).to receive(:msg).with(:coin_inserted, 2.0)
    expect(subject).to receive(:msg).with(:take_change, [0.5])
    expect(subject).to receive(:msg).with(:take_product, "Fanta")
    subject.run
  end

  it "should return Sprite and 1, 3 coins of change" do
    expect($stdin).to receive(:gets).and_return("3", "5", "")
    expect(subject).to receive(:msg).with(:selected_product, "Sprite")
    expect(subject).to receive(:msg).with(:ask_for_coins)
    expect(subject).to receive(:msg).with(:coin_inserted, 5.0)
    expect(subject).to receive(:msg).with(:take_change, [1,3])
    expect(subject).to receive(:msg).with(:take_product, "Sprite")
    subject.run
  end

  it "should try to buy Cola but return 1.0 coin because it is not enough" do
    expect($stdin).to receive(:gets).and_return("1", "1", "")
    expect(subject).to receive(:msg).with(:selected_product, "Cola")
    expect(subject).to receive(:msg).with(:ask_for_coins)
    expect(subject).to receive(:msg).with(:coin_inserted, 1.0)
    expect(subject).to receive(:msg).with(:not_enough_coins_to_buy, "1.0")
    subject.run
  end

  it "should try to buy Cola but return 2.0 coins because there is no change" do
    expect($stdin).to receive(:gets).and_return("1", "2", "")
    expect(subject).to receive(:msg).with(:selected_product, "Cola")
    expect(subject).to receive(:msg).with(:ask_for_coins)
    expect(subject).to receive(:msg).with(:coin_inserted, 2.0)
    expect(subject).to receive(:msg).with(:not_enough_coins_for_change, "2.0")
    subject.run
  end

  it "should return Cola without change" do
    expect($stdin).to receive(:gets).and_return("1", "1", "0.25", "")
    expect(subject).to receive(:msg).with(:selected_product, "Cola")
    expect(subject).to receive(:msg).with(:ask_for_coins)
    expect(subject).to receive(:msg).with(:coin_inserted, 1)
    expect(subject).to receive(:msg).with(:coin_inserted, 1.25)
    expect(subject).to receive(:msg).with(:take_change, [])
    expect(subject).to receive(:msg).with(:take_product, "Cola")
    subject.run
  end
end
