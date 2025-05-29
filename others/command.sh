gcloud projects add-iam-policy-binding gfbiuser-zwer-48ot-y44d-0xlp7b \
--member="serviceAccount:dummy-sa@gfbiuser-zwer-48ot-y44d-0xlp7b.iam.gserviceaccount.com" \
--role="projects/gfbiuser-zwer-48ot-y44d-0xlp7b/roles/eis_sectools_scoped_role" \
--condition="expression=resource.type == 'iam.googleapis.com/Role' && resource.service == 'iam.googleapis.com' && resource.name.extract('/roles/{role_id}').startsWith('dig-'),title=Restrict IAM Role Management to 'dig-' prefixed roles on IAM service"