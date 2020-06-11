require 'tk'
require 'csv'

class SrikurConvert

  #Class and Global Variables
  @@zxc = 0
  $numbers = Array.new
  $ascii = {}
  $hash = {}
  $yyu = 0
  $Decyyu = 0
  $nArray = Array.new
  $wm = 0
  $wordNum = 1

  def initialize
    $GeneratorVariable = Generator.new
    File.open('ascii.txt') do |fp|
      fp.each do |line|
        key, value = line.chomp.split(";;")
        $ascii[key] = value
      end
    end
  end

  def initiate(string)
    $lengthOfString = string.length
    puts $lengthOfString
    puts "\n"
    while @@zxc < string.length
      $sound[@@zxc].gsub!('0', '3')
      @@zxc += 1
    end
    puts "\n"
  end

  def convertToLetter(inm)
    File.open('alphabet.txt') do |fp|
      fp.each do |line|
        key, value = line.chomp.split(";;")
        $hash[key] = value
      end
    end
  end

  def fixInteger(integer)
    _str = integer.to_s
    _arr = integer.split ""
    if _arr.length == 10
      _arr.reverse.drop(1).reverse
    end
    return _arr.to_s.to_i
  end

  def putToFileFormat(data)
    qwqw = 0
    lklk = 0
    File.open("/Users/srikur/Desktop/file.srikur", "a+") do |mFile|
      while lklk < $wordNum
        while qwqw < $lengthOfString
          mFile << $numbers[lklk][qwqw]
          qwqw += 1
        end
        lklk += 1
      end
      data.each { |element| mFile << element }
    end
  end

  def encryptString(string)
    print "Encrypting String: #{string}"
    print 'Numbers Array: '
    #puts $numbers
    puts "\n"
    puts "\n"
    puts $sound[$wm][$yyu]
    $arrayAfterSub = Array.new
    $stringArray = string.split(//)
    #puts $stringArray.length
    #puts "\n"
    while $yyu < $stringArray.length
      $arrayAfterSub.push($hash[$stringArray[$yyu]].to_i)
      puts "Hash value while encrypting: #{$hash[$stringArray[$yyu]]}"
      $yyu = $yyu + 1
    end
    #puts _arrayAfterSub
    #puts "\n"
    $yyu = 0
    while $wm < $wordNum
      while $yyu < $stringArray.length
        $arrayAfterSub[$yyu] = $arrayAfterSub[$yyu] * $sound[$wm][$yyu].to_i
        $part1 = $sound[$wm]
        $yyu += 1
      end
      $wm += 1
    end
    #puts _arrayAfterSub

    trt = 0
    while trt < $arrayAfterSub.length
      bnm = $arrayAfterSub[trt].to_i + 33
      $nArray.push(bnm.chr)
      trt += 1
    end

    #puts "\n"
    puts $nArray
    $arrayAfterSub.clear
    $stringArray.clear
    $yyu2 = $yyu
    $wm2 = $wm
    $wm = 0
    $yyu = 0
    return $nArray
  end

  def decryptString(data, number)
    $DecnArray = Array.new
    $DecarrayAfterSub = Array.new
    $DecstringArray = data.split('')

    while $Decyyu < $DecstringArray.length
      $DecarrayAfterSub.push($ascii[$DecstringArray[$Decyyu]].to_i)
      $Decyyu = $Decyyu + 1
    end
    puts "$DecarrayAfterSub = #{$DecarrayAfterSub}"

    trt = 0
    while trt < $DecarrayAfterSub.length
      bnm = $DecarrayAfterSub[trt].to_i - 33
      $DecnArray.push(bnm)
      trt += 1
    end
    puts "$DecnArray = #{$DecnArray}"

    trt = 0
    numberArray = number.split('')
    numberArray = numberArray.map { |i| i.to_i }
    while trt < $DecnArray.length
      $DecnArray[trt] = $DecnArray[trt] / numberArray[trt]
      trt += 1
    end
    puts "New version of $DecnArray = #{$DecnArray}"

    trt = 0
    puts "Length of $DecnArray = #{$DecnArray.length}"
    puts "First Element of $DecnArray = #{$DecnArray[0]}"
    while trt < $DecnArray.length
      $DecnArray[trt] =  $hash[$DecnArray[trt].to_s]
      puts "hash value: #{$hash[$DecnArray[trt].to_s]}"
      trt += 1
    end
    puts "Even newer version of $DecnArray = #{$DecnArray}"



    $DecnArray.clear
    $DecarrayAfterSub.clear
    $DecstringArray.clear
    $yyu2 = 0
    return $DecnArray

  end
end

class Generator
  $Mersenne = Array.new(624)
  $p = 0
  $init = false
  @@a = 1
  $lll = 0
  $iii = 0
  $sound = Array.new

  def initialize
    initialize_generator(useSoundData)
  end

  def useSoundData
      CSV.open('/Users/srikur/Desktop/spectrum.txt', :col_sep=>" ").each do |row|
          strr = row[2].to_s
          new_str = strr.partition('.').last
          $sound.push(new_str)
      end
      puts $sound
    $iii += 1
    return $sound[$iii - 1].to_i
  end

  def initialize_generator(seed)
    $Mersenne[0] = seed & 0xFFFFFFFF
    _i = 1;
    while _i < 624
      $Mersenne[_i] = 1812433253 * ($Mersenne[_i - 1] ^ ($Mersenne[_i - 1] >> 30)) + _i
      $Mersenne[_i] &= 0xFFFFFFFF
      _i += 1
    end
  end

  def gen_int32
    initialize_generator(useSoundData)
    if $p == 624
      gen_state
    end
    _m = $p += 1
    x = $Mersenne[_m]
    x ^= (x >> 11)
    x ^= (x << 7) & 0x9D2C5680
    x ^= (x << 15) & 0xEFC60000
    return x ^ (x >> 18)
  end

  def gen_HalfOpen
    @@l = 4294967296.
        return gen_int32 * (1. / @@l)
  end

  def gen_Closed
    @@l = 4294967295
    return gen_int32 * (1 * @@l)
  end

  def gen_Open
    @@l = 4294967296
    return (gen_int32 + 0.5) * (1 * @@l)
  end

  def gen_state
    @@i = 0
    while @@i < 624-397
      $Mersenne[@@i] = $Mersenne[@@i + 397] ^ twiddle($Mersenne[@@i], $Mersenne[@@i + 1])
      @@i += 1
    end
    @@i = 624-397
    while i < 623
      $Mersenne[@@i] = $Mersenne[@@i + 397 - 624] ^ twiddle($Mersenne[@@i], $Mersenne[@@i + 1])
      @@i += 1
    end
    $Mersenne[623] = $Mersenne[396] ^ twiddle($Mersenne[623], $Mersenne[0])
    $p = 0
  end

  def twiddle(mT2, mT3)
    return ((mT2 & 0x80000000) | (mT3 & 0x7FFFFFFF)) >> 1 ^ ((mT3 & 1) * 0x9908B0DF)
  end
end

class SrikurGUI
  def initialize
    ph = { 'padx' => 10, 'pady' => 10 }
    $var = SrikurConvert.new
    p = proc { doStuff }
    ddd = proc { doStuff2 }
    $root = TkRoot.new {title 'Srikur File Format'}
    TkLabel.new($root) {text    'Enter a String to Encrypt' ; pack(ph) }
    $input = TkEntry.new($root) {pack(ph)}
    TkButton.new($root) {text 'Encrypt'; command p; pack ph}
    TkButton.new($root) {text 'Decrypt'; command ddd; pack(ph)}
    $output = TkLabel.new($root) {text    'Output: ' ; pack(ph) }
    TkButton.new($root) {text 'Exit'; command {proc exit}; pack ph}
  end

  def doStuff3
    $var.initiate($input2.value);
    $var.convertToLetter(1);
    $rty2 = $var.decryptString($input2.value, $input3.value);
    _mmmm = $rty2.join('')
    $output2.text = "Output: #{_mmmm}"
    $input.value = "#{_mmmm}"
  end

  def doStuff2
    ph = { 'padx' => 10, 'pady' => 10 }
    ddd = proc {doStuff3}
    $top = TkToplevel.new {title 'Decrypt a SrikurString'}
    $stringInput = TkLabel.new($top) {text    'String: ' ; pack(ph) }
    $input2 = TkEntry.new($top) {pack(ph)}
    $stringInput = TkLabel.new($top) {text    'Number: ' ; pack(ph) }
    $input3 = TkEntry.new($top) {pack(ph)}
    TkButton.new($top) {text 'Decrypt'; command ddd; pack(ph)}
    $output2 = TkLabel.new($top) {text    'Output: ' ; pack(ph) }
    TkButton.new($top) {text 'Exit'; command {proc exit}; pack ph}
  end

  def doStuff
    $var.initiate($input.value);
    $var.convertToLetter(1);
    $rty = $var.encryptString($input.value);
    _mmmm = $rty.join('')
    $output.text = "Output: #{$part1},#{_mmmm}"
    $nArray.clear
  end
end


#$vn = Generator.new
#$vn.useSoundData
# $vn.initiate('Pokemon')
# $vn.convertToLetter(1)
# cv = $vn.encryptString('Pokemon')
# $vn.putToFileFormat(cv)

$vbnvb = SrikurGUI.new
Tk.mainloop
