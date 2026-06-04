# ===== 6.5 Prédiction sur une nouvelle commande =====
# Créer un vecteur vide aligné sur les features du modèle
cmd_enc <- as.data.frame(matrix(0, nrow = 1, ncol = length(features)))
names(cmd_enc) <- features
# Valeurs numériques
cmd_enc$unit_price <- 3500
cmd_enc$qty_returned <- 4
cmd_enc$month <- 12
cmd_enc$signup_year <- 2023
# Dummies catégorielles
cmd_enc$"category_nameCat_11" <- 1 # Cat_11
cmd_enc$"price_bandHigh" <- 1 # High
cmd_enc$"is_weekend.1" <- 1 # weekend = 1
cmd_enc$"cityMumbai" <- 1 # Mumbai
# has_promotion — pas de colonne dummy car un seul niveau dans train
# donc on ne touche pas (reste 0)
# Normalisation
cmd_norm <- as.data.frame(lapply(names(cmd_enc), function(col) {
x <- cmd_enc[[col]]
mn <- min(train_enc[[col]])
mx <- max(train_enc[[col]])
(x - mn) / (mx - mn + 1e-8)
}))
names(cmd_norm) <- features
# Prédiction
resultat <- compute(model_nn, cmd_norm)
proba <- resultat$net.result[1]
cat("Probabilité retour critique:", round(proba * 100, 1), "%\n")
# Interprétation
cat("Interprétation : Ce retour (Cat_11, prix 3500€, qty=4, décembre,\n")
cat("weekend, Mumbai) a une probabilité de", round(proba * 100, 1),
"% d'être critique.\n")
cat("Le modèle recommande une attention particulière sur cette commande.\n")