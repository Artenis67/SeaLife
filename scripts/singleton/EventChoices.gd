extends Node

####################################
# LOST CARGO (mini-jeu + choix)
####################################
var lost_cargo_choice: String = ""
var cargo_drop_result: int = 0
var last_result: int = 0


####################################
# TECHNICAL ISSUE (choix simple)
####################################
var technical_issue_choice: String = ""


####################################
# PETITES VAGUES
####################################
var small_waves_choice: String = ""


####################################
# BRUIT SUSPECT
####################################
var strange_noise_choice: String = ""


####################################
# PETIT INCIDENT DE CARGO
####################################
var minor_cargo_issue_choice: String = ""


####################################
# CUISINIER PAS CONTENT DU ROULIS
####################################
var cook_rolling_choice: String = ""


####################################
# MATELOT MALADE
####################################
var sailor_sick_choice: String = ""


####################################
# CARGO MAL ALIGNÉ (payé / ignoré)
####################################
var misaligned_cargo_choice: String = ""


####################################
# NETTOYAGE DE PONT
####################################
var deck_cleaning_choice: String = ""


####################################
# INSPECTION SURPRISE
####################################
var random_inspection_choice: String = ""


####################################
# HOMME À LA MER (rescue / leave)
####################################
var man_overboard_choice: String = ""


####################################
# NOUVEAUX EVENTS RÉALISTES
####################################

# Reefer en alarme
var reefer_issue_choice: String = ""

# Inspection douanière
var customs_inspection_choice: String = ""

# Marchandise dangereuse mal déclarée
var dangerous_cargo_choice: String = ""

# Bloc en surcharge
var overweight_block_choice: String = ""

# Contrat rapide au port (+3 conteneurs si accepté)
var quick_contract_choice: String = ""

# Kidnapping nocturne (payer la rançon ou non)
var kidnap_choice: String = ""


####################################
# TEMPÊTE (mini-jeu)
####################################
var storm_lost_cargo: int = 0
var storm_reaction_time: float = 0.0
