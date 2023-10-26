
//  Created by Zack Klopukh on 10/19/23.
//  CPSC 357.
//  Last Revision: 10/26/23.

import SwiftUI
// This project consists of three views, a main content view, a detailed view, and an add view. These three views are descirbed in functionality where they are in code, and together they create the soccer players list app. This app allows users to view soccer players, and add new soccer players to their list, with data on thier team and nation, as well as a description.

// The content view structure contains the main view that the app starts on. This includes the data of the preloaded soccer players. This screen has a navigation bar containing an "add" and "edit" menu, as well as detailed views of each element.
struct ContentView: View {
    @State private var showAddPlayerView = false
    
    // players is the array containing all players created, preloaded with 5 players.
    @State var players = [
        Player(name:"Virgil Van Dijk", team: "Liverpool", playerImage: "vvd", description: "Virgil van Dijk (born 8 July 1991) is a Dutch professional footballer who plays as a centre back for and captains both Premier League club Liverpool and the Netherlands national team. Regarded as one of the best defenders in the world, he is known for his strength, leadership, speed and aerial ability.", nation: "🇳🇱"),
        Player(name:"Mohamed Elneny", team: "Arsenal", playerImage: "elneny2", description: "Mohamed Naser Elsayed Elneny (born 11 July 1992) is an Egyptian professional footballer who plays as a defensive midfielder for Premier League club Arsenal and the Egypt national team.", nation: "🇪🇬"),
        Player(name:"Jeffinho", team: "Lyon", playerImage: "jeffinho2", description: "Jefferson Ruan Pereira dos Santos (born 30 December 1999), commonly known as Jeffinho, is a Brazilian professional footballer who plays as a forward or attacking midfielder for Ligue 1 club Lyon.", nation: "🇧🇷"),
        Player(name:"Aitana Bonmati", team: "Barcelona", playerImage: "bonmati2", description: "Aitana Bonmatí Conca (born 18 January 1998) is a Spanish professional footballer who plays as a midfielder for Liga F club Barcelona and Spain women's national team. She is considered one of the best players in women's football.", nation: "🇪🇸"),
        Player(name:"Marcelo", team: "Real Madrid", playerImage: "marcelo3", description: "Marcelo Vieira da Silva Júnior (born 12 May 1988), known as Marcelo, is a Brazilian professional footballer who plays as a left-back for Campeonato Brasileiro Série A club Fluminense. Known for his offensive capabilities, trickery, and technical qualities, Marcelo is often regarded as one of the greatest left-backs of all time. He spent most of his career with Spanish club Real Madrid and is the club's most decorated player, with 25 trophies won.", nation: "🇧🇷")]
    
    var body: some View {
        //Naviagtion view enables us to use detailed views
        NavigationView {
            List {
                //For every elemant in our array, we will add a new element to our List. This element will have its own preview as well as an option to navigate to the detailed view
                ForEach (players) { (player) in
                    NavigationLink(destination:
                                    //Subview for the detailed view of a player
                                    DetailedView(player: player))
                    {
                        //This HStack gives us the preview of a players team with their name
                        HStack {
                            Image(player.team)
                                .resizable()
                                .frame(width: 55, height: 55)
                            Text(player.name)
                        }
                    }
                    
                }
                //.onDelete modifier allows us to remove items from our list
                .onDelete(perform: { indexSet in players.remove(atOffsets: indexSet)})
                //.onMove modifier allows us to move items around our list
                .onMove(perform: { indices, newOffset in
                    players.move(fromOffsets: indices, toOffset: newOffset)
                })
            }
            .navigationBarTitle("Soccer Players")
            //Our navigation bar will have two seperate items, "add on the left (leading) and edit on the right (trailing)
                .navigationBarItems(
                    leading: Button("Add") {
                        self.showAddPlayerView.toggle()
                        //When add is clicked, it toggles a sheet to pop up, which is the AddNewPlayerView. When this is closed, it adds the new data to the array and list
                    }.sheet(isPresented: $showAddPlayerView) {
                        AddNewPlayerView(showAddPlayerView: self.$showAddPlayerView, players: self.$players)
                    },
                    //the edit view is useful for modifying the order of players
                    trailing: EditButton()
                )
        }
        
    }
}

// This view contains the view where a user can add a new player
struct AddNewPlayerView: View {
    @Binding var showAddPlayerView: Bool
    
    //These team names will appear in a picker and need to be listed out, but also refer to an image in the assests folder
    var teamNames = ["Other", "Arsenal", "Athletico Madrid", "Barcelona", "Bayern Munich", "Chelsea", "Dortmund", "Inter Milan", "Juventus", "Liverpool", "Lyon", "Manchester City", "Manchester United", "Napoli", "Paris SG", "Real Madrid", "Sevilla"]
    @State private var teamIndex = 0
    
