import subprocess
import os
from datetime import datetime
def run_git_retro():
    print("🚀 Automador de Commits (Retroativo ou Atual)")
    # Detecta a branch atual automaticamente
    branch = subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"]).decode("utf-8").strip()
    # 1. Solicita a data (Se vazio, usa hoje)
    data_input = input(f"📅 Data AAAA-MM-DD (Deixe vazio para HOJE): ")
    if not data_input:
        data_formatada = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
        tipo_envio = "ATUAL"
    else:
        data_formatada = f"{data_input}T12:00:00"
        tipo_envio = "RETROATIVO"
    # 2. Solicita a mensagem
    mensagem = input("💬 Mensagem do commit: ") or "Update automático"
    env = os.environ.copy()
    env["GIT_AUTHOR_DATE"] = data_formatada
    env["GIT_COMMITTER_DATE"] = data_formatada
    try:
        subprocess.run(["git", "add", "."], check=True)
        print(f"✍️ Fazendo commit {tipo_envio} na branch [{branch}]...")
        subprocess.run(["git", "commit", "-m", mensagem], env=env, check=True)
        print(f"☁️ Enviando para origin/{branch}...")
        subprocess.run(["git", "push", "origin", branch], check=True)
        print(f"\n✅ Sucesso na branch {branch}!")
    except Exception as e:
        print(f"\n❌ Erro: {e}")
if __name__ == "__main__":
    run_git_retro()