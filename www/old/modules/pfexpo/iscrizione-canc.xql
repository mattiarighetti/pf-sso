<?xml version="1.0"?>
<queryset>
  <fullquery name="useradmin">
    <querytext>
      SELECT * FROM pf_iscritti WHERE user_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="domandecanc">
    <querytext>
      DELETE FROM pf_domande WHERE domanda_id = :domanda_id
    </querytext>
  </fullquery>
</queryset>