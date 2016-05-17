<?xml version="1.0"?>
<queryset>
  <fullquery name="useradmin">
    <querytext>
      SELECT * FROM pf_iscritti WHERE user_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="started">
    <querytext>
      SELECT * FROM pf_rispusr WHERE risposta_id IS NOT NULL AND esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="rispusrcanc">
    <querytext>
      DELETE FROM pf_rispusr WHERE esame_id = :esame_id    
    </querytext>
  </fullquery>
  <fullquery name="esamecanc">
    <querytext>
      DELETE FROM pf_esami WHERE esame_id = :esame_id
    </querytext>
  </fullquery>
</queryset>