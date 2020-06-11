require 'tk'

class Flashcard
    
    $currentDeck
    
    def initialize
        fgh = proc {createnewdeck}
        rty = proc {loadadeck}
        xcv = proc {studyDeck}
        ph = { 'padx' => 10, 'pady' => 10 }
        $root = TkRoot.new {title "Srikur's Flashcard App"}
        TkLabel.new($root) {text    "Welcome to Srikur's Flashcard App" ; pack(ph) }
        TkButton.new($root) {text 'Create a New Deck'; command fgh; pack ph}
        TkButton.new($root) {text 'Load a Deck'; command rty; pack ph}
        TkButton.new($root) {text 'Study a Deck'; command xcv; pack ph}
    end
    
    def studyDeck
        $studyRoot = TkToplevel.new {title "Studying Deck: #{$currentDeck}"}
        
        $contents = Array.new
        File.open("C:/Users/Srikur/Desktop/#{$currentDeck}.csv", "r") do |vFile|
            $contents = vFile.readlines
        end
        
        $cardList = TkListbox.new($studyRoot) do
            pack('fill' => 'x')
        end
        
        $x = 0
        while $x < $contents.length
            $contents.untaint
            $contents.each do |e|
                (e.to_s).gsub(',', ' => ')
                puts "Character ',' found in the word #{e}" if e.include?(",")
            end
            $cardList.insert(0,$contents[$x].to_s)
            $x += 1
        end
        
        $cardList.place('height' => 150,
                        'width'  => 150,
                        'x'      => 10,
                        'y'      => 10)
                        
                        scroll = TkScrollbar.new($studyRoot) do
                            orient 'vertical'
                            place('height' => 150, 'x' => 160)
                        end
                        
                        $cardList.yscrollcommand(proc { |*args|
                                                 scroll.set(*args)
                                                 })
                                                 
                                                 scroll.command(proc { |*args|
                                                                $cardList.yview(*args)
                                                                })
    end
    
    def createnewdeck
        ph = { 'padx' => 10, 'pady' => 10 }
        lk = proc {newDeckClicked; editCurrentDeck; $cdr.destroy}
        $cdr = TkToplevel.new {title 'Create Deck'}
        $entry = TkEntry.new($cdr) {pack(ph);}
        TkButton.new($cdr) {text 'Create Deck'; command lk; pack ph}
    end
    
    def editCurrentDeck
        ph = { 'padx' => 10, 'pady' => 10 }
        sac = proc {writeCardtoFile(true)}
        sanc = proc {writeCardtoFile(false); $frontCard.value = ''; $backCard.value = ''}
        File.open("C:/Users/Srikur/Desktop/#{$currentDeck}.csv", "r")
        $editDeckRoot = TkToplevel.new {title "Editing deck: '#{$currentDeck}'"}
        TkLabel.new($editDeckRoot) {text 'Front of Card:'; pack(ph)}
        $frontCard = TkEntry.new($editDeckRoot) {pack(ph)}
        TkLabel.new($editDeckRoot) {text 'Back of Card:'; pack(ph)}
        $backCard = TkEntry.new($editDeckRoot) {pack(ph)}
        TkButton.new($editDeckRoot) {text 'Save and Close'; command sac; pack ph}
        TkButton.new($editDeckRoot) {text 'Save, Add new Card'; command sanc; pack ph}
    end
    
    def writeCardtoFile(close)
        File.open("C:/Users/Srikur/Desktop/#{$currentDeck}.csv", "a+") do |mFile|
            mFile << $frontCard.value
            mFile << ","
            mFile << $backCard.value
            mFile << "\n"
            mFile.close
        end
        if (close == true)
            $editDeckRoot.destroy
        end
    end
    
    def newDeckClicked
        print $entry.value
        $currentDeck = $entry.value
        File.open("C:/Users/Srikur/Desktop/#{$entry.value}.csv", "a+") do |aFile|
            aFile.close
        end
    end
    
    def loadadeck
        ph = { 'padx' => 10, 'pady' => 10 }
        $vbn = TkToplevel.new {title 'Load Deck'}
        llb = proc {loadDeck; editCurrentDeck; $vbn.destroy}
        $loadentry = TkEntry.new($vbn) {pack(ph);}
        TkButton.new($vbn) {text 'Load Deck'; command llb; pack ph}
    end
    
    def loadDeck
        if (File.exists?("C:/Users/Srikur/Desktop/#{$loadentry.value}.csv"))
            $currentDeck = $loadentry.value
        end
        if (!File.exists?("C:/Users/Srikur/Desktop/#{$loadentry.value}.csv"))
            msgBox = Tk.messageBox(
                                   'type'    => "ok",
                                   'icon'    => "info",
                                   'title'   => "Error!",
                                   'message' => "File specified does not exist"
                                   )
                                   puts "File #{$loadentry.value} does not exist. You must create it first"
        end
    end
end

$var = Flashcard.new
Tk.mainloop