class Examun {
  final int id;
  final String type;
  final DateTime heure_deb;
  final DateTime heure_fin;
  final int id_mat;
  final int id_sal;
  String matiere='';
  String salle='';
  Examun(this.id, this.type,this.heure_deb,this.heure_fin,this.id_mat, this.id_sal,this.matiere,this.salle);
}