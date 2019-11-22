//
//  GuessView.swift
//  PokeGuessr
//
//  Created by Dylan Telson & Paul Maino on 11/2/19.
//  Copyright © 2019 Dylan Telson & Paul Maino. All rights reserved.
//

/* TODO LIST:
 2) Make prompt into sentence, add text around it "This (height) Pokemon is of type (type) and has (move) and (ability)" something like that
 3) Change image to a ?, have it change to loaded image when the correct answer is inputted
 4) Add score and make it save (UserDefaults.standard), maybe add reroll button that counts as loss
 5) Add account creation, login, and database for leaderboard using Firebase
 6) Fix constraints
 7) Add loading screen or something of the like?
 8) Change design of app (colors fonts etc)
 9) Change views so they don't do that weird thing where you swipe them down to go to previous view
 10) Idea, do generation as a lower difficulty? We'd have to just map out the ranges of which pokemon # is in what gen.
*/

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth

//API FROM: https://pokeapi.co/


//Array indexes extension taken from https://stackoverflow.com/questions/45933149/swift-how-to-get-indexes-of-filtered-items-of-array
//This filters the array and returns the indexes at which the given element can be found
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}

//Pokemon struct that has all the information we currently need
struct Pokemon: Codable {
    let name : String
    let height : Int
    let abilities : [Abilities]
    let moves: [Moves]
    let types: [Types]
    let sprites : Sprites
}

//The following structs are also used because the API uses dictionaries inside of arrays/dictionaries
struct Moves: Codable {
    let move: Name
}

struct Name: Codable {
    let name: String
}

struct Types: Codable {
    let type: Name
}

struct Abilities : Codable {
    let ability: Name
}

struct Sprites : Codable {
    let frontDefault: String
}

//Custom ViewController code for the guessing game view
class GuessView: UIViewController {
    
