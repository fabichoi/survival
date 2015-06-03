class Command
  def initialize
  end

  def status(date,person)
    puts "Remain day: #{date.get_day}, Remain hour: #{date.get_hour}, Reamin Distance: #{person.get_distance}"
    puts "Stamina: #{person.get_stamina}, Starvation: #{person.get_starvation}"
  end
end

class Date

  private
  attr_reader :day
  attr_reader :hour
  
  def initialize(day, hour)
    @day = day
    @hour = hour
  end

  public
  def get_day
    day
  end
  def get_hour
    hour
  end
  
  def set_day(day)
    @day = day
  end
  def set_hour(hour)
    @hour = hour
  end

  def dec_hour(val)
    if @hour-val < 0
      @day -= 1
      @hour -= val
      @hour += 24
    elsif @hour-val == 0
      @day -= 1
      @hour = 24
    else
      @hour -= val
    end
  end
end

class Thing
  attr_reader :seq, :name, :amount, :desc

  def set_item(seq, name, amount, desc)
    @seq = seq
    @name = name
    @amount = amount
    @desc = desc
  end

  def get_item
    [seq, name, amount, desc]
  end
end

class Person

  private
  attr_reader :stamina
  attr_reader :starvation
  attr_reader :distance
  attr_accessor :items
  
  def initialize(stamina, starvation, distance = 300)
    @stamina = stamina
    @starvation = starvation
    @distance = distance
    @items = []
  end

  public
  def get_stamina
    @stamina
  end

  def get_starvation
    @starvation
  end

  def get_distance
    @distance
  end

  def set_status(stamina, starvation)
    @stamina = stamina
    @starvation = starvation
  end

  def dec_status(stamina, starvation)
    @stamina -= stamina
    @starvation -= starvation
  end

  def dec_distance(val)
    @distance -= val
  end
  
  def inc_status(stamina, starvation)
    @stamina += stamina
    @starvation += starvation
  end

  def set_items(name, amount, desc)
    item = Thing.new
    item.set_item(name,amount,desc)
    @items << item
    #@items.set_item(name, amount, desc)
  end
  
  def get_all_items
    @items
  end
  
end

def roll(value)
  Random.new_seed
  if rand(1..100) <= value
    return true
  else
    return false
  end
end

def find_roll(value)
  Random.new_seed
  if roll(value) == true
    return rand(10)
  end
  return -1
end

remain_date = Date.new(30,24)
main_char = Person.new(100,100)
user_command = Command.new

command = ""
while command != "exit" do

  if(main_char.get_stamina <=0 || main_char.get_starvation <=0)
    puts "You lose this game.."
    break
  end

  user_command.status(remain_date,main_char)
  
  print "input your action: "
  command = gets.chomp

  
  case command
  when "status"
    user_command.status(remain_date,main_char)
  when "rest" # must do capsulizer => user_command.rest
    puts "How much time do you rest"
    rest_time = gets.chomp.to_i
    puts "you gained [#{rest_time*12} Stamina]"
    puts "you consumed [1 hour][5 Starvation]"
    remain_date.dec_hour(rest_time)
    main_char.dec_status(0,5*rest_time)
    main_char.inc_status(12*rest_time,0)
  when "walk" # must do capsulizer => user_command.walk
    remain_date.dec_hour(1)
    main_char.dec_status(20,10)
    main_char.dec_distance(3)
    puts "you consumed [1 hour][20 Stamina][10 Starvation]"
  when "eat" # must do capsulizer => user_command.eat
    puts "you gained [5 Stamina][10 Starvation]"
    remain_date.dec_hour(1)
    main_char.inc_status(5,10)
  when "see" # must do capsulizer => user_command.see
    all_items = main_char.get_all_items
    all_items.each { |x| puts "#{x.name}, #{x.amount}" }
  #when "find" # must do capsulizer => user_command.find
  #when "combine" # must do capsulizer => user_command.combine
  when "--help"
    puts "Command list: status, rest, walk, find, eat, see, --help, exit"
  when "exit"
    break
  else
    puts "Please input again. That action doesn't exist. If you need help, input --help"
  end
end