    //I generated this list through Chat GPT with extensive prompt changes and deliberations to gether a shortened list of all the countries that should cover the majority of soccer players based on skill
    let countryFlags: [String: String] = [
        " Other": "🌍", "Argentina": "🇦🇷", "Australia": "🇦🇺", "Bangladesh": "🇧🇩", "Belgium": "🇧🇪", "Brazil": "🇧🇷", "Canada": "🇨🇦", "China": "🇨🇳", "Chile": "🇨🇱", "Colombia": "🇨🇴", "Costa Rica": "🇨🇷", "Czech Republic": "🇨🇿", "Denmark": "🇩🇰", "Ecuador": "🇪🇨", "Egypt": "🇪🇬", "Finland": "🇫🇮", "France": "🇫🇷", "Germany": "🇩🇪", "Ghana": "🇬🇭", "Greece": "🇬🇷", "Honduras": "🇭🇳", "Hungary": "🇭🇺", "India": "🇮🇳", "Indonesia": "🇮🇩", "Iran": "🇮🇷", "Ireland": "🇮🇪", "Israel": "🇮🇱", "Italy": "🇮🇹", "Jamaica": "🇯🇲", "Japan": "🇯🇵", "Mexico": "🇲🇽", "Netherlands": "🇳🇱", "New Zealand": "🇳🇿", "Norway": "🇳🇴", "Peru": "🇵🇪", "Pakistan": "🇵🇰", "Poland": "🇵🇱", "Portugal": "🇵🇹", "Romania": "🇷🇴", "Russia": "🇷🇺", "Saudi Arabia": "🇸🇦", "Serbia": "🇷🇸", "Slovakia": "🇸🇰", "Slovenia": "🇸🇮", "South Africa": "🇿🇦", "South Korea": "🇰🇷", "Spain": "🇪🇸", "Sweden": "🇸🇪", "Switzerland": "🇨🇭", "Turkey": "🇹🇷", "Ukraine": "🇺🇦", "United Arab Emirates": "🇦🇪", "United Kingdom": "🇬🇧", "United States": "🇺🇸", "Uruguay": "🇺🇾"]
    //this holds the key of the selected country
    @State private var selectedFlag = " Other"
    
    @Binding var players: [Player]
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        Text("Add New Player")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        //call data input for both name and description
        DataInput(title: "Name",  userInput: $name)
            .padding()
        DataInput(title: "Description",  userInput: $description)
            .padding()

        //There are two HStacks, this puts both wheels next to each other. I think it looks good and shows how I can manipulate a view.
        HStack {
            //Each HStack has a VStack consisting of a text Title, and a picker
            VStack {
                Text("Team")
                    .font(.headline)
                //The picker uses a for each loop to display each team
                Picker(selection: $teamIndex, label:
                        Text("Team")) {
                    ForEach (0 ..< teamNames.count) { team in
                        HStack {
                            Text(teamNames[team])
                            Image(teamNames[team])
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                } .pickerStyle(.wheel)
            }
            VStack {
                Text("Nation")
                    .font(.headline)
                //this for each is more complicated because I wanted it to display a sorted dictionary, but dictionaries are unsorted data types so I use .keys.sorted() to sort in alphabetical order of countries.
                Picker(selection: $selectedFlag, label:
                        Text("Team")) {
                    ForEach (countryFlags.keys.sorted(), id: \.self) { flag in
                        Text("\(flag) \(countryFlags[flag] ?? "")")
                    }
                } .pickerStyle(.wheel)
            }
        }
        
        //The done button with untoggle the sheet, and also add the new data into the array of players
        Button("Done") {
            self.showAddPlayerView = false
            players.append(Player(name: name, team: teamNames[teamIndex], playerImage: "unknown4", description: description, nation: countryFlags[selectedFlag] ?? "🌍"))
        }
    }
}

//We made this structure in class for our ListNav project, it takes a title and displays a text field that gathers the users input to be stored as the userInput
struct DataInput: View {
    var title: String
    @Binding var userInput: String
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

//This is the Player structure with all of its modifiers
struct Player: Identifiable {
    let id = UUID ()
    let name: String
    let team: String
    let playerImage: String
    let description: String
    let nation: String
}

#Preview {
    ContentView()
}


// This structure is the detailed view of the individual player. This view is acsessed through the navigation link and is an extracted subview.
struct DetailedView: View {
    let player: Player
    
    var body: some View {
        VStack{
            //This HStack creates the heading of the detailed view containing the players name, country, and team
            HStack {
                Text(player.nation)
                    .font(.system(size: 50))
                
                Text(player.name)
                    .font(.title)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Image(player.team)
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            //The preloaded players have an image that is displayed in the middle of the screen. (New players do not get a image)
            Image(player.playerImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
            
            //Finally the description of said player is displayed
            Text(player.description)
        }
    }
}
