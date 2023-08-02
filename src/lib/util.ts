type Pessoa = {
    id: number,
    nome: string
  }

export function formatName(name: string): string {
    const nameParts = name.split(' ');
    if (nameParts.length === 1) {
      // Se houver apenas um nome, retorna o próprio nome completo
      return name;
    } else {
      // Pega o primeiro nome completo
      let formattedName = nameParts[0];
  
      // Itera pelos demais nomes e adiciona a primeira inicial
      for (let i = 1; i < nameParts.length; i++) {
        //"DA", "DO", "DE", "DOS", "DAS", "E", "DEL", "Y", "JUNIOR" = "JR."
  
        switch (nameParts[i].toUpperCase()) {
          case "DA":
          case "DAS":
          case "DO":
          case "DOS":
          case "DE":
          case "E":
          case "DEL":
          case "Y":
            formattedName += ` ${nameParts[i].toUpperCase()}`;
            break;
          
          case "JUNIOR":
          case "JÚNIOR":
            formattedName += ` JR`;
            break;
  
          default:
            formattedName += ` ${nameParts[i].charAt(0).toUpperCase()}.`;
            break;
        }
  
        
      }
  
      return formattedName;
    }
  }
  
  // Função para atualizar os nomes dos alunos no array
  export function atualizarNomes(pessoas: Pessoa[]): Pessoa[] {
    const atualizados: Pessoa[] = [];
  
    for (const pessoa of pessoas) {
      const nomeAtualizado = formatName(pessoa.nome);
      atualizados.push({ ...pessoa, nome: nomeAtualizado });
    }
  
    return atualizados;
  }