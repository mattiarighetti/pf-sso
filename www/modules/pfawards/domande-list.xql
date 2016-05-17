<?xml version="1.0"?>
<queryset>
  <fullquery name="useradmin">
    <querytext>
      SELECT * FROM pf_iscritti WHERE user_id = :user_id
    </querytext>
  </fullquery>
  <fullquery name="categorielist">
    <querytext>
      SELECT descrizione, categoria_id FROM pf_categorie ORDER BY descrizione
    </querytext>
  </fullquery>
  <fullquery name="domandelist">
    <querytext>
      SELECT '#'||d.domanda_id AS numero, d.domanda_id, d.corpo, c.descrizione, c.categoria_id, MAX(r.punti) AS punti_s FROM pf_categorie c, pf_domande d LEFT OUTER JOIN pf_risposte r ON d.domanda_id = r.domanda_id WHERE d.categoria_id = c.categoria_id [template::list::filter_where_clauses -name domande -and] GROUP BY numero, d.corpo, c.descrizione, c.categoria_id, d.domanda_id [template::list::orderby_clause -name domande -orderby] LIMIT $rows_per_page OFFSET $offset
    </querytext>
  </fullquery>
</queryset>