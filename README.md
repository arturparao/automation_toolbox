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
(Lembre-se de rodar source ~/.bashrc após a edição para ativar os novos comandos).
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
