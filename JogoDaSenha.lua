--[[
	Programa : JogoDaSenha.lua
	Autor : Mauricio De Castro Lana
	Data da última modificação: 10/04/2017
	Versão : 1.0
	Tamanho : 192 linhas
]]

--[[
	Descrição : recebe uma tabela e retorna uma copia exata da tabla
	Pre-Condição : receber uma tabla instanciada
	Pos-Condição : retornar uma copia da TableOriginal
]]
function ClonarTable(TableOriginal)
	TableCopia = {}
	for Chave, Valor in pairs(TableOriginal) do
		TableCopia[Chave] = Valor
	end
	return TableCopia
end

--[[
	Descrição : recebe uma table e retorna a table invertida
	Pre-Condição : receber uma tabla instanciada
	Pos-Condição : retornar uma copia da TableOriginal invertida
]]
function InvertTable(TableOriginal)
	TableInvertida = {}
	Indice = table.getn(TableOriginal)
	
	for _, Value in pairs(TableOriginal) do
		TableInvertida[Indice] = Value
		Indice = Indice - 1
	end
	
	return TableInvertida
end

--[[
	Descrição : requisita que o usuario degite senhas no input padrão, até a senha digita ser valida, e entao retorna a senha na forma de table
	Pre-Condição : usuario seja capaz de digitar
	Pos-Condição : retornar table contendo uma senha valida
]]
function ObterSenha()
	
	while true do
		Senha = io.read()
		if TestaValidadeSenha(ConverteNumeroSenha(Senha)) == true then
			break
		else
			print('Senha Invalida')
		end
	end 
	
	return InvertTable(Senha)
end

--[[
	Descrição : recebe uma string de senha e retorna a senha em formato de table
	Pre-Condição : receber uma string contendo uma sequencia de digitos inteiros no intervalo [1, 9]
	Pos-Condição : retornar uma table contando a senha invertida
]]
function ConverteNumeroSenha(Numero)
	Senha = {}
	if tonumber(Numero) == nil then
		return {}
	end
	Numero = tonumber(Numero)
	
	while Numero > 0 do
		table.insert(Senha, Numero % 10)
		Numero = math.floor(Numero / 10)
	end

	return Senha
end


--[[
	Descrição : recebe uma senha e retorna true se é uma senha valida e false caso contrario
	Pre-Condição : receber uma table contendo uma senha
	Pos-Condição : retornar true caso a senha contida na table seja valida e false caso seja invalida
]]
function TestaValidadeSenha(Senha)
	
	if table.getn(Senha) ~= 4 then
		return false
	end
		
	for _, Valor in pairs(Senha) do
		if Valor < 1 or Valor > 9 then
			return false
		end
	end
	
	return true
end

--[[
	Descrição : retorna uma senha aleatoria
	Pre-Condição : randomseed deve estar inicializado com os.time()
	Pos-Condição : retornar uma table contendo uma senha aleatoria
]]
function GerarSenha()

	local senha = {}
	for i=1,4 do
		table.insert(senha, math.random(1,9))
	end

	return senha
end

--[[
	Descrição : recebe duas senhas(Original e a ser testada) e retorna a quantidade de numeros corretos na posição correta, e a quantidade de numeros corretos na posição errada
	Pre-Condição : receber duas tables contendo senhas
	Pos-Condição : retornar dois ints contendo a quantidade de numeros corretos na posição correta, e a quantidade de numeros
]]
function ComparaSenha(SenhaOriginal, SenhaTeste) 
	QtdLugarCorreto = 0
	QtdLugarErrado = 0
	
	for ChaveOriginal, ValorOriginal in pairs(SenhaOriginal) do
		
		if SenhaTeste[ChaveOriginal] == ValorOriginal then
			QtdLugarCorreto = QtdLugarCorreto + 1
			SenhaTeste[ChaveOriginal] = -1
			SenhaOriginal[ChaveOriginal] = -1
		end
			
	end
	
	for ChaveOriginal, ValorOriginal in pairs(SenhaOriginal) do
		for ChaveTeste, ValorTeste in pairs(SenhaTeste) do
					
			if ValorOriginal == ValorTeste and ValorOriginal ~= -1 then
				QtdLugarErrado =  QtdLugarErrado + 1
				SenhaTeste[ChaveTeste] = -1
				SenhaOriginal[ChaveOriginal] = -1
				break
			end
			
		end
	end

	
	return QtdLugarCorreto, QtdLugarErrado
end

--[[
	Descrição : função main
	Pre-Condição : ser chamada apenas uma vez no inicio do programa
	Pos-Condição : não haver chamada de função apos termino da main
]]
function main()
	
	math.randomseed(os.time())--inicializa a randomseed para o clock
	
	SenhaPC = GerarSenha()--gera a senha do computador
	
	QtdLugarCorreto = 0--inicializa variavel representativa de quantidade de numeros corretos no lugar correto
	QtdLugarErrado = 0--inicializa variavel representativa de quantidade de numeros corretos no lugar errado
	LimiteJogadas = 10--inicializa o limite de jogadas
	
	print('Bem Vindo ao Jogo da Senha')--infomação introdutoria
	print('Seu Objetivo é acetar a senha gerada pelo computado em até ' .. LimiteJogadas .. ' jogadas, usando apenas as dicas dadas pelo compudaor')
	print()
	
	for i, v in pairs(SenhaPC) do--enquanto
		print(i, v)
		end
	
	--main loop
	for i=LimiteJogadas,0,-1 do--enquanto o limite de jogadas não foi ultrapassado
		print('Digite uma senha')--informa o usuario para digitar uma senha
		SenhaUsuario = ObterSenha()--recebe uma senha do usuario
		QtdLugarCorreto, QtdLugarErrado = ComparaSenha(ClonarTable(SenhaPC), ClonarTable(SenhaUsuario))--compara ela com a senha do pc
		print(QtdLugarCorreto .. ' numeros corretos na posição correta')--informa a quantidade de numeros corretos no lugar correto
		print(QtdLugarErrado .. ' numeros corretos na posição errada')--informa a quantidade de numeros corretos no lugar errado
		if QtdLugarCorreto == 4 then--caso a quantidade de numeros corretos no lugar correto seja o tamanho da senha
			break--sai do main loop
		end
	end
	
	if QtdLugarCorreto == 4 then--caso a quantidade de numeros corretos no lugar correto seja o tamanho da senha
		print("parabens, você acertou a senha")--informa que o usuairo acetou a senha
	else--caso contrario
		print('Limite de tentativas excedido')--informa que o limite de tentativas foi excedido
	end
end
	
main()