import pandas as pd
import os
import glob

def merge_files():
    print("📂 Consolidador Automático de Arquivos (Data Merger)")
    folder_path = input("📁 Digite o caminho da pasta com os arquivos: ").strip()
    extension = input("📄 Tipo de arquivo (csv ou xlsx): ").lower().strip()
    
    if not os.path.exists(folder_path):
        print("❌ Pasta não encontrada!")
        return

    # Busca todos os arquivos com a extensão escolhida
    search_pattern = os.path.join(folder_path, f"*.{extension}")
    files = glob.glob(search_pattern)

    if not files:
        print(f"⚠️ Nenhum arquivo .{extension} encontrado na pasta.")
        return

    print(f"🔄 Encontrados {len(files)} arquivos. Iniciando consolidação...")

    all_data = []
    for file in files:
        try:
            if extension == 'csv':
                df = pd.read_csv(file)
            else:
                df = pd.read_excel(file)
            
            # Adiciona uma coluna com o nome do arquivo de origem (importante para auditoria)
            df['origem_arquivo'] = os.path.basename(file)
            all_data.append(df)
            print(f"✅ Lido: {os.path.basename(file)}")
        except Exception as e:
            print(f"❌ Erro ao ler {file}: {e}")

    if all_data:
        combined_df = pd.concat(all_data, ignore_index=True)
        output_name = f"consolidado_final.{extension}"
        
        if extension == 'csv':
            combined_df.to_csv(output_name, index=False)
        else:
            combined_df.to_excel(output_name, index=False)
            
        print(f"\n🚀 Sucesso! {len(files)} arquivos unidos em: {output_name}")
    else:
        print("❌ Nenhum dado foi processado.")

if __name__ == "__main__":
    merge_files()