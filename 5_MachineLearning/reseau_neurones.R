# ===== Réseau de Neurones =====
library(neuralnet)
library(caret)
train_nn <- train[, setdiff(names(train),
"has_promotion")]
test_nn <- test[, setdiff(names(test),
"has_promotion")]
dummies <- dummyVars(retour_critique ~ ., data =
train_nn)
train_enc <- as.data.frame(predict(dummies, newdata =
train_nn))
test_enc <- as.data.frame(predict(dummies, newdata =
test_nn))
train_enc$retour_critique <-
as.numeric(as.character(train_nn$retour_critique))
test_enc$retour_critique <-
as.numeric(as.character(test_nn$retour_critique))
normalize <- function(x) (x - min(x)) / (max(x) - min(x)
+ 1e-8)
train_norm <- as.data.frame(lapply(train_enc, normalize))
test_norm <- as.data.frame(lapply(test_enc, normalize))
features <- setdiff(names(train_norm),
"retour_critique")
formula_nn <- as.formula(paste("retour_critique ~",
paste(features, collapse =
" + ")))
model_nn <- neuralnet(formula_nn,
data = train_norm,
hidden = c(5),
linear.output = FALSE,
threshold = 0.1,
stepmax = 5e4)
pred_nn_raw <- compute(model_nn, test_norm[, features])
pred_nn <- factor(ifelse(pred_nn_raw$net.result > 0.5,
1, 0),
levels = c("0", "1"))
ref_nn <- factor(test_norm$retour_critique, levels =
c("0", "1"))
# Visualisation du réseau
plot(model_nn,
col.entry = "#AED6F1",
col.hidden = "#A9DFBF",
col.out = "#F9E79F",
show.weights = FALSE)
# Prédiction
pred_nn_raw <- compute(model_nn, test_norm[, features])
pred_nn <- factor(ifelse(pred_nn_raw$net.result > 0.5,
1, 0),
levels = c("0", "1"))
ref_nn <- factor(test_norm$retour_critique, levels =
c("0", "1"))
# Évaluation
cm_nn <- confusionMatrix(pred_nn, ref_nn)
cat("=== MÉTRIQUES RÉSEAU DE NEURONES ===\n")
cat("Accuracy :", round(cm_nn$overall["Accuracy"] * 100,
2), "%\n")
cat("Précision :", round(cm_nn$byClass["Precision"] * 100,
2), "%\n")
cat("Recall :", round(cm_nn$byClass["Recall"] * 100,
2), "%\n")
cat("F1-Score :", round(cm_nn$byClass["F1"] * 100, 2),
"%\n"