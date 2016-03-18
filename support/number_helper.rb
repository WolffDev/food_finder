# This module illustrates how additional functionality can be
# included (or "mixed-in") to a class and then reused.
# Borrows heavily from Ruby on Rails' number_to_currency method.
module NumberHelper
  def number_to_currency(number, options={})
    unit      = options[:unit]      || '$'
    percision = options[:percision] || 2
    delimiter = options[:delimiter] || ','
    separator = options[:separator] || '.'

    separator = '' if percision == 0
    integer, decimal = number.to_s.split('.')

    i = integer.length
    until i <= 3
      i -= 3
      integer = integer.insert(i,delimiter)
    end

    if percision == 0
      precise_decimal = ''
    else
      decimal ||= "0"
      decimal = decimal[0, percision-1]
      precise_decimal = decimal.ljust(percision, "0")
    end

    return unit + integer + separator + precise_decimal
  end

end