    //this struct is just a list of all pokemon names. Honestly it's only in a struct instead of just being a variable because you can collapse anything in {} using CMD+ALT+leftarrow and it's a massive list, so it's neater this way.
    //this list was taken from https://gist.github.com/azai91/31e3b31cbd3992a1cc679017f850a022 then adapted into all lowercase and put into a list of strings format
    struct PokeNames {
        static var pokeNames = ["bulbasaur","ivysaur","venusaur","charmander","charmeleon","charizard","squirtle","wartortle","blastoise","caterpie","metapod","butterfree","weedle","kakuna","beedrill","pidgey","pidgeotto","pidgeot","rattata","raticate","spearow","fearow","ekans","arbok","pikachu","raichu","sandshrew","sandslash","nidoran♀","nidorina","nidoqueen","nidoran♂","nidorino","nidoking","clefairy","clefable","vulpix","ninetales","jigglypuff","wigglytuff","zubat","golbat","oddish","gloom","vileplume","paras","parasect","venonat","venomoth","diglett","dugtrio","meowth","persian","psyduck","golduck","mankey","primeape","growlithe","arcanine","poliwag","poliwhirl","poliwrath","abra","kadabra","alakazam","machop","machoke","machamp","bellsprout","weepinbell","victreebel","tentacool","tentacruel","geodude","graveler","golem","ponyta","rapidash","slowpoke","slowbro","magnemite","magneton","farfetchd","doduo","dodrio","seel","dewgong","grimer","muk","shellder","cloyster","gastly","haunter","gengar","onix","drowzee","hypno","krabby","kingler","voltorb","electrode","exeggcute","cubone","marowak","hitmonlee","hitmonchan","lickitung","koffing","weezing","rhyhorn","rhydon","chansey","tangela","kangaskhan","horsea","seadra","goldeen","seaking","staryu","starmie","scyther","jynx","electabuzz","magmar","pinsir","tauros","magikarp","gyarados","lapras","ditto","eevee","vaporeon","jolteon","flareon","porygon","omanyte","omastar","kabuto","kabutops","aerodactyl","snorlax","articuno","zapdos","moltres","dratini","dragonair","dragonite","mewtwo","mew","chikorita","bayleef","meganium","cyndaquil","quilava","typhlosion","totodile","croconaw","feraligatr","sentret","furret","hoothoot","noctowl","ledyba","ledian","spinarak","ariados","crobat","chinchou","lanturn","pichu","cleffa","igglybuff","togepi","togetic","natu","xatu","mareep","flaaffy","ampharos","bellossom","marill","azumarill","sudowoodo","politoed","hoppip","skiploom","jumpluff","aipom","sunkern","sunflora","yanma","wooper","quagsire","espeon","umbreon","murkrow","slowking","misdreavus","unown","wobbuffet","girafarig","pineco","forretress","dunsparce","gligar","steelix","snubbull","granbull","qwilfish","scizor","shuckle","heracross","sneasel","teddiursa","ursaring","slugma","magcargo","swinub","piloswine","corsola","remoraid","octillery","delibird","mantine","skarmory","houndour","houndoom","kingdra","phanpy","donphan","porygon2","stantler","smeargle","tyrogue","hitmontop","smoochum","elekid","magby","miltank","blissey","raikou","entei","suicune","larvitar","pupitar","tyranitar","lugia","ho-oh","celebi","treecko","grovyle","sceptile","torchic","combusken","blaziken","mudkip","marshtomp","swampert","poochyena","mightyena","zigzagoon","linoone","wurmple","silcoon","beautifly","cascoon","dustox","lotad","lombre","ludicolo","seedot","nuzleaf","shiftry","taillow","swellow","wingull","pelipper","ralts","kirlia","gardevoir","surskit","masquerain","shroomish","breloom","slakoth","vigoroth","slaking","nincada","ninjask","shedinja","whismur","loudred","exploud","makuhita","hariyama","azurill","nosepass","skitty","delcatty","sableye","mawile","aron","lairon","aggron","meditite","medicham","electrike","manectric","plusle","minun","volbeat","illumise","roselia","gulpin","swalot","carvanha","sharpedo","wailmer","wailord","numel","camerupt","torkoal","spoink","grumpig","spinda","trapinch","vibrava","flygon","cacnea","cacturne","swablu","altaria","zangoose","seviper","lunatone","solrock","barboach","whiscash","corphish","crawdaunt","baltoy","claydol","lileep","cradily","anorith","armaldo","feebas","milotic","castform","kecleon","shuppet","banette","duskull","dusclops","tropius","chimecho","absol","wynaut","snorunt","glalie","spheal","sealeo","walrein","clamperl","huntail","gorebyss","relicanth","luvdisc","bagon","shelgon","salamence","beldum","metang","metagross","regirock","regice","registeel","latias","latios","kyogre","groudon","rayquaza","jirachi","deoxys","turtwig","grotle","torterra","chimchar","monferno","infernape","piplup","prinplup","empoleon","starly","staravia","staraptor","bidoof","bibarel","kricketot","kricketune","shinx","luxio","luxray","budew","roserade","cranidos","rampardos","shieldon","bastiodon","burmy","mothim","combee","vespiquen","pachirisu","buizel","floatzel","cherubi","cherrim","shellos","gastrodon","ambipom","drifloon","drifblim","buneary","lopunny","mismagius","honchkrow","glameow","purugly","chingling","stunky","skuntank","bronzor","bronzong","bonsly","happiny","chatot","spiritomb","gible","gabite","garchomp","munchlax","riolu","lucario","hippopotas","hippowdon","skorupi","drapion","croagunk","toxicroak","carnivine","finneon","lumineon","mantyke","snover","abomasnow","weavile","magnezone","lickilicky","rhyperior","tangrowth","electivire","magmortar","togekiss","yanmega","leafeon","glaceon","gliscor","mamoswine","porygon-z","gallade","probopass","dusknoir","froslass","rotom","uxie","mesprit","azelf","dialga","palkia","heatran","regigigas","giratina","cresselia","phione","manaphy","darkrai","shaymin","arceus","victini","snivy","servine","serperior","tepig","pignite","emboar","oshawott","dewott","samurott","patrat","watchog","lillipup","herdier","stoutland","purrloin","liepard","pansage","simisage","pansear","simisear","panpour","simipour","munna","musharna","pidove","tranquill","unfezant","blitzle","zebstrika","roggenrola","boldore","gigalith","woobat","swoobat","drilbur","excadrill","audino","timburr","gurdurr","conkeldurr","tympole","palpitoad","seismitoad","throh","sawk","sewaddle","swadloon","leavanny","venipede","whirlipede","scolipede","cottonee","whimsicott","petilil","lilligant","sandile","krokorok","krookodile","darumaka","darmanitan","maractus","dwebble","crustle","scraggy","scrafty","sigilyph","yamask","cofagrigus","tirtouga","carracosta","archen","archeops","trubbish","garbodor","zorua","zoroark","minccino","cinccino","gothita","gothorita","gothitelle","solosis","duosion","reuniclus","ducklett","swanna","vanillite","vanillish","vanilluxe","deerling","sawsbuck","emolga","karrablast","escavalier","foongus","amoonguss","frillish","jellicent","alomomola","joltik","galvantula","ferroseed","ferrothorn","klink","klang","klinklang","tynamo","eelektrik","eelektross","elgyem","beheeyem","litwick","lampent","chandelure","axew","fraxure","haxorus","cubchoo","beartic","cryogonal","shelmet","accelgor","stunfisk","mienfoo","mienshao","druddigon","golett","golurk","pawniard","bisharp","bouffalant","rufflet","braviary","vullaby","mandibuzz","heatmor","durant","deino","zweilous","hydreigon","larvesta","volcarona","cobalion","terrakion","virizion","reshiram","zekrom","landorus","kyurem","keldeo","meloetta","genesect","chespin","quilladin","chesnaught","fennekin","braixen","delphox","froakie","frogadier","greninja","bunnelby","diggersby","fletchling","fletchinder","talonflame","scatterbug","spewpa","vivillon","litleo","pyroar","flabébé","floette","florges","skiddo","gogoat","pancham","pangoro","furfrou","espurr","meowstic","honedge","doublade","aegislash","spritzee","aromatisse","swirlix","slurpuff","inkay","malamar","binacle","barbaracle","skrelp","dragalge","clauncher","clawitzer","helioptile","heliolisk","tyrunt","tyrantrum","amaura","aurorus","sylveon","hawlucha","dedenne","carbink","goomy","sliggoo","goodra","klefki","phantump","trevenant","bergmite","avalugg","noibat","noivern","xerneas","yveltal","zygarde","diancie","hoopa","volcanion","rowlet","dartrix","decidueye","litten","torracat","incineroar","popplio","brionne","primarina","pikipek","trumbeak","toucannon","yungoos","gumshoos","grubbin","charjabug","vikavolt","crabrawler","crabominable","oricorio","cutiefly","ribombee","rockruff","lycanroc","wishiwashi","mareanie","toxapex","mudbray","mudsdale","dewpider","araquanid","fomantis","lurantis","morelull","shiinotic","salandit","salazzle","stufful","bewear","bounsweet","steenee","tsareena","comfey","oranguru","passimian","wimpod","golisopod","sandygast","palossand","pyukumuku","silvally","komala","turtonator","togedemaru","mimikyu","bruxish","drampa","dhelmise","jangmo-o","hakamo-o","kommo-o","cosmog","cosmoem","solgaleo","lunala","nihilego","buzzwole","pheromosa","xurkitree","celesteela","kartana","guzzlord","necrozma","magearna","marshadow"]
    
    }
    
    
    var randomLetters : [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    var lettersToClick = [UIButton]()
    var lettersToClickFrame = [UIButton]()
    var userInput = [String]()
    var userInputButtonFrames = [UIButton]()
    
    var isChecked = false
    
    //current pokemon that the user must guess
    var currPokemon : Pokemon?
    var currGen = 0
    
    //Score to add to the user's total score, per Pokemon, that will be decremented over time
    var scoreToAdd = 1000
    var timer = Timer()
    
    //IBOutlets that are connected to the Storyboard
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var moveLabel : UILabel!
    @IBOutlet var abilityLabel : UILabel!
    @IBOutlet var heightLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var PokeImage: UIImageView!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var checkButton : UIButton!
    
    @IBOutlet var backButton : UIButton!
    
    var imageToShow = UIImage()
    
    var ref : DatabaseReference!
    var name = "name"
    
    @IBAction func BackButtonClicked(_sender: UIButton) {
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users").child(userID).updateChildValues(["score": UserDefaults.standard.integer(forKey: "UserScore")])
    }
    
    //Whenever the bottom button is pressed, this function is run. Sender is the button clicked.
    @IBAction func ButtonClicked(_ sender: UIButton) {
        if(!isChecked) {
            if(userInput.joined(separator: "") == currPokemon!.name) {
                print("Correct!")
                isChecked = true
                checkButton.setTitle("Next", for: .normal)
                self.nameLabel.text = self.currPokemon!.name
                self.nameLabel.text = self.nameLabel.text?.capitalized
                self.nameLabel.sizeToFit()
                self.nameLabel.center.x = self.view.center.x
                self.PokeImage.image = imageToShow
                
                //score updating
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "UserScore") + scoreToAdd, forKey: "UserScore")
                scoreLabel.text = "Score: " + String(UserDefaults.standard.integer(forKey: "UserScore"))
            } else {
                print("Incorrect!")
            }
        } else {
            isChecked = false
            newPokemon()
        }
    }
    
    //Modified to fit into this app's functionality from https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.imageToShow = image
                    }
                }
            }
        }
    }
    
    func setupGame() {
        let yAxisScale = checkButton.frame.origin.y
        
        scoreLabel.text = "Score: " + String(UserDefaults.standard.integer(forKey: "UserScore"))
        for n in 0 ..< 16 {
            var xToSet = 0
            var yToSet = 0
            if(n == 0) {
                xToSet = 50
                yToSet = Int(yAxisScale-125)
            } else if(n < 8) {
                xToSet = Int(lettersToClick[n-1].frame.origin.x) + 40
                yToSet = Int(yAxisScale-125)
            } else if(n == 8) {
                xToSet = 50
                yToSet = Int(yAxisScale-75)
            } else {
                xToSet = Int(lettersToClick[n-1].frame.origin.x) + 40
                yToSet = Int(yAxisScale-75)
            }
            lettersToClick.append(UIButton(frame: CGRect(x: xToSet, y: yToSet, width: 32, height: 32)))
            lettersToClickFrame.append(UIButton(frame: CGRect(x: xToSet, y: yToSet, width: 32, height: 32)))
            //lettersToClick.last!.frame = CGRect(x: lettersToClick.last!.frame.origin.x, y: lettersToClick.last!.frame.origin.y, width: lettersToClick.last!.titleLabel!.intrinsicContentSize.width + 16, height: lettersToClick.last!.titleLabel!.intrinsicContentSize.height + 8)
            //            wordsToClick.last!.backgroundColor = UIColor(red: 1, green: 0.478, blue: 0.478, alpha: 1)
            lettersToClick.last!.backgroundColor = UIColor.white
            lettersToClick.last!.layer.borderWidth = 1.0
            lettersToClick.last!.layer.borderColor = UIColor.lightGray.cgColor
            lettersToClick.last!.layer.cornerRadius = lettersToClick.last!.frame.height/3
            lettersToClick.last!.layer.shadowColor = UIColor.darkGray.cgColor
            lettersToClick.last!.layer.shadowRadius = 1
            lettersToClick.last!.layer.shadowOpacity = 0.5
            lettersToClick.last!.layer.shadowOffset = CGSize(width: 0, height: 0)
            lettersToClick.last!.titleLabel!.textAlignment = .center
            lettersToClick.last!.tag = n
            lettersToClick.last!.addTarget(self, action: #selector(letterButtonClicked), for: .touchUpInside)
            //wordsToClick.last!.titleLabel!.font = UIFont(name: "Helvetica", size: 19.0)
            lettersToClick.last!.setTitleColor(UIColor.black, for: .normal)
            
            //setting frame
            lettersToClickFrame.last!.isEnabled = false
            lettersToClickFrame.last!.frame = CGRect(x: lettersToClick.last!.frame.origin.x, y: lettersToClick.last!.frame.origin.y, width: lettersToClick.last!.frame.width, height: lettersToClick.last!.frame.height)
            lettersToClickFrame.last!.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
            lettersToClickFrame.last!.layer.cornerRadius = lettersToClick.last!.frame.height/3
            lettersToClickFrame.last!.layer.shadowColor = UIColor.darkGray.cgColor
            lettersToClickFrame.last!.layer.shadowRadius = 1
            lettersToClickFrame.last!.layer.shadowOpacity = 0.5
            lettersToClickFrame.last!.layer.shadowOffset = CGSize(width: 0, height: 0)
            lettersToClickFrame.last!.tag = n
            
            self.view.addSubview(lettersToClick.last!)
            self.view.addSubview(lettersToClickFrame.last!)
            view.sendSubviewToBack(lettersToClickFrame.last!)
        }
        newPokemon()
    }
    
    @objc func updateScore() {
        if(scoreToAdd >= 10) {
            scoreToAdd -= 10
        }
        
    }
    
    
    //function that runs the getPokemon function again- in a separate function for readability and for when we want to add more stuff to this function, so getPokemon() stays as only for JSON parsing
    func newPokemon() {
        //starts the timer
        scoreToAdd = 1000
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateScore)), userInfo: nil, repeats: true)
        
        //set button title to Loading while API data loads
        checkButton.setTitle("Loading...", for: .normal)
        //what's in the brackets is done after the API data is loaded
        getPokemon {
            //in main.async because changing UILabel text must be done on main thread, not background
            DispatchQueue.main.async {
                //change checkButton text to "Check"
                self.checkButton.setTitle("Check", for: .normal)
                //move all buttons that are at the top from the previous userInput back to their original positions at the bottom
                for n in self.lettersToClick {
                    if(n.frame.origin.y < 650) {
                        let dest = CGPoint(x: self.lettersToClickFrame[n.tag].frame.origin.x, y: self.lettersToClickFrame[n.tag].frame.origin.y)
                        UIView.animate(withDuration: 0.2, animations: {
                            n.frame = CGRect(x: dest.x, y: dest.y, width: n.frame.size.width, height: n.frame.size.height)
                        })
                    }
                }
                
                //remove all buttonFrames and the userInput from the previous pokemon
                for button in self.userInputButtonFrames {
                    button.removeFromSuperview()
                }
                self.userInputButtonFrames.removeAll()
                self.userInput.removeAll()
                
                
                self.PokeImage.image = UIImage(named: "questionmarkblue")
                //set the text for all the labels
                var secondType = ""
                if(self.currPokemon!.types.count >= 2) {
                    secondType = " + " + self.currPokemon!.types[1].type.name
                }
                self.typeLabel.text = self.currPokemon!.types[0].type.name + secondType
                //self.moveLabel.text = self.currPokemon!.moves[self.currPokemon!.moves.count-1].move.name
                self.moveLabel.text = String(self.currGen)
                self.abilityLabel.text = self.currPokemon!.abilities[0].ability.name
                self.heightLabel.text = self.convertHeight(height: self.currPokemon!.height)
                self.nameLabel.text = ""
                
                //text reformatting
                self.moveLabel.text = self.moveLabel.text!.replacingOccurrences(of: "-", with: " ")
                self.abilityLabel.text = self.abilityLabel.text!.replacingOccurrences(of: "-", with: " ")
                self.moveLabel.text = self.moveLabel.text?.capitalized
                self.typeLabel.text = self.typeLabel.text?.capitalized
                self.abilityLabel.text = self.abilityLabel.text?.capitalized
                
                //sizeToFit modifies the size of the UILabels to fit the text inside so that long text wouldn't appear as "Pikac..." etc.
                self.typeLabel.sizeToFit()
                self.moveLabel.sizeToFit()
                self.abilityLabel.sizeToFit()
                self.heightLabel.sizeToFit()
                //Set the nameLabel's x center to the view's x center
                
                //split the Pokemon's name into an array of characters and store that in pokemonLetters
                var pokemonLetters = Array(self.currPokemon!.name)
                //fill up the pokemonLetters array with random letters until there are enough to fill up the 16 open spots
                while(pokemonLetters.count < 16) {
                    let randomLetter = self.randomLetters[Int.random(in: 0 ... self.randomLetters.count - 1)]
                    //no random letters can be repeats
                    if(pokemonLetters.contains(randomLetter)) {
                        continue
                    }
                    pokemonLetters.append(randomLetter)
                }
                //shuffle the array so it has the pokemon's name as the first buttons shown
                pokemonLetters.shuffle()
                //set buttons letters
                for n in 0 ..< 16 {
                    self.lettersToClick[n].setTitle(String(pokemonLetters[n]), for: .normal)
                }
                //create the userInputButtonFrames, meaning the frames at the top where the buttons go after the user clicks on them
                for n in 0 ..< self.currPokemon!.name.count {
                    if(n == 0) {
                        self.userInputButtonFrames.append(UIButton(frame: CGRect(x: Int(self.view.center.x) - self.currPokemon!.name.count * 20, y: 642, width: 32, height: 32)))
                    } else {
                        self.userInputButtonFrames.append(UIButton(frame: CGRect(x: self.userInputButtonFrames[n-1].frame.origin.x + 40, y: 642, width: 32, height: 32)))
                    }
                    self.userInputButtonFrames.last!.isEnabled = false
                    self.userInputButtonFrames.last!.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
                    self.userInputButtonFrames.last!.layer.cornerRadius = self.userInputButtonFrames.last!.frame.height/3
                    self.userInputButtonFrames.last!.layer.shadowColor = UIColor.darkGray.cgColor
                    self.userInputButtonFrames.last!.layer.shadowRadius = 1
                    self.userInputButtonFrames.last!.layer.shadowOpacity = 0.5
                    self.userInputButtonFrames.last!.layer.shadowOffset = CGSize(width: 0, height: 0)
                    self.userInputButtonFrames.last!.tag = n
                    
                    //append "/" for each letter in the pokemon's name, as the user input is currently empty
                    self.userInput.append("/")
                    
                    //add buttonframe to view so it is visible, but send it to back so it appears behind buttons when they are send to the same coordinates
                    self.view.addSubview(self.userInputButtonFrames.last!)
                    self.view.sendSubviewToBack(self.userInputButtonFrames.last!)
                }
            }
        }
    }
    
    @objc func letterButtonClicked(sender: UIButton!) {
        //if button is at the bottom, meaning not in user input
        if(sender.frame.origin.y >= 650) {
            //if input is full, meaning there are no "/"s in userInput, return
            if(!userInput.contains("/")) {
                return
            }
            
            //find first open spot (first index of "/") and both move to it and add the letter to userInput
            let leftMostOpenSpot = userInput.firstIndex(of: "/")
            UIView.animate(withDuration: 0.2, animations: {
                sender.frame = CGRect(x: self.userInputButtonFrames[leftMostOpenSpot!].frame.origin.x, y: self.userInputButtonFrames[leftMostOpenSpot!].frame.origin.y, width: 32, height: 32)
            })
            userInput[leftMostOpenSpot!] = sender.titleLabel!.text!
            //if button is at top, meaning already in user input
        } else {
            //find all indexes of the letter and loop through all of them
            let indexesOfLetter = userInput.indexes(of: sender.titleLabel!.text!)
            for n in indexesOfLetter {
                //check if the current index is the correct one by checking the X of the frame behind the button and the X of the clicked button (this is in place to avoid bugs with duplicates, as just taking the first index would cause issues when removing the non-first index)
                if(userInputButtonFrames[n].frame.origin.x == sender.frame.origin.x) {
                    //when the correct index is found, set it to empty/open and break the loop
                    userInput[n] = "/"
                    break
                }
            }
            //move button to its original frame at the bottom
            let dest = CGPoint(x: lettersToClickFrame[sender.tag].frame.origin.x, y: lettersToClickFrame[sender.tag].frame.origin.y)
            UIView.animate(withDuration: 0.2, animations: {
                sender.frame = CGRect(x: dest.x, y: dest.y, width: sender.frame.size.width, height: sender.frame.size.height)
            })
        }
        print("userInput: ", userInput.joined(separator: ""))
    }
    
    //when GuessView loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }
    
    //function to convert the parameter height from the decimeters given by the API and return it as a string of feet and inches (8 -> 3'4'').
    func convertHeight(height: Int) -> String {
        let totalinches = height * 4
        let feetlessInches = totalinches % 12
        let feet = (totalinches - feetlessInches ) / 12
        return String(feet) + "' " + String(feetlessInches) + "''"
    }
    
    
    //Got help for API parsing from https://www.youtube.com/watch?v=XZS-eeO9YoU
    fileprivate func getPokemon(completion: @escaping () -> Void) {
        
        //Makes a URL with a random Pokemon taken from the PokeNames struct at the top
        let randomNum = Int.random(in: 0 ..< PokeNames.pokeNames.count - 1)
        let newPokemonName = PokeNames.pokeNames[randomNum]
        let urlString = "https://pokeapi.co/api/v2/pokemon/" + newPokemonName
        //prints for debugging purposes: sometimes API might not have a random pokemon, this is to be able to tell what pokemons to remove
        print(urlString)
        //convert url string to XCode's URL type
        guard let url = URL(string: urlString) else { return }
        //URLSession is used to get API information from URLs
        URLSession.shared.dataTask(with:url) { (data, response, err) in
            
            guard let data = data else { return }
            
            //If successful
            do {
                //JSONDecoder decodes it into something the Codables above understand. This just initializes the decoder, the decoding isn't done until the self.currPokemon = try decoder.decode() line below
                let decoder = JSONDecoder()
                //.convertFromSnakeCase is used because the API uses snakecase (front_default) instead of camelCase (frontDefault) which is XCode's standard
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.currPokemon = try decoder.decode(Pokemon.self, from: data)
                //completion() is not an XCode function, but rather just whatever we name it in the parameters of this function above. What this does is make sure when we call getPokemon { ... }, the ... does not happen until completion() is called. If we didn't have this, the ... would not work because APIs take time to load and decode.
                self.loadImage(url: URL(string: self.currPokemon!.sprites.frontDefault)!)
                if(randomNum < 149) {
                    self.currGen = 1
                } else if(randomNum < 249) {
                    self.currGen = 2
                } else if(randomNum < 384) {
                    self.currGen = 3
                } else if(randomNum < 489) {
                    self.currGen = 4
                } else if(randomNum < 642) {
                    self.currGen = 5
                } else if(randomNum < 712) {
                    self.currGen = 6
                } else {
                    self.currGen = 7
                }
                completion()
                //error exception for if the JSON can't be decoded (wrong format etc.)
            } catch let jsonError {
                print("error: ", jsonError)
            }
        }.resume()
    }
    
}

