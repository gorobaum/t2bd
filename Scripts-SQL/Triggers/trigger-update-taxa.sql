CREATE TRIGGER check_time BEFORE INSERT ON taxa 
    FOR EACH ROW
      DELETE FROM boleto WHERE boleto.id_cambio IN
          (SELECT id FROM cambio WHERE
             cambio.id_taxa_origem IN
               (SELECT id FROM taxa WHERE 
                  taxa.id_moeda = NEW.id_moeda AND (DAYOFTHEYEAR(CURDATE()) - DAYOFTHEYEAR(taxa.data)) <= 2)
                  OR cambio.id_taxa_destino IN 
                    (SELECT id FROM taxa WHERE taxa.id_moeda = NEW.id_moeda AND
                    (DAYOFTHEYEAR(CURDATE()) - DAYOFTHEYEAR(taxa.data)) <= 2))
                  AND boleto.pago = 0 AND (DAYOFTHEYEAR(CURDATE()) - DAYOFTHEYEAR(boleto.data)) <= 2;