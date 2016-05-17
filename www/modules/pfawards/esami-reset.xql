<?xml version="1.0"?>
<queryset>
  <fullquery name="useradmin">
    <querytext>
      SELECT * FROM pf_iscritti WHERE user_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="esamereset">
    <querytext>
      UPDATE pf_esami SET start_time = NULL WHERE esame_id = :esame_id
    </querytext>
  </fullquery>
</queryset>