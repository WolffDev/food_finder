require 'restaurant'
class Guide
  class Config
    @@actions = ['list','find','add','quit']
    def self.actions; @@actions; end
  end

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file."
    # or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant file"
    else # exit if create fails
      puts "Exiting.\n\n"
      exit!
    end

  end

  def launch!
    introduction
    # action loop
    result = nil
    until result == :quit
      #   what do you want do to? (list, find, add, quit)
      action = get_action
      #   do that action
      result = do_action(action)
    end

    conclusion

  end

  def get_action
    action = nil
    # Keeps asking for user input until we get a valid action
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    return action
  end

  def do_action(action)
    case action
    when 'list'
      list
    when 'find'
      puts "Finding..."
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command\n"
    end
  end

  def list
    output_action_header("Listing restaurants")
    restaurants = Restaurant.saved_restaurants
    output_restaurant_table(restaurants=[])
    end
  end

  def add
    puts "\nAdd a restaurant\n\n".upcase
    
    restaurant = Restaurant.build_using_questions

    if restaurant.save
      puts "\nRestaurant added\n\n"
    else
      puts "\nSave error: Restaurant not added\n\n"
    end
  end

  def introduction
    puts "\n\n<<<< Welcome to the Food Finder >>>>\n\nThis is a guide to finding food that you crave!"
  end

  def conclusion
    puts "\n<<<< Goodbye and Bon Appetit! >>>>\n\n\n"
  end

  private

  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6)
    puts "-" * 60
    restaurant.each do |rest|
      line = " " << rest.name.ljust(30)
      line << " " + rest.cuisine.ljust(20)
      line << " " + rest.formatted_price.ljust(6)
      puts line
    end
    puts "No listings found" if restaurants.empty?
    puts "-" * 60
  end

end