ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    expo_id:naturalnum
    {module "pfexpo"}
    relatore_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
if {[ad_form_new_p -key relatore_id]} {
    set page_title "Nuovo docente"
    set buttons [list [list "Aggiungi" new]]
} else {
    set page_title "Modifica docente"
    set buttons [list [list "Modifica" edit]]
}
set context [list [list ?module=pfexpo&template=modules%2Fpfexpo "PFEXPO"] [list ?module=pfexpo&expo_id=$expo_id&template=modules%2Fpfexpo%2Frelatori-list "Relatori"] $page_title]
ad_form -name relatore \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {expo_id module template} \
    -html {enctype "multipart/form-data"} \
    -form {
	relatore_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70 maxlength 100}}
	}
	{cognome:text
		{label "Cognome"}
		{html {size 70 maxlength 100}}
	}
	{short_cv:text(textarea),optional
	    {html {cols 70 rows 10 wrap soft}}
	    {label "Short CV"}
	    
	}
	{upload_file:text(file),optional
	    {help_text "Il file devessere nei formati: \".jpg\" o \".png\"."}
	    {label "Immagine"}
	}
    } -select_query {
	"SELECT relatore_id, short_cv, immagine AS upload_file, nome, cognome FROM expo_relatori WHERE relatore_id = :relatore_id"
    } -new_data {
	ns_log notice prova2
	if {$upload_file ne ""} {
	    db_transaction {
		set relatore_id [db_string query "SELECT COALESCE(MAX(relatore_id)+1,1) FROM expo_relatori"]	    
		regsub -all {\\} $upload_file "<" upload_file
		ns_log notice pippo231 $upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name $cognome
		    append file_name "_" $nome ".jpg"
		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name $cognome
		    append file_name "_" $nome ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/relatori_portraits/$file_name
		db_dml query "INSERT INTO expo_relatori (relatore_id, nome, cognome, short_cv, immagine) VALUES (:relatore_id, :nome, :cognome, :short_cv, :file_name)"    
	    }
	} else {
	    db_dml query "INSERT INTO expo_relatori (relatore_id, nome, cognome, short_cv) VALUES (:relatore_id, :nome, :cognome, :short_cv)"
	}
    } -edit_data {
    	if {$upload_file eq ""} {
	    db_dml query "UPDATE expo_relatori SET short_cv = :short_cv, nome = :nome, cognome = :cognome WHERE relatore_id = :relatore_id"
	} else {
	    db_transaction {
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
                set file_name $cognome
                append file_name "_" $nome ".jpg"
		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
                set file_name $cognome
                append file_name "_" $nome ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/relatori_portraits/$file_name
		db_dml query "UPDATE expo_docenti SET docente_id = :docente_id, short_cv = :short_cv, nome = :nome, cognome = :cognome, immagine = :file_name WHERE professionista_id = :professionista_id"
	    }
	}
    } -on_submit {
	ns_log notice prova3
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	ad_returnredirect "index?module=pfexpo&expo_id=$expo_id&template=modules%2Fpfexpo%2Frelatori-list"
	ad_script_abort
    }
