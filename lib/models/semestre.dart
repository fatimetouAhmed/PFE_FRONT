class Semestre {
  final int id;
  final String nom;
  final int id_fil;
  final DateTime date_debut;
  final DateTime date_fin;
  String filiere='';
  Semestre(this.id, this.nom,this.id_fil,this.date_debut,this.date_fin, this.filiere);
}