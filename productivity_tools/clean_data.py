import pandas as pd
import os
import re

def clean_column_names(df):
    # Transforma em minúsculo, remove acentos e substitui espaços por '_'
    df.columns = [re.sub(r'\W+', '', c.replace(' ', '_').lower()) for c in df.columns]
    return df

def process_file():
    print("🧹 limpador de Dados para SQL/Power BI")
    file_path = input("📄 Arraste o arquivo ou digite o caminho (CSV ou Excel): ").strip()
    if not os.path.exists(file_path):
        print("❌ Arquivo não encontrado!")
        return
    # Identifica o formato
    if file_path.endswith('.csv'):
        df = pd.read_csv(file_path)
    elif file_path.endswith(('.xls', '.xlsx')):
        df = pd.read_excel(file_path)
    else:
        print("❌ Formato não suportado!")
        return
    # Limpeza
    df = clean_column_names(df)
    # Salva o resultado
    output_path = f"cleaned_{os.path.basename(file_path)}"
    if file_path.endswith('.csv'):
        df.to_csv(output_path, index=False)
    else:
        df.to_excel(output_path, index=False)
    print(f"\n✅ Sucesso! Arquivo limpo salvo como: {output_path}")
    print(f"📋 Colunas prontas para SQL: {list(df.columns)}")

if __name__ == "__main__":
    process_file()