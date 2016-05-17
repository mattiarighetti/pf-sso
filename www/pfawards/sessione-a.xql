<?xml version="1.0"?>
<queryset>
  <fullquery name="categoria">
    <querytext>
      SELECT c.descrizione FROM pf_categorie c, pf_esami e WHERE e.categoria_id = c.categoria_id AND e.esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="utente">
    <querytext>
      SELECT first_names||' '||last_name FROM persons WHERE person_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="adesso">
    <querytext>
      SELECT CURRENT_TIMESTAMP
    </querytext>
  </fullquery>
  <fullquery name="rispusrid">
    <querytext>
      SELECT rispusr_id FROM pf_rispusr WHERE esame_id = :esame_id ORDER BY rispusr_id LIMIT 1
    </querytext>
  </fullquery>
  <fullquery name="instime">
    <querytext>
      UPDATE pf_esami SET start_time = :now WHERE esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="domanda_id">
    <querytext>
      SELECT domanda_id FROM pf_rispusr WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="domanda">
    <querytext>
      SELECT corpo FROM pf_domande WHERE domanda_id = :domanda_id
    </querytext>
  </fullquery>
  <fullquery name="risp_ok">
    <querytext>
      SELECT risposta_id FROM pf_rispusr WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="risposte">
    <querytext>
      SELECT corpo, risposta_id FROM pf_risposte WHERE domanda_id = ${domanda_id} ORDER BY RANDOM()
    </querytext>
  </fullquery>
  <fullquery name="ins_risp">
    <querytext>
      INSERT INTO pf_rispusr (risposta_id) VALUES (:risposta_id) WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="upd_risp">
    <querytext>
      UPDATE pf_rispusr SET risposta_id = :risposta_id WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="righello">
    <querytext>
      SELECT rispusr_id FROM pf_rispusr WHERE esame_id = :esame_id ORDER BY rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="load_risposta">
    <querytext>
      SELECT risposta_id FROM pf_rispusr WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
</queryset>