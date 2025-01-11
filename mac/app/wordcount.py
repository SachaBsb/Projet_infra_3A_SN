# -*- coding: utf-8 -*-
import sys
from collections import Counter

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 wordcount.py <file>")
        sys.exit(1)

    file_path = sys.argv[1]
    print(f"Lecture du fichier : {file_path}")  # Debug

    try:
        # Lire le fichier
        with open(file_path, 'r') as f:
            text = f.read()
        print(f"Contenu lu : {text}")  # Debug
    except FileNotFoundError:
        print("Erreur : Fichier introuvable")
        sys.exit(1)

    # Compter les mots
    words = text.split()
    print(f"Mots trouvés : {words}")  # Debug
    word_count = Counter(words)

    # Afficher les résultats
    for word, count in word_count.items():
        print(f"{word}: {count}")

if __name__ == "__main__":
    main()
