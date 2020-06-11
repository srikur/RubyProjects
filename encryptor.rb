require 'csv'

class Encryptor
    $hash = {}
    $ascii = {}
    $sound = Array.new
    $nArray = Array.new
    $yyu = 0
    $Decyyu = 0

  def initialize
    File.open('alphabet.txt') do |fp|
      fp.each do |line|
        key, value = line.chomp.split(";;")
        $hash[key] = value
      end
    end
    File.open('unicode.txt') do |fp|
      fp.each do |line|
        key, value = line.chomp.split(";;")
        $ascii[key] = value
      end
    end
    useSoundData
  end

  def encryptString(string)
    $arrayAfterSub = Array.new
    $stringArray = string.split(//)

    while $yyu < $stringArray.length
      $arrayAfterSub.push($hash[$stringArray[$yyu]].to_i)
      $yyu = $yyu + 1
    end

    $yyu = 0
      while $yyu < $stringArray.length
        $arrayAfterSub[$yyu] = $arrayAfterSub[$yyu] * $sound[0][$yyu].to_i
        $part1 = $sound[0]
        $yyu += 1
      end

    trt = 0
    while trt < $arrayAfterSub.length
      bnm = $arrayAfterSub[trt].to_i + 33
      $nArray.push(bnm.chr)
      trt += 1
    end

    $arrayAfterSub.clear
    $stringArray.clear
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

    trt = 0
    while trt < $DecarrayAfterSub.length
      bnm = $DecarrayAfterSub[trt].to_i - 33
      $DecnArray.push(bnm)
      trt += 1
    end

    trt = 0
    numberArray = data.split('')
    numberArray = numberArray.map { |i| i.to_i }
    while trt < $DecnArray.length
      $DecnArray[trt] = $DecnArray[trt] / numberArray[trt]
      trt += 1
    end

    trt = 0
    while trt < $DecnArray.length
      $DecnArray[trt] =  $hash[$DecnArray[trt].to_s]
      trt += 1
    end

    $DecnArray.clear
    $DecarrayAfterSub.clear
    $DecstringArray.clear

    return $DecnArray
  end

  def useSoundData
    CSV.open('/Users/srikur/Desktop/spectrum.txt', :col_sep=>" ").each do |row|
      strr = row[2].to_s
      new_str = strr.partition('.').last
      newer_str = new_str.split('')
      newer_str = newer_str.map { |i| i.to_i }
      newer_str.each do |google|
        if google.to_i%2 != 0
          newer_str[google] = newer_str[google.to_i - 1]
        end
      end
      $sound.push(new_str)
    end
  end
end

vn = Encryptor.new
puts 'Encrypting'
enn =  vn.encryptString('Hi')
puts 'Answer: '
puts enn
#puts 'Decrypting'
#decc = vn.decryptString('Hi', 682617)
#puts decc