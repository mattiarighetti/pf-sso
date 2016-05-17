<?xml version="1.0"?>
<queryset>
  <fullquery name="utente">
    <querytext>
      SELECT first_names||' '||last_name FROM persons WHERE person_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="domanda">
    <querytext>
      SELECT d.corpo, d.domanda_id FROM pf_domande d, pf_rispusr s WHERE d.domanda_id = s.domanda_id and s.esame_id = :esame_id ORDER BY s.domanda_id
    </querytext>
  </fullquery>

</queryset>