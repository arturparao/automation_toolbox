import pandas as pd
import os

def filter_data():
    print("🔍 Extrator Seletivo de Dados (Data Filter)")
    file_path = input("📄 Caminho do arquivo original (CSV/Excel): ").strip()
    
    if not os.path.exists(file_path):
        print("❌ Arquivo não encontrado!")
        return

    # Carregamento
    df = pd.read_csv(file_path) if file_path.endswith('.csv') else pd.read_excel(file_path)
    
    print(f"\n📋 Colunas disponíveis: {list(df.columns)}")
    column = input("🎯 Digite o nome da coluna para filtrar: ").strip()
    
    if column not in df.columns:
        print("❌ Coluna não encontrada!")
        return

    value = input(f"🔎 Filtrar por qual valor em '{column}'? ").strip()

    # Aplica o filtro (suporta números e textos)
    try:
        # Tenta converter para número se possível
        if df[column].dtype in ['int64', 'float64']:
            filtered_df = df[df[column] == float(value)]
        else:
            filtered_df = df[df[column].astype(str).str.contains(value, case=False, na=False)]
        
        if filtered_df.empty:
            print("⚠️ Nenhum dado encontrado com esse filtro.")
            return

        print(f"✅ Sucesso! {len(filtered_df)} linhas encontradas.")
        
        output_name = f"filtro_{value}_{os.path.basename(file_path)}"
        if file_path.endswith('.csv'):
            filtered_df.to_csv(output_name, index=False)
        else:
            filtered_df.to_excel(output_name, index=False)
            
        print(f"💾 Arquivo salvo como: {output_name}")

    except Exception as e:
        print(f"❌ Erro ao filtrar: {e}")

if __name__ == "__main__":
    filter_data()