class Surveillance{
  final int id;
  final DateTime date_debut;
  final DateTime date_fin;
  final int surveillant_id;
  final int salle_id;
  String surveillant;
  String salle;
  Surveillance(this.id,this.date_debut,this.date_fin,this.surveillant_id,this.salle_id,this.surveillant,this.salle);
}