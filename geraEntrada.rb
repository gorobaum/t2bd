input = File.new('./input.sql', 'w')

input.printf("INSERT INTO moeda(nome) VALUES('moeda1');")
input.printf("INSERT INTO moeda(nome) VALUES('moeda2');")

input.printf("INSERT INTO taxa(valor, data, id_moeda) VALUES(10.0, #{Time.now - 86400}, 1);");
input.printf("INSERT INTO taxa(valor, data, id_moeda) VALUES(5.0, #{Time.now - 86400}, 2);");

input.close
