import pandas as pd
import os

def generate_profile():
    print("📊 Analisador Rápido de Dados (Data Profiler)")
    file_path = input("📄 Digite o caminho do arquivo (CSV ou Excel): ").strip()
    
    if not os.path.exists(file_path):
        print("❌ Arquivo não encontrado!")
        return

    try:
        # Carregamento
        if file_path.endswith('.csv'):
            df = pd.read_csv(file_path)
        else:
            df = pd.read_excel(file_path)

        print("\n--- 📋 Resumo Geral ---")
        print(f"Total de Linhas: {df.shape[0]}")
        print(f"Total de Colunas: {df.shape[1]}")
        
        print("\n--- 🔍 Análise de Nulos e Tipos ---")
        print(df.info())
        
        print("\n--- 💰 Estatísticas Financeiras/Numéricas ---")
        # Mostra estatísticas apenas de colunas com números
        print(df.describe())

        # Salva um resumo em arquivo se o usuário quiser
        save = input("\n💾 Deseja salvar esse resumo em um arquivo .txt? (s/n): ").lower()
        if save == 's':
            with open("resumo_dados.txt", "w") as f:
                f.write(str(df.describe()))
            print("✅ Resumo salvo em 'resumo_dados.txt'!")

    except Exception as e:
        print(f"❌ Erro ao analisar: {e}")

if __name__ == "__main__":
    generate_profile()