#!/bin/bash

# --- KONFIGURACJA PROD ---
RESOURCE_GROUP="rg-devops-poc01"
CLUSTER_NAME="devops-poc01-prod"
CONTEXT="devops-poc01-prod"
MANIFEST="argocd-adrian-java-app-prod.yaml"

echo "---------------------------------------------------"
echo "🚨 WDRAŻANIE NA ŚRODOWISKO: PRODUKCJA (PROD)"
echo "---------------------------------------------------"

# 1. Pobranie poświadczeń dla klastra PROD
echo "🔄 Pobieranie poświadczeń AKS dla PRODUKCJI..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

# 2. Przełączenie kontekstu na PROD
echo "🎯 Ustawianie kontekstu na $CONTEXT..."
kubectl config use-context $CONTEXT

# 3. Weryfikacja pliku i aplikowanie
if [ -f "$MANIFEST" ]; then
    echo "📄 Aplikowanie manifestu produkcyjnego: $MANIFEST..."
    kubectl apply -f $MANIFEST
    
    if [ $? -eq 0 ]; then
        echo "✅ Sukces: Manifest produkcyjny został zaaplikowany."
    else
        echo "❌ BŁĄD: Coś poszło nie tak przy wdrażaniu na PROD!"
        exit 1
    fi
else
    echo "⚠️ Błąd: Nie znaleziono pliku $MANIFEST!"
    exit 1
fi

echo "---------------------------------------------------"
echo "🏁 Proces zakończony dla klastra PROD."