# 🛠️ Automation Toolbox

Este repositório é uma coleção de ferramentas, scripts e configurações personalizadas para otimizar o fluxo de trabalho de desenvolvimento, análise de dados e produtividade no terminal.

---

## 🚀 Ferramentas Incluídas

### 1. **Git Retroactive Commits (`git_retro.py`)**
Um script em Python desenvolvido para automatizar a criação de commits com datas retroativas, garantindo que o histórico de contribuições reflita o progresso real, mesmo quando não houve sincronização no dia.

* **Funcionalidades**: Detecta a branch atual automaticamente e permite o envio de commits para datas passadas ou para o dia atual com apenas um comando.
* **Como usar**: Basta rodar o comando `auto` no terminal (após configurar o alias).

---

## 💻 Configurações de Terminal (WSL/Ubuntu)

Para maximizar a produtividade, utilizo **Aliases** que encurtam comandos complexos no Linux.

### Configuração de Aliases
Adicione estas linhas ao seu arquivo `~/.bashrc` para facilitar o uso das ferramentas deste repositório:

```bash
# Atalho para o script de automação de commits
alias auto='python3 ~/github/aparao/automation-toolbox/scripts/git_retro.py'

# Atalho para ferramentas dbt (exemplo)
alias dbtf='/home/aparao/.local/bin/dbt'

Aqui está o código completo em formato Markdown. Basta copiar o bloco abaixo e colar no seu arquivo README.md dentro do VS Code.

Markdown
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

---

## 💻 Configurações de Terminal (WSL/Ubuntu)

Aliases configurados no `~/.bashrc` para máxima agilidade:

```bash
alias auto='python3 ~/github/aparao/automation-toolbox/scripts/git_retro.py'
alias limpar='python3 ~/github/aparao/automation-toolbox/scripts/clean_data.py'
alias perfil='python3 ~/github/aparao/automation-toolbox/scripts/data_profiler.py'
alias unir='python3 ~/github/aparao/automation-toolbox/scripts/data_merger.py'
---
```
---
## 📈 Casos de Uso
Consistência no GitHub: Manter o gráfico de contribuições atualizado com estudos diários de SQL, Python e DAX.

Padronização: Garantir que todos os commits sigam um fluxo automatizado de add, commit e push sem erros de digitação.

Documentação: Uso de POPs (Procedimentos Operacionais Padrão) em Markdown para registrar processos complexos.

---
## 🛠️ Tecnologias Utilizadas
Python 3: Para lógica de automação de scripts.

Git & GitHub: Para controle de versão e gestão de portfólio.

Bash/Linux: Para personalização do ambiente de desenvolvimento via WSL.
