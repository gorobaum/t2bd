input = File.new('./input.sql', 'w')

input.printf("INSERT INTO moeda(nome) VALUES('moeda1');")
input.printf("INSERT INTO moeda(nome) VALUES('moeda2');")

input.printf("INSERT INTO taxa(valor, data, id_moeda) VALUES(10.0, '#{(Time.now - 86400).strftime('%Y-%m-%d %H:%M:%S')}', 1);");
input.printf("INSERT INTO taxa(valor, data, id_moeda) VALUES(5.0, '#{(Time.now - 86400).strftime('%Y-%m-%d %H:%M:%S')}', 2);");

input.printf("INSERT INTO cambio(id_taxa_origem, id_taxa_destino) VALUES(1,2);")

for i in 1..(ARGV[0].to_i)
	input.printf("INSERT INTO boleto(pago, valor, id_cambio, data) VALUES(0,10.00,1,'#{(Time.now - (2*86400)).strftime('%Y-%m-%d %H:%M:%S')}');");
end

input.close
