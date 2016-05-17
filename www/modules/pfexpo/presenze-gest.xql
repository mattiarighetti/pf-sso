<?xml version="1.0"?>
<queryset>
  <fullquery name="useradmin">
    <querytext>
      SELECT * FROM pf_iscritti WHERE user_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="iscrittonum">
    <querytext>
      SELECT 'Numero #'||iscritto_id FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id
    </querytext>
  </fullquery>
  <fullquery name="selectiscrizione">
    <querytext>
      SELECT nome, cognome FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id
    </querytext>
  </fullquery>
  <fullquery name="eventilist">
    <querytext>
      SELECT descrizione, evento_id FROM pf_expo_eventi
    </querytext>
  </fullquery>
  <fullquery name="maxiscrittoid">
    <querytext>
      SELECT COALESCE(MAX(iscritto_id)+1,1) FROM pf_expo_iscr
    </querytext>
  </fullquery>
  <fullquery name="insert">
    <querytext>
      INSERT INTO pf_expo_iscr (iscritto_id, nome, cognome) VALUES (:iscritto_id, :nome, :cognome)
    </querytext>
  </fullquery>
  <fullquery name="update">
    <querytext>
      UPDATE pf_expo_iscr SET nome = :nome, cognome = :cognome WHERE iscritto_id = :iscritto_id
    </querytext>
  </fullquery>
</queryset>