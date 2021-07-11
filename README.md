Vending Machine
==========

###Specification

Design a vending machine in code. 
The vending machine, once a product is selected and the appropriate amount of money (coins) is inserted, should return that product. It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough (change should be printed as coin * count and as minimum coins as possible).
Keep in mind that you need to manage the scenario where the item is out of stock or the machine does not have enough change to return to the customer.
Available coins: 0.25, 0.5, 1, 2, 3, 5

###How to set it up

```sh
git clone https://github.com/Futursky/vending_machine
cd vending_machine
rvm use
bundle install
```

###How to run it

```sh
ruby -r "./lib/vending_machine.rb" -e "VendingMachine.new"
```

###How to test it

```sh
rspec
```

###Future Improvements

+ Add more Unit test and reach 100% coverage (now 94.55%)
+ Replace Hash objects with Struct
+ Use gem `tty-prompt` and `tty-table` instead of `puts` and `gets.chomp`
+ Replace greedy change algorithm with dynamic programming memoization algorithm
+ Implement [Strategy](https://refactoring.guru/design-patterns/strategy) pattern, it will allow to separate Machine code and algorithm implementation. It should be easy to change algorithm as `VendingMachine.new(algorithm: GreedyAlgorithm).run`

###Algorithm explanation

I use **greedy** algorithm with recursion, it always pick coin with the largest nominal. Algorithm is working fine for my case but it is not optimal in general and may not return change if it is available in Machine. 
For example for coins {1, 5, 10, 15, 17, 20} and change sum of 34 **greedy** algorithm will return 6 coins [20,10,1,1,1,1] but **dynamic programming** algorithm will return only 2 coin [17,17].

**greedy**:
```ruby
ALLOWED_NUMBERS = [1, 5, 10, 15, 17, 20].sort.freeze
def min_coins_change(change)
  return [] if change == 0
  ALLOWED_NUMBERS.reverse_each do |coin|
    next if change - coin < 0
    next unless (sum = min_coins_change(change - coin))
    return sum + [coin]
  end
  nil
end

min_coins_change(34).size
=> 6
```

**dynamic programming**:
```ruby
ALLOWED_NUMBERS = [1, 5, 10, 15, 17, 20].sort.freeze
def min_coins_change(values, change)
  min_coins = change;
  return 1 if (values.include?(min_coins))
  for value in values.find_all { |v| v <= change }
    num_coins = 1 + min_coins_change(values, change - value);
    min_coins = num_coins if (num_coins < min_coins)
  end
  return min_coins;
end

min_coins_change(ALLOWED_NUMBERS, 34)
=> 2
```

###More about coins change algorithms

[link1](http://csharpbook.sakutin.ru/%D0%B2%D0%BE%D0%B7%D0%BC%D0%BE%D0%B6%D0%BD%D0%BE%D0%B5-%D1%80%D0%B5%D1%88%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B0%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC-%D0%B2%D1%8B%D0%B4%D0%B0%D1%87%D0%B8-%D1%81%D0%B4/)
[link2](http://www.edevyatkin.com/problems/2015/10/21/making-change.html)
[link3](http://aliev.me/runestone/Recursion/DynamicProgramming.html)



