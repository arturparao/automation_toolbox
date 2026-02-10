# 🛠️ Automation Toolbox

Este repositório é uma coleção de ferramentas, scripts e configurações personalizadas para otimizar o fluxo de trabalho de desenvolvimento, análise de dados e produtividade no terminal.

---

## 🚀 Ferramentas Incluídas

### 1. **Git Retroactive Commits (`git_retro.py`)**
Automatiza a criação de commits com datas retroativas, garantindo que o histórico de contribuições reflita o progresso real.
* **Funcionalidades**: Detecta a branch atual automaticamente e permite envios retroativos ou atuais.
* **Como usar**: Comando `auto`.

### 2. **Data Cleaner (`clean_data.py`)**
Padroniza arquivos CSV ou Excel para importação em bancos de dados ou Power BI.
* **Funcionalidades**: Converte nomes de colunas para `snake_case`, remove acentos e caracteres especiais.
* **Como usar**: Comando `limpar`.

### 3. **Data Profiler (`data_profiler.py`)**
Realiza auditoria e pré-análise imediata de planilhas de Controladoria e Centro de Custo.
* **Funcionalidades**: Identifica lacunas (nulos) e inconsistências (outliers) em métricas como Prazo Médio.
* **Como usar**: Comando `perfil`.

### 4. **Data Merger (`data_merger.py`)**
Consolida múltiplos arquivos (mensais ou por unidade) em uma única base de dados.
* **Funcionalidades**: Une vários arquivos Excel/CSV de uma pasta e cria uma coluna `origem_arquivo` para auditoria.
* **Como usar**: Comando `unir`.

### 5. **Data Filter (`data_filter.py`)**
Extrator seletivo de dados para gerar relatórios específicos a partir de bases volumosas.
* **Funcionalidades**: Filtra colunas por palavras-chave ou valores numéricos e exporta o resultado instantaneamente.
* **Como usar**: Comando `filtrar`.

---

## 💻 Configurações de Terminal (WSL/Ubuntu)

Aliases configurados no `~/.bashrc` para máxima agilidade:

```bash
alias auto='python3 ~/github/aparao/automation-toolbox/scripts/git_retro.py'
alias limpar='python3 ~/github/aparao/automation-toolbox/scripts/clean_data.py'
alias perfil='python3 ~/github/aparao/automation-toolbox/scripts/data_profiler.py'
alias unir='python3 ~/github/aparao/automation-toolbox/scripts/data_merger.py'
alias filtrar='python3 ~/github/aparao/automation-toolbox/scripts/data_filter.py'
