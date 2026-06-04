# Arbre de décision
# Cible composite : retour CRITIQUE
# = remboursement élevé ET quantité élevée
# ===== ARBRE DE DÉCISION =====
library(rpart)
library(rpart.plot)
library(caret)
# Cible
df$retour_critique <- as.factor(ifelse(
df$refund_amount >= quantile(df$refund_amount, 0.60) &
df$qty_returned >= 3, 1, 0
))
# Conversion factors
df$has_promotion <- as.factor(df$has_promotion)
df$is_weekend <- as.factor(df$is_weekend)
df$category_name <- as.factor(df$category_name)
df$city <- as.factor(df$city)
df$price_band <- as.factor(df$price_band)
df_model <- df[, c("unit_price", "qty_returned",
"has_promotion",
"category_name", "price_band", "month",
"is_weekend", "signup_year", "city",
"retour_critique")]
df_model <- na.omit(df_model)
set.seed(42)
idx <- createDataPartition(df_model$retour_critique, p =
0.8, list = FALSE)
train <- df_model[idx, ]
test <- df_model[-idx, ]
# Modèle
model_dt <- rpart(retour_critique ~ ., data = train,
method = "class",
control = rpart.control(maxdepth = 6, cp
= 0.0005,
minsplit = 50,
minbucket = 20))
# Visualisation
png("arbre_final.png", width = 6000, height = 4000, res =
200)
rpart.plot(model_dt,
type = 4,
extra = 0,
fallen.leaves = TRUE,
cex = 0.75,
tweak = 1.3,
box.palette = c("#e74c3c", "#2ecc71"),
shadow.col = "gray",
leaf.round = 9,
branch.lty = 3,
varlen = 0,
faclen = 0,
roundint = TRUE,
split.cex = 0.9,
under = TRUE,
under.cex = 0.8,
clip.right.labs = FALSE,
main = "Arbre de Décision — Prédiction
Retour Critique",
cex.main = 1.5)
dev.off()
# Métriques
pred_dt <- predict(model_dt, test, type = "class")
cm_dt <- confusionMatrix(pred_dt, test$retour_critique)
cat("=== MÉTRIQUES ARBRE DE DÉCISION ===\n")
cat("Accuracy :", round(cm_dt$overall["Accuracy"] * 100,
2), "%\n")
cat("Précision :", round(cm_dt$byClass["Precision"] * 100,
2), "%\n")
cat("Recall :", round(cm_dt$byClass["Recall"] * 100,
2), "%\n")
cat("F1-Score :", round(cm_dt$byClass["F1"] * 100, 2),
"%\n")
# ===== Matrice de Confusion — Arbre de Décision =====
library(ggplot2)
cm_table <- as.data.frame(cm_dt$table)
colnames(cm_table) <- c("Prédit", "Réel", "Fréquence")
ggplot(cm_table, aes(x = Réel, y = Prédit, fill =
Fréquence)) +
geom_tile(color = "white", linewidth = 1.2) +
geom_text(aes(label = Fréquence), size = 8, fontface =
"bold", color = "white") +
scale_fill_gradient(low = "#2ecc71", high = "#e74c3c") +
labs(
title = "Matrice de Confusion — Arbre de Décision",
subtitle = paste0("Accuracy : ",
round(cm_dt$overall["Accuracy"]*100,2),
"% | Précision : ",
round(cm_dt$byClass["Precision"]*100,2),
"% | Recall : ",
round(cm_dt$byClass["Recall"]*100,2),
"% | F1-Score : ",
round(cm_dt$byClass["F1"]*100,2), "%"),
x = "Valeur Réelle",
y = "Valeur Prédite"
) +
scale_x_discrete(labels = c("0" = "Pas Critique", "1" =
"Critique")) +
scale_y_discrete(labels = c("0" = "Pas Critique", "1" =
"Critique")) +
theme_minimal(base_size = 14) +
theme(
plot.title = element_text(face = "bold", size =
16, hjust = 0.5),
plot.subtitle = element_text(size = 11, hjust = 0.5,
color = "gray40"),
legend.position = "none",
panel.grid = element_blank()
)
