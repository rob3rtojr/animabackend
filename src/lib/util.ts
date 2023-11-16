export function formatName(name: string): string {
  const nameParts = name.split(' ')
  if (nameParts.length === 1) {
    // Se houver apenas um nome, retorna o próprio nome completo
    return name
  } else {
    // Pega o primeiro nome completo
    let formattedName = nameParts[0]

    // Itera pelos demais nomes e adiciona a primeira inicial
    for (let i = 1; i < nameParts.length; i++) {
      // "DA", "DO", "DE", "DOS", "DAS", "E", "DEL", "Y", "JUNIOR" = "JR."

      switch (nameParts[i].toUpperCase()) {
        case 'DA':
        case 'DAS':
        case 'DO':
        case 'DOS':
        case 'DE':
        case 'E':
        case 'DEL':
        case 'Y':
          formattedName += ` ${nameParts[i].toUpperCase()}`
          break

        case 'JUNIOR':
        case 'JÚNIOR':
          formattedName += ` JR`
          break

        default:
          formattedName += ` ${nameParts[i].charAt(0).toUpperCase()}.`
          break
      }
    }

    return formattedName
  }
}

// Função para atualizar os nomes dos alunos no array
export function atualizarNomes(pessoas: any[]): any[] {
  const atualizados: any[] = []

  for (const pessoa of pessoas) {
    const nomeAtualizado = formatName(pessoa.nome)
    atualizados.push({ ...pessoa, nome: nomeAtualizado })
  }

  return atualizados
}

export function replaceSpecialChars(str: string | undefined) {
  if (str === undefined) return ''

  str = str.replace(/[ÀÁÂÃÄÅ]/, 'A')
  str = str.replace(/[àáâãäå]/, 'a')
  str = str.replace(/[ÈÉÊË]/, 'E')
  str = str.replace(/[Ç]/, 'C')
  str = str.replace(/[ç]/, 'c')

  // o resto
  return str.replace(/[^a-z0-9]/gi, '')
}

export function getPrimeiroNome(nomeCompleto: string | undefined): string {
  if (nomeCompleto === undefined) return ''

  // Remova possíveis espaços em excesso antes e depois do nome
  const nomeSemEspacos = nomeCompleto.trim()

  // Divida o nome completo usando espaços como separadores
  const partesDoNome = nomeSemEspacos.split(' ')

  // O primeiro nome será o primeiro elemento do array resultante
  const primeiroNome = partesDoNome[0]

  return primeiroNome
}

export function removerCaracteres(valor: string): string {
  const valorFormatado = valor.replace(/\D/g, '')
  return valorFormatado
}
