# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear existing data in the correct order to avoid foreign key violations
puts "Clearing existing data..."
TeamMarker.destroy_all
Marker.destroy_all
Team.destroy_all
User.destroy_all
puts "Existing data cleared!"


# Create Markers in Versailles
puts "Creating markers..."
Marker.create!(
  name: "Pièce d'eau des suisses",
  content: <<~CONTENT,
    J'aperçois enfin les cheveux bruns de mon ami à travers la fenêtre. Je l'entends déjà rire aux éclats, Auguste a cette facilité à communiquer, il a toujours été curieux, il se nourrit des autres, comme il me répète si souvent « ma richesse vient de ce qu'il m'entoure ». Nous déjeunons ensemble plusieurs fois par semaine, lorsqu'il arrive à détacher les yeux de son livre de médecine. La tradition est ainsi depuis dix fidèles années : Auguste ramène le pain ainsi que le vin si nous avons vendu suffisamment de chapeaux le mois précédent, et je m'occupe du reste. Auguste n'a plus que sa maman, son paternel a fui avant sa naissance, il ne voulait pas d'un foyer. Nous aimons parfois prendre notre croûte à la pièce d'eau des Suisses, pour observer les enfants jouer et les amants s'enlacer. Je m'active à préparer le panier, y rajoute une nappe que j'ai cousu spécialement pour l'occasion. Auguste me raconte sa leçon du jour, tandis que j'installe le repas sur l'herbe fraîche du parc. Même si j'adore mon ami, parfois mes pensées s'éloignent de lui, j'aime laisser mon esprit divaguer.
  CONTENT
  enigma: <<~ENIGMA,
    Je suis un miroir vaste, une étendue liquide, Née du labeur de ceux venus des montagnes humides. Au pied du grand roi, dans un domaine royal, Je reflète châteaux, jardins, et soleil automnal. Conçue pour la beauté et pour la majesté, Par des mains suisses, en un jardin d'été. Je suis calme et sereine, un lieu de promenade, Trouve-moi et contemple la splendeur de l'esplanade. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.800803,
  longitude: 2.119673,
  marker_pass: "1789",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "Bibliothèque de Versailles",
  content: <<~CONTENT,
    Soudain, une phrase me sort de ma rêverie, Auguste évoque un symptôme étudié aujourd'hui : une boule dans le sein d'une femme. Je tente alors de discerner ses dires sur le sujet, il est vrai que récemment une masse inconnue y a trouvé refuge dans mon sein gauche. Celle-ci n'étant pas douloureuse, je ne m'étais pas plus inquiétée. Je rassemble mon courage, et le coupe dans son monologue. Mon ami fronce les sourcils en premier, puis prend quelques secondes pour analyser ce qui vient de se passer. Ni une, ni deux, celui-ci rassemble nos effets, me volant ma fourchette en pleine lancée. Me prenant par la main, Auguste prend désormais un air inquiet. C'est au galop que nous nous dirigeons vers la bibliothèque de Versailles.(nous noterons que ce bâtiment fut à l'époque l'hôtel des affaires étrangères et de la marine, mais que pour la logique de notre histoire, nous gardons sa fonction actuelle). Nous nous faufilons dans la rangée recherche sur l'anatomie, Auguste parcourt les livres avec le bout de ses doigts jusqu'à trouver le Graal. J'aurais bien aimé pouvoir lire à ses côtés, mais l'instruction et l'éducation est un luxe dont je n'ai pas accès. Il relève la tête après avoir tourné quelques pages, et commence à me poser des questions. « - As-tu des nausées parfois Joséphine ? - De temps en temps en effet, mais je pense qu'elles sont la conséquence de la potée de maman. - Lève les bras s'il-te-plaît. » Malgré l'étrangeté de la demande, je m'exécute, offrant une confiance aveugle en lui. Ses mains viennent à toucher mes aisselles. Qu'il est futé, c'est justement ici où je me sentais inconfortable, je pensais que cela était dû au froid que l'hiver a laissé. Du bout de ses doigts, il traverse le chemin de la douleur, réalisant centimètre après centimètre l'ampleur de ces masses. «- Joséphine, il faut absolument que tu passes au cabinet, je dois montrer ça à mon professeur, me dit-il. - Auguste, je n'ai pas le droit de quitter la boutique. - Très bien, alors c'est moi qui irai parler à ta mère, je trouverai un mensonge à lui raconter, mais comprends bien que c'est urgent et sérieux.»
  CONTENT
  enigma: <<~ENIGMA,
    Dans la ville des rois, où l'histoire est tracée, Se cache un trésor de savoir bien gardé. Entre les pages dorées de siècles passés, Se trouvent les secrets que le temps a laissés. Un palais de lettres et de mots bien rangés, Où les esprits curieux viennent se cultiver. Pas loin du château, mais dans un coin tranquille, Je suis un sanctuaire pour le savoir et l'utile. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.802118,
  longitude: 2.120964,
  marker_pass: "1774",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "Le palais des congrès",
  content: <<~CONTENT,
    C'est sur ces mots que notre discussion se clôt. Auguste remballe ses affaires, me fait un signe de la main et s'en va. Je me retrouve désormais seule parmi les livres, avec dans la tête une montagne de question. Qu'est-ce donc ce corps dans ma poitrine ? Est-il dangereux ? Vais-je mourir ? Pourquoi Auguste ne m'en a-t-il pas dit plus ? J'attrape le panier qui se trouvait à mes pieds, et décide de quitter à mon tour ces murs. C'est rue de la Chancellerie que mon esprit se met à me tourmenter, mes jambes décident de m'abandonner, me laissant m'écrouler sur les pavés de la ville. Ce fut comme si tout mon corps décidait de faire une pause, ma tête me tournait. Les secondes m'ont paru des heures avant que quelqu'un ne se dirige vers moi. Une main s'est tendue, j'ai saisi l'occasion pour me relever. Ayant honte de la situation, j'ai préféré partir furtivement en laissant au passage un petit « merci ». Prenant mes jambes à mon cou, je me dépêche de rentrer à la boutique avant que ma mère ne s'aperçoive de mon retard.
  CONTENT
  enigma: <<~ENIGMA,
    Je suis un lieu de rassemblement, moderne et grandiose, Où se rencontrent esprits brillants et paroles précieuses. Dans la ville des rois, mais dédié au présent, Je reçois des foules pour des moments captivants. Événements et discours résonnent sous mon toit, Je suis le carrefour où se mêlent foi et loi. Dans ce centre prestigieux, rencontres et échanges, Qui suis-je ? Viens et découvre ce lieu de mélange. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude:  48.802626,
  longitude: 2.123635,
  marker_pass: "1682",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "L'église Notre Dame",
  content: <<~CONTENT,
    En passant devant l'église Notre-Dame, un mendiant attrapa ma main, celui-ci semble lire dans les lignes. « Je vois du noir mademoiselle, les ténèbres sont en chemin. Priez, priez si vous voulez survivre ». D'un geste, je retire ma main des siennes, mon cœur s'emballe et ma vision se trouble. Mais qu'ont-ils tous aujourd'hui ? J'ai le sentiment d'être coincée dans un mauvais rêve. Je pense que je vais demander à mère de me reposer.
  CONTENT
  enigma: <<~ENIGMA,
    Sous le regard bienveillant du Roi Soleil, Se dresse une maison de prière et de conseil. Construite pour les courtisans, de marbre et de pierre, Elle a vu des siècles de foi et de lumière. Dans la ville des rois, au cœur de la cité, Elle accueille fidèles et âmes à guider. Son nom évoque la Mère du Sauveur, En son sein résonnent les chants du cœur. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.807565,
  longitude: 2.128744,
  marker_pass: "1919",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "Place du marché",
  content: <<~CONTENT,
    Mes yeux s'entrouvrent lentement, j'ai l'impression d'avoir dormi pendant un siècle. Sortir du lit fut une étape, le chaud et le froid viennent me frapper en même temps, ma poitrine est d'une lourdeur et d'une sensation anormale. Je laisse mes pieds trainer sur le sol et m'emporter vers le couloir. Ma mère m'attend devant la cheminée, avec Auguste à ses côtés…Celui-ci s'accourt dans mes bras, les larmes chaudes coulant sur mon épaule. C'est bien la première fois que mon ami ose pleurer devant moi. Sans un mot, il enfile un manteau sur mon dos, attrape l'écharpe qui se trouve sur la table et s'assure que je n'ai pas froid. « - Combien de temps ai-je dormi ? - Cela n'a pas d'importance, suis moi Joséphine. » D'un geste de la main, je fais mes au revoir à ma mère, lui disant je t'aime au travers des yeux, et claque la porte derrière moi. Nous traversons la place du marché, où les femmes se battent pour avoir la meilleure salade, où les enfants tentent de piquer une ou deux friandises, où les doyennes s'endorment sur leur fauteuil à bascule. Je me sens faible parmi toute cette vivacité, j'aimerais puiser dans l'énergie de chacun, pour y trouver de la force. "- Joséphine, j'ai besoin que tu m'écoutes soigneusement. Une voisine m'a rapporté que tu étais tombée l'autre jour après que je t'aie laissée seule à la bibliothèque. Nous nous inquiétons pour ton état de santé, surtout après ce que tu m'as révélé, me sort soudainement Auguste. Nous nous rendons chez mon maître, il a accepté de te recevoir afin de t'ausculter.
  CONTENT
  enigma: <<~ENIGMA,
    Au cœur de la ville où le roi autrefois régnait, Un lieu animé de couleurs et d'odeurs variées. Chaque matin, sous les toiles tendues, Se rencontrent les marchands et les gens de la rue. Des légumes frais, des fruits, des épices, Du fromage, des fleurs, et mille délices. Depuis des siècles, c'est ici qu'on se retrouve, Pour échanger, pour parler, et pour que la vie s'éprouve. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.806612,
  longitude: 2.131930,
  marker_pass: "1783",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "Rue de Satory",
  content: <<~CONTENT,
    Quel jour sommes-nous Auguste ? - Jeudi Joséphine, jeudi, soupira-t-il. Jeudi...Cela veut dire que j'ai dormi durant trois jours. Comment cela est-ce possible ? Parfois, j'aimerais pouvoir lire dans les pensées de mon compagnon, sentir ses craintes et les comprendre. La foule commence peu à peu à apparaître, le calme se dissout dans un mélange de violence et de mots-doux. Je me trouve rue de Satory, le quartier des artisans et de la poésie, là où le peuple se réunit, loin de la couronne et des non-dits. Auguste poussa une porte rouge, rouge comme la passion mais, aussi comme le poison. Mon pouls s'accélère considérablement, est-ce les quelques lieues que nous venons de traverser, ou la peur d'affronter la réalité ? Un homme de moyenne taille apparu, une barbe mal taillée, une blouse négligée. - Asseyez-vous mon enfant. Je m'exécute à l'instant où ces mots sont prononcés.
  CONTENT
  enigma: <<~ENIGMA,
    Dans la ville du roi où l'histoire se raconte, Une rue animée où la vie s'enchante. Là où restaurants et boutiques se côtoient, Un lieu de promenade pour les passants de bonne foi. Entre les pavés, des rires et des saveurs, Un quartier vivant, vibrant de mille couleurs. À deux pas du château, mais moderne et léger, Je suis une artère où l'on aime flâner. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude:  48.799994,
  longitude: 2.124685,
  marker_pass: "1793",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "La cathédrale Saint Louis",
  content: <<~CONTENT,
    Une heure est passée, je suis désormais seule dehors, j'ai préféré retourner sur mes pas sans la présence de mon ami. Je souhaitais passer par la cathédrale Saint Louis prier, là où l'espoir reste éveillé. J'allume alors un cierge, en espérant que quelqu'un m'entende de là-haut. Mes jambes tremblent et mon souffle devient irrégulier. Je me rattrape sur une chaise et tente de reprendre mes esprits. C'est dans la maison de Dieu que je choisis de me réfugier, que je choisis de me confesser. J'ai peur, je suis même terrifiée de ce que l'avenir me réserve. Je m'en remets alors au ciel, m'abandonnant dans cette chapelle.
  CONTENT
  enigma: <<~ENIGMA,
    Dans la ville royale où Louis fit son trône, Se dresse un édifice, majestueux, en pierre et en faïence. Consacrée au Roi des cieux, sous un patron sacré, Elle voit les fidèles venir prier en paix. Des vitraux colorés illuminent son intérieur, Et son orgue puissant résonne en splendeur. Ce lieu sacré au cœur de la cité, Accueille messes et prières depuis des années. Qui suis-je ?
  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.798680,
  longitude: 2.124575,
  marker_pass: "1661",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

Marker.create!(
  name: "Hôtel Le Louis",
  content: <<~CONTENT,
    Bravo ! Joséphine te félicite pour ta réussite face à cette chasse aux trésors. Toute l'équipe green drink t'invite à reprendre des forces ainsi qu'à discuter au sujet de cette expérience à l'hôtel Le Louis.
  CONTENT
  enigma: <<~ENIGMA,
    Joséphine te félicite pour ta réussite face à cette chasse aux trésors. Toute l'équipe green drink t'invite à reprendre des forces ainsi qu'à discuter au sujet de cette expérience à l'hôtel Le Louis.Tu peux valider le dernier point en entrant le mot de passe : 1234

  ENIGMA
  found: false,
  radius: 50,  # Set radius to 50 meters
  latitude: 48.8018438,
  longitude: 2.1288123,
  marker_pass: "1234",
  address: "Versailles, France",
  created_at: Time.now,
  updated_at: Time.now
)

puts "Markers created!"

# # Create 80 users with structured email format (mail1@mail1.com, mail2@mail2.com, etc.)
# puts "Creating 80 users..."
# users = 80.times.map do |i|
#   User.create!(
#     email: "mail#{i+1}@mail#{i+1}.com",
#     password: 'password',
#     password_confirmation: 'password',
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name
#   )
# end

# # Assign names to some teams to make them accessible
# puts "Naming some teams..."
# named_teams = []
# users.sample(10).each_with_index do |user, i|
#   team_name = "Team #{Faker::Team.creature}-#{i + 1}" # Generating unique team names
#   user.team.update!(name: team_name) # Update the user's team with a name
#   named_teams << user.team # Store the named teams for other users to join
# end

# # Assign some users to named teams
# puts "Assigning some users to named teams..."
# users.sample(30).each do |user|
#   team_to_join = named_teams.sample # Randomly pick a named team
#   user.update!(team: team_to_join) # Assign the user to the selected team
# end

# # Create specific users for testing purposes
# puts "Creating specific users for testing..."

# # User positioned less than 10m from a marker to mark it
# user_near_marker = User.create!(
#   email: "near.marker@example.com",
#   password: 'password',
#   password_confirmation: 'password',
#   first_name: "Test",
#   last_name: "NearMarker"
# )

# # Find a marker for the test user
# marker_close = Marker.first
# team_near_marker = user_near_marker.team

# # Update TeamMarker to simulate that the user is near the marker (within 10 meters)
# team_marker_near = TeamMarker.where(team_id: team_near_marker.id, marker_id: marker_close.id).first
# team_marker_near.update!(
#   circle_center_latitude: marker_close.latitude + 0.00005,  # Within 10 meters
#   circle_center_longitude: marker_close.longitude + 0.00005
# )

# # User positioned between 15-50m from a marker
# user_far_marker = User.create!(
#   email: "far.marker@example.com",
#   password: 'password',
#   password_confirmation: 'password',
#   first_name: "Test",
#   last_name: "FarMarker"
# )

# # Find another marker for the far user
# marker_far = Marker.last
# team_far_marker = user_far_marker.team

# # Update TeamMarker to simulate that the user is far from the marker (15 to 50 meters away)
# team_marker_far = TeamMarker.where(team_id: team_far_marker.id, marker_id: marker_far.id).first
# team_marker_far.update!(
#   circle_center_latitude: marker_far.latitude + 0.0003,  # Between 15 and 50 meters
#   circle_center_longitude: marker_far.longitude + 0.0003
# )

puts "Seeding completed!"

## Create Users
# puts "Creating random users..."
# users = 20.times.map do
#   User.create!(
#     email: Faker::Internet.email,
#     password: 'password',  # Use a default password
#     password_confirmation: 'password',  # Ensure password confirmation matches
#     reset_password_token: Faker::Internet.uuid,
#     reset_password_sent_at: Faker::Time.backward(days: 365),
#     remember_created_at: Faker::Time.backward(days: 365),
#     created_at: Faker::Time.backward(days: 365),
#     updated_at: Faker::Time.backward(days: 365),
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     leader: Faker::Boolean.boolean
#   )
# end

## Create Teams with captains
# puts "Creating random teams..."
# teams = 5.times.map do
#   Team.create!(
#     name: Faker::Team.name,
#     captain: users.sample
#   )
# end

## Assign users to teams
# users.each do |user|
#   user.update!(team: teams.sample)
# end

## Helper method to generate random latitude and longitude within a range
# def random_in_range(min, max)
#   (rand * (max - min)) + min
# end

# ## Create TeamMarkers
# # 50.times do
# #   TeamMarker.create!(
# #     team_id: Team.pluck(:id).sample,
# #     marker_id: Marker.pluck(:id).sample,
# #     created_at: Faker::Time.backward(days: 365),
# #     updated_at: Faker::Time.backward(days: 365)
# #   )
# # end


# #  Specific seed

# # puts "Creating specific users and teams..."
# # User.create!(
# #   email: "john.doe@example.com",
# #   password: 'password', # Use a default password
# #   password_confirmation: 'password', # Ensure password confirmation matches
# #   first_name: "John",
# #   last_name: "Doe"
# # )

# # Team.create!(
# #   name: "Green Drink",
# #   captain: User.find_by(email: "john.doe@example.com")
# # )

# # # Assign team to user
# # user = User.find_by(email: "john.doe@example.com")
# # team = Team.find_by(name: "Green Drink")
# # user.update!(team:)

# puts "Creating specific users and teams..."

# user = User.create!(
#   email: "john.doe@example.com",
#   password: 'password', # Use a default password
#   password_confirmation: 'password', # Ensure password confirmation matches
#   first_name: "John",
#   last_name: "Doe"
# )

# team = Team.create!(
#   name: "Green Drink",
#   captain: user
# )

# # Assign team to user
# if user && team
#   user.update!(team: team)
# else
#   puts "Failed to create user or team"
# end


# Marker.order(:id).each do |marker| # On ordonne les teamMarker par Id par facilité
#   if Marker.all.index(marker) <= 4 # Les 4 premiers marqueurs sont visités
#     visited = true
#   else
#     visited = false
#   end

#   TeamMarker.create!(
#     team_id: Team.find_by(name: "Green Drink").id,
#     marker_id: marker.id,
#     order: Marker.all.index(marker),
#     visited:,
#     circle_center_latitude: random_in_range(marker.latitude - 0.001, marker.latitude + 0.001),
#     circle_center_longitude: random_in_range(marker.longitude - 0.001, marker.longitude + 0.001),
#   )
# end

# puts "Seeding completed!"

