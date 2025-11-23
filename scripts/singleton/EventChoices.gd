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
# D'AUTRES EVENTS FUTURS
# (laisse ici pour ajouter facilement)
####################################
# var pirates_choice: String = ""
# var storm_result: int = 0
# etc.

var reefer_issue_choice = ""

var customs_inspection_choice = ""

var dangerous_cargo_choice = ""

var overweight_block_choice = ""

var storm_lost_cargo: int = 0
var storm_reaction_time: float = 0.0